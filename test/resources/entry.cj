
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.collection.concurrent.*
import std.time.*
import std.sync.*
import mbassador4cj.*

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

public class DataProvider {
    
    public static func prepareData(instance: Int64):CopyOnWriterContainer {
        var eventContainer: CopyOnWriterContainer = CopyOnWriterContainer()
        //数据准备
        for (i in 0..instance) {
            var event: Event = Event("IntergerType",IntegerSubscriber(),IntegerPublisher())
            eventContainer.append(event)
        }
        return eventContainer
    }
    public static func prepareDataQueue(eventContainer: CopyOnWriterContainer): BlockingQueue<Event> {
        var eventQueue: BlockingQueue<Event> = BlockingQueue<Event>()
        for (event in eventContainer) {
            eventQueue.enqueue(event)
        }
        return eventQueue
    }

    public static func clearData(eventContainer: CopyOnWriterContainer): Unit{
        eventContainer.clear()
    }

    public static func copyRegisterEventContainerToNewContainer(eventContainer: CopyOnWriterContainer){
        var newContainer: CopyOnWriterContainer = CopyOnWriterContainer()
        for (event in eventContainer) {
            newContainer.append(event)
        }
        return newContainer
    }
}