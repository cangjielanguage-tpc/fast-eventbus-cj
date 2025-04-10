# eventbus4cj 库

### 介绍

mbassador4cj 一种是发布/订阅事件总线。为多线程应用程序中的高吞吐量而优化的强大事件总线。支持同步和异步事件发布，事件过滤功能。

### 1 事件订阅和发布

1. 发布/订阅事件总线
是否商用：是
目标：
验收标准：
1. 能够实现组件之间通过发布/订阅事件进行总线通信
依赖的需求
资料：涉及
操作系统类型：OHOS，Linux

#### 1.1 定义事件

##### 1.1.1 主要接口
```cangjie
/*
* 事件接口，包含三个参数，事件类型名称，订阅者，发布者，是事件总线的最小执行单元
*/
public class Event {
    private var evevtTypeName: ?String = None
    private var subscriber: ?Subscriber = None
    private var publisher: ?Publisher = None

    init(evevtTypeName: String, subscriber: Subscriber, publisher: Publisher) {
        this.evevtTypeName = evevtTypeName
        this.subscriber = subscriber
        this.publisher = publisher
    }
}

/*
* 订阅者接口
*/
public interface Subscriber {
    func onEvent(event: Event): Unit
}
/*
* 发布者接口
*/
public interface Publisher {
    func publish(event: Event): Unit
}
/*
* 过滤器接口
*/
public interface Filter{
    func filter(event: ArrayList<Event>): ArrayList<Event>
}
```
#### 1.2 初始化
用户通过实现Subscribe接口实例化监听者，通过实现Publisher接口实例化发布者，通过实现Filter接口实例化过滤器
```cangjie
/*
* 用户实现订阅者
*/
private var counter: AtomicInt64 = AtomicInt64(1)
class IntegerSubscriber <: Subscriber {

    public func getCounter():Int64{

        var tmp:Int64 = counter.load()
        println("counter:>> ${tmp}")
        return tmp
    }


    public func onEvent(event: Event): Unit {
        counter.fetchAdd(1)
        // println("IntegerSubscriber onEvent: ${counter.load()}")
    }
}
/*
* 用户实现发布者
*/
class IntegerPublisher <: Publisher {
    public func publish(event: Event): Unit {
        event.getSubscriber().onEvent(event)
    }
}

//使用默认配置创建事件对象和总线
var mbassador = Mbassador()
//使用自定义配置创建事件对象和总线，支持配置订阅，取消订阅，发布并行度配置
var mbconfig = MbassadorConfiguration()
mbconfig.setExecutorService(ExecutorService(3, 3, 30))
var mbassador = Mbassador(mbconfig)
```
#### 1.2 订阅
##### 1.2.1 同步订阅
```cangjie
/*
* 同步订阅入口函数
* 参数：event对象
*/
mbassador.register(event)
```
##### 1.2.2 异步订阅
```cangjie
/*
* 异步订阅入口函数
* 参数：MbassadorConfiguration总线配置对象
* 参数：event队列
*/
mbassador.registerAsny(mbconfig, LinkedBlockingQueue<Event>)
```
#### 1.3 发布
##### 1.3.1 同步发布
```cangjie
/*
* 同步发布入口函数
* 参数：event对象
*/
mbassador.publish(event)
```
##### 1.3.2 异步发布
```cangjie
/*
* 异步发布入口函数
* 参数：MbassadorConfiguration总线配置对象
* 参数：event队列
*/
mbassador.publishAsny(mbconfig, LinkedBlockingQueue<Event>)
```
#### 1.4 取消订阅
##### 1.4.1 同步取消订阅
```cangjie
/*
* 同步取消订阅入口函数
* 参数：event对象
*/
mbassador.unregister(event)
```
##### 1.4.2 异步取消订阅
```cangjie
/*
* 异步取消订阅入口函数
* 参数：MbassadorConfiguration总线配置对象
* 参数：event队列
*/
mbassador.unregisterAsny(mbconfig, LinkedBlockingQueue<Event>)
```
#### 1.5 过滤器
通过过滤器链的模式，支持自定义过滤器，自定义顺序，多个过滤器的事件过滤功能
```cangjie
public interface Filter{
    func filter(event: ArrayList<Event>): ArrayList<Event>
}

public class FilterChain{

    private var filters: ArrayList<Filter> = ArrayList<Filter>()    

    public func addFilter(filter: Filter): Unit{
        filters.append(filter)
    }

    public func filter(events: ArrayList<Event>): ArrayList<Event>{
        var result: ArrayList<Event> = events
        for(f in filters){
            result = f.filter(result)
        }
        
        return result
    }
}
```


#### 1.6 线程管理

线程管理池化，通过总线配置并行度，对发布，订阅，取消订阅进行自定义配置，在多线程场景下通过Exector和Worker对象，实现线程和业务代码的解耦

```cangjie
//使用自定义配置创建事件对象和总线，支持配置订阅，取消订阅，发布并行度配置
var mbconfig = MbassadorConfiguration()
mbconfig.setExecutorService(ExecutorService(3, 3, 30))
var mbassador = Mbassador(mbconfig)

public class CoroutinePool {
    //协程集合
    private var workers: ArrayList<Woreker> = ArrayList<Woreker>()

    //初始化
    init(parallel: Int64) {
        for (_ in 0..parallel) {
            let woreker = Woreker()
            workers.append(woreker)
        }
    }
    //按照先进先出的方式处理任务，一个event进入，找一个空闲的协程处理
    public func sumbmit(exector: Exector, taskQueue: LinkedBlockingQueue<Event>): Future<Unit> {
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
```