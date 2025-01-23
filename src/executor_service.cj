/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights resveved.
 */
package mbassador4cj

import std.sync.*
import std.collection.concurrent.*
import std.collection.*
import std.time.*

public class ExecutorService {
    //任务队列
    var registerTaskQueue: BlockingQueue<Event> = BlockingQueue<Event>()
    var unRegisterTaskQueue: BlockingQueue<Event> = BlockingQueue<Event>()
    var publishTaskQueue: BlockingQueue<Event> = BlockingQueue<Event>()
    var futures: ArrayList<Future<Unit>> = ArrayList<Future<Unit>>()

    var subscriberParallel: Int64 = 1
    var unsubscriberParallel: Int64 = 1
    var publishParallel: Int64 = 1

    public init() {}

    /*
     * 自定义并行度，参数顺序：订阅，取消订阅，发布
     */
    public init(subscriberParallel: Int64, unsubscriberParallel: Int64, publishParallel: Int64) {
        this.subscriberParallel = subscriberParallel
        this.unsubscriberParallel = unsubscriberParallel
        this.publishParallel = publishParallel
    }
    /*
     * 入口函数 业务逻辑：根据发布，订阅，取消订阅 类型入不同的队列 起各自的线程处理业务
     */
    func asyncExec(featureType: FeatureType, mbassadorConfiguration: MbassadorConfiguration,
        eventQueue: BlockingQueue<Event>): Unit {
        match (featureType) {
            case FeatureType.REGISTER =>
                futures.add(executeRegister(mbassadorConfiguration, eventQueue))
            case FeatureType.UNREGISTER =>
                futures.add(executeUnRegister(mbassadorConfiguration, eventQueue))
            case FeatureType.PUBLISH =>
                futures.add(executePublish(mbassadorConfiguration, eventQueue))
        }
    }
    private func executeRegister(mbassadorConfiguration: MbassadorConfiguration, eventQueue: BlockingQueue<Event>): Future<Unit> {
        //入队列 
        dataToQueue(eventQueue, registerTaskQueue)
        let pool: CoroutinePool = CoroutinePool(subscriberParallel)
        var exector: Exector = mbassadorConfiguration.getExector(Constant.REGISTER)
        var future: Future<Unit> = pool.sumbmit(exector, registerTaskQueue)
        return future
    }

    private func executeUnRegister(mbassadorConfiguration: MbassadorConfiguration, eventQueue: BlockingQueue<Event>): Future<Unit> {
        dataToQueue(eventQueue, unRegisterTaskQueue)
        let pool = CoroutinePool(unsubscriberParallel)
        var exector: Exector = mbassadorConfiguration.getExector(Constant.UNREGISTER)
        var future: Future<Unit> = pool.sumbmit(exector, unRegisterTaskQueue)
        return future
    }
    private func executePublish(mbassadorConfiguration: MbassadorConfiguration, eventQueue: BlockingQueue<Event>): Future<Unit> {
        //入队列 
        dataToQueue(eventQueue, publishTaskQueue)
        let pool = CoroutinePool(publishParallel)
        var exector: Exector = mbassadorConfiguration.getExector(Constant.PUBLISH)
        var future: Future<Unit> = pool.sumbmit(exector, publishTaskQueue)
        return future
    }

    //入队列
    private func dataToQueue(eventQueue: BlockingQueue<Event>, taskQueue: BlockingQueue<Event>): Unit {
        for (_ in 0..eventQueue.size) {
            taskQueue.enqueue(eventQueue.dequeue())
        }
    }
}

//抽象一个协程类，包含创建，取消，状态变化
public class Woreker {
    private var state: CoroutineState = CoroutineState.IDLE

    init() {}

    func start(exector: Exector, task: Event): Unit {
        this.state = CoroutineState.RUNNING
        let future = spawn {
            exector.execute(task)
        }
    }

    func recover(): Unit {
        this.state = CoroutineState.IDLE
    }

    public func getState(): CoroutineState {
        return this.state
    }
    public func setState(state: CoroutineState): Unit {
        this.state = state
    }
}

public enum CoroutineState {
    IDLE | RUNNING
}

public class CoroutinePool {
    //协程集合
    private var workers: ArrayList<Woreker> = ArrayList<Woreker>()

    //初始化
    init(parallel: Int64) {
        for (_ in 0..parallel) {
            // let woreker =
            workers.add( Woreker())
        }
    }
    //按照先进先出的方式处理任务，一个event过来，找一个空闲的协程处理
    public func sumbmit(exector: Exector, taskQueue: BlockingQueue<Event>): Future<Unit> {
        let future = spawn {
            while (true) {
                var task: Event = taskQueue.dequeue()
                var isStart: Bool = false
                //轮询找到空闲线程，提交
                for (worker in workers) {
                    match (worker.getState()) {
                        case IDLE =>
                            //启动任务
                            isStart = true
                            worker.start(exector, task)
                            break
                        case RUNNING =>
                            // 检查任务完成标志，如果完成，修改协程状态
                            if (exector.isFinshed()) {
                                worker.recover()
                            }
                    }
                }
                //如果没有空闲协程，任务重新入任务队列
                if (!isStart) {
                    taskQueue.enqueue(task)
                }
            }
        }
        return future
    }
}
