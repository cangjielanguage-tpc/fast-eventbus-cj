<div align="center">
<h1>fastEventbus4cj</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v0.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v0.59.6-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-90.4%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>

## 介绍

fastEventbus4cj 一种是发布/订阅事件总线。为多线程应用程序中的高吞吐量而优化的强大事件总线。支持同步和异步事件发布，事件过滤功能。

### 特性

- 🚀 支持事件的同步订阅和发布

- 🚀 支持事件的异步订阅和发布

- 🚀 支持事件过滤

## <img alt="" src="./doc/assets/readme-icon-framework.png" style="display: inline-block;" width=3%/> 架构

### 源码目录

```shell
.
├── README.md
├── doc
├── src
└── test   
    ├── HLT
    ├── LLT
    
```
- `src`存放库源码目录
- `test/HLT`存放HLT用例
- `test/LLT`存放LLT用例

### 接口说明

主要类和函数接口说明，详见 [API](./doc/feature_api.md)

## <img alt="" src="./doc/assets/readme-icon-compile.png" style="display: inline-block;" width=3%/> 使用说明

### 编译（win/linux）

```shell
cjpm build
```

### 功能示例
#### 事件的同步订阅发布功能示例
功能示例描述:事件的同步订阅
示例代码如下：
```cangjie
    @TestCase
    func testregister(): Unit {
        //数据准备
        var eventList: ArrayList<Event> = ArrayList<Event>(256)
        var instacne: Int64 = 2000
        for (i in 0..instacne) {
            var event: Event = Event("IntergerType",IntegerSubscriber(),IntegerPublisher())
            eventList.append(event)
        }
        // 创建事件对象和总线
        var mbassador = Mbassador()

        for (event in eventList) {
            mbassador.register(event)
        }
    }
```
执行结果如下：

功能示例描述:事件的同步发布
示例代码如下：
```cangjie
    @TestCase
    func testregister(): Unit {
        //数据准备
        var eventList: ArrayList<Event> = ArrayList<Event>(256)
        var instacne: Int64 = 2000
        for (i in 0..instacne) {
            var event: Event = Event("IntergerType",IntegerSubscriber(),IntegerPublisher())
            eventList.append(event)
        }
        // 创建事件对象和总线
        var mbassador = Mbassador()

        for (event in eventList) {
            mbassador.publish(event)
        }
    }
```
执行结果如下：


#### 事件的异步订阅发布功能示例
功能示例描述:事件的异步订阅
示例代码如下：
```cangjie
    @TestCase
    func testRegisterAsny() {
        //设置并行参数
        var mbconfig = MbassadorConfiguration()
        mbconfig.setExecutorService(ExecutorService(3, 3, 30))
        var mbassador = Mbassador(mbconfig)
        //订阅
        var eventQueue: BlockingQueue<Event> = BlockingQueue<Event>()
        for (i in 0..1000) {
            var event: Event = Event("IntergerType",IntegerSubscriber(),IntegerPublisher())
            eventQueue.enqueue(event)
        }
        mbassador.registerAsny(mbconfig, prepareDataQueue(eventQueue))
    }
```

功能示例描述:事件的异步发布
示例代码如下：
```cangjie
    @TestCase
    func testRegisterAsny() {
        //设置并行参数
        var mbconfig = MbassadorConfiguration()
        mbconfig.setExecutorService(ExecutorService(3, 3, 30))
        var mbassador = Mbassador(mbconfig)
        //订阅
        var eventQueue: BlockingQueue<Event> = BlockingQueue<Event>()
        for (i in 0..1000) {
            var event: Event = Event("IntergerType",IntegerSubscriber(),IntegerPublisher())
            eventQueue.enqueue(event)
        }
        mbassador.publishAsny(mbconfig, prepareDataQueue(eventQueue))
    }
```
执行结果如下：

#### 事件过滤功能示例
功能示例描述:通过实现Filter接口，通过FilterChain对象，实现自定义过滤器，自定义顺序，过滤器链的过滤功能

示例代码如下：
```cangjie
@Test   
public class FileterTest{

    @TestCase
    public func testFilter() {

        var events:ArrayList<Event> = ArrayList<Event>()

        var eventA: Event = Event("eventA",IntegerSubscriber(),IntegerPublisher())
        var eventB: Event = Event("eventB",IntegerSubscriber(),IntegerPublisher())

        events.append(eventA)
        events.append(eventB)

       for (ev in events) {
            println("filter before --->  ${ev.getEvevtTypeName()}")
        }

        let filterChanin:FilterChain = FilterChain()
        filterChanin.addFilter(EventNameAFilter())
        filterChanin.addFilter(PublisherFilter())

        var results:ArrayList<Event> = filterChanin.filter(events)
        println("--------------分割线-------------------")
        for (result in results) {
            println("after filter --->  ${result.getEvevtTypeName()}")
        }

    }
}

public class EventNameAFilter <: Filter {

    public func filter(event: ArrayList<Event>): ArrayList<Event>{
        var eventAfterFilter = ArrayList<Event>()
        for (e in event) {
            if (e.getEvevtTypeName() == "eventA") {
                eventAfterFilter.append(e)
            }
        }
         return eventAfterFilter
    }
}

public class PublisherFilter <: Filter {

    public func filter(event: ArrayList<Event>): ArrayList<Event>{
        var eventAfterFilter = ArrayList<Event>()
        for (e in event) {
            if (e.getpublisher() is IntegerPublisher) {
                eventAfterFilter.append(e)
            }
        }
         return eventAfterFilter
    }
}
```
## 约束与限制

在下述版本验证通过：

    Cangjie Version: 0.59.6

## 开源协议

本项目基于 [MIT license](./LICENSE) ，请自由的享受和参与开源。

## <img alt="" src="./doc/assets/readme-icon-contribute.png" style="display: inline-block;" width=3%/> 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。