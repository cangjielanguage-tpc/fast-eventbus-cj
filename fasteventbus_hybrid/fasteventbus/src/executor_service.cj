/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package fasteventbus

import std.sync.*
import std.collection.concurrent.*
import std.collection.*
import std.time.*
import std.runtime.*
import std.math.*

public class ExecutorService {
    //任务队列
    var registerTaskQueue: LinkedBlockingQueue<Event> = LinkedBlockingQueue<Event>()
    var unRegisterTaskQueue: LinkedBlockingQueue<Event> = LinkedBlockingQueue<Event>()
    var publishTaskQueue: LinkedBlockingQueue<Event> = LinkedBlockingQueue<Event>()
    var futures: ArrayList<Future<Unit>> = ArrayList<Future<Unit>>()

    public var subscriberParallel: Int64 = 1
    public var unsubscriberParallel: Int64 = 1
    public var publishParallel: Int64 = 1

    public init() {}

    /*
     * 自定义并行度，参数顺序：订阅，取消订阅，发布
     */
    public init(subscriberParallel: Int64, unsubscriberParallel: Int64, publishParallel: Int64) {
        //去除负数
        if(checkSingleInputValid(subscriberParallel)){
            this.subscriberParallel = subscriberParallel
        }
        if(checkSingleInputValid(unsubscriberParallel)){
            this.unsubscriberParallel = unsubscriberParallel
        }
        if(checkSingleInputValid(publishParallel)){
            this.publishParallel = publishParallel
        }
        //控制最大并行数，所有的线程数求和 <= cpu核数*2
        
        let cpuCount = getProcessorCount()
        let limitcpuCount = cpuCount*2
        var totalThreadNumber = subscriberParallel + unsubscriberParallel + publishParallel
        if(checkInputValid(limitcpuCount,totalThreadNumber)){
            return
        }
        this.subscriberParallel = Int64(Float32(limitcpuCount) * (Float32(subscriberParallel)/Float32(totalThreadNumber)))
        this.unsubscriberParallel = Int64(Float32(limitcpuCount) * (Float32(unsubscriberParallel)/Float32(totalThreadNumber)))
        this.publishParallel = Int64(Float32(limitcpuCount) * (Float32(publishParallel)/Float32(totalThreadNumber)))
    }
    private func checkSingleInputValid(parallel: Int64):Bool{
        if(parallel <= 0){
            return false
        }
        return true
    }
    private func checkInputValid(limitcpuCount:Int64,totalThreadNumber: Int64):Bool{
        if(totalThreadNumber > limitcpuCount){
            return false
        }
        return true
    }

    /*
     * 入口函数 业务逻辑：根据发布，订阅，取消订阅 类型入不同的队列 起各自的线程处理业务
     */
    func asyncExec(featureType: FeatureType, mbassadorConfiguration: MbassadorConfiguration,
        eventQueue: LinkedBlockingQueue<Event>): Unit {
        match (featureType) {
            case FeatureType.REGISTER =>
                futures.add(executeRegister(mbassadorConfiguration, eventQueue))
            case FeatureType.UNREGISTER =>
                futures.add(executeUnRegister(mbassadorConfiguration, eventQueue))
            case FeatureType.PUBLISH =>
                futures.add(executePublish(mbassadorConfiguration, eventQueue))
        }
    }
    private func executeRegister(mbassadorConfiguration: MbassadorConfiguration, eventQueue: LinkedBlockingQueue<Event>): Future<Unit> {
        //入队列 
        dataToQueue(eventQueue, registerTaskQueue)
        let pool: CoroutinePool = CoroutinePool(subscriberParallel)
        var exector: SubscriberFactory = mbassadorConfiguration.subscriberFactorry
        var future: Future<Unit> = pool.sumbmit(exector, registerTaskQueue)
        return future
    }

    private func executeUnRegister(mbassadorConfiguration: MbassadorConfiguration, eventQueue: LinkedBlockingQueue<Event>): Future<Unit> {
        dataToQueue(eventQueue, unRegisterTaskQueue)
        let pool = CoroutinePool(unsubscriberParallel)
        var exector: UnSubscriberFactory = mbassadorConfiguration.unSubscriberFactory
        var future: Future<Unit> = pool.sumbmit(exector, unRegisterTaskQueue)
        return future
    }
    private func executePublish(mbassadorConfiguration: MbassadorConfiguration, eventQueue: LinkedBlockingQueue<Event>): Future<Unit> {
        //入队列 
        dataToQueue(eventQueue, publishTaskQueue)
        let pool = CoroutinePool(publishParallel)
        var exector: PublisherFactory = mbassadorConfiguration.publisherFactory
        var future: Future<Unit> = pool.sumbmit(exector, publishTaskQueue)
        return future
    }

    //入队列
    private func dataToQueue(eventQueue: LinkedBlockingQueue<Event>, taskQueue: LinkedBlockingQueue<Event>): Unit {
        for (_ in 0..eventQueue.size) {
            taskQueue.add(eventQueue.remove())
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
    public func sumbmit(exector: Exector, taskQueue: LinkedBlockingQueue<Event>): Future<Unit> {
        let future = spawn {
            while (true) {
                var task: Event = taskQueue.remove()
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
                    taskQueue.add(task)
                }
            }
        }
        return future
    }
}
