# mbassador4cj 库

### 介绍

mbassador4cj 是一种发布/订阅事件总线。为多线程应用程序中的高吞吐量而优化的事件总线。支持同步和异步事件发布，事件过滤功能。

### 1 事件订阅和发布

#### 1.1 主要接口

```cangjie
/*
* 事件接口，包含三个参数，事件类型名称，订阅者，发布者，是事件总线的最小执行单元
*/
public class Event {
    init(evevtTypeName: String, subscriber: Subscriber, publisher: Publisher) 
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
    /*
    * 发布接口，使用接口不可递归调用，只可调用Subscriber子类的onEvent方法，示例event.subscriber.onEvent(event)
    * 参数：event对象
    */
    func publish(event: Event): Unit
}
/*
* 过滤器接口
*/
public interface Filter{
    /*
    * 过滤器
    * 参数：event对象列表
    */
    func filter(event: ArrayList<Event>): ArrayList<Event>
}
/*
* 过滤器链
*/
public class FilterChain {
    /*
    * 过滤器链列表
    * 参数：过滤器实例
    */
    public func addFilter(filter: Filter):Unit: 
    /*
    * 过滤器
    * 参数：event对象列表
    */
    public func filter(events: ArrayList<Event>): ArrayList<Event>

}
/*
* mbassador入口
*/
public class mbassador{
    /*
    * 默认构造方法
    */
    public init()
    /*
    * 自定义构造方法
    * 参数MbassadorConfiguration
    */
    public init(mbassadorConfiguration: MbassadorConfiguration)
    /*
    * 同步订阅入口函数
    * c
    */
    public func register(event: Event): Unit
    /*
    * 同步取消订阅入口函数
    * 参数：event对象
    */
    public func unregister(event: Event): Unit
    /*
    * 同步发布入口函数
    * 参数：event对象
    */
    public func publish(event: Event): Unit
    /*
    * 异步订阅入口函数
    * 参数：MbassadorConfiguration总线配置对象
    * 参数：event队列
    */
    public func registerAsny(mbassadorConfiguration: MbassadorConfiguration, eventQueue: BlockingQueue<Event>): Unit
    /*
    * 异步取消订阅入口函数
    * 参数：MbassadorConfiguration总线配置对象
    * 参数：event队列
    */
    public func unregisterAsny(mbassadorConfiguration: MbassadorConfiguration, eventQueue: BlockingQueue<Event>): Unit 
    /*
    * 异步发布入口函数
    * 参数：MbassadorConfiguration总线配置对象
    * 参数：event队列
    */
    public func publishAsny(mbassadorConfiguration: MbassadorConfiguration, eventQueue: BlockingQueue<Event>): Unit
}
/*
* MbassadorConfiguration总线配置
*/
class MbassadorConfiguration {
    /*
    * 事件总线容器
    */
    public var eventMap: ConcurrentHashMap<String, EventManager> = ConcurrentHashMap<String, EventManager>(1024)
    /*
    * 默认构造方法
    */
    public init() 
    /*
    * 线程池配置
    */
    public var executorService: ExecutorService
}
/*
* ExecutorService线程池配置
*/
public class ExecutorService {
    /*
    * 默认构造方法
    */
    public init()
    /*
    * 自定义构造方法
    * 参数：event对象
    */
    public init(subscriberParallel: Int64, unsubscriberParallel: Int64, publishParallel: Int64)
}

```
#### 1.2 示例
```cangjie
private var counter: AtomicInt64 = AtomicInt64(0)

public class IntegerSubscriber <: Subscriber {
    public func getCounter(): Int64 {
        var tmp: Int64 = counter.load()
        return tmp
    }

    public func onEvent(event: Event): Unit {
        counter.fetchAdd(1)
        // println("IntegerSubscriber onEvent: ${counter.load()}")
    }
}

public class IntegerPublisher <: Publisher {
    public func publish(event: Event): Unit {
        event.subscriber.onEvent(event)
    }
}

import mbassador4cj.*

main（）{
    var event: Event = Event("IntergerType",IntegerSubscriber(),IntegerPublisher())
    var mbassador = Mbassador()
    mbassador.register(event)
    mbassador.publish(event)
    mbassador.unregister(event)
}

```