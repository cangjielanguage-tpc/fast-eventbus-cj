/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package mbassador4cj

import std.collection.*
import std.collection.concurrent.*
import std.sync.*
public interface Exector {
    func execute(event: Event): Unit

    func isFinshed(): Bool
}

let nullConcurrentHashMap =  unsafe {zeroValue<ConcurrentHashMap<String, EventManager>>()}
public class SubscriberFactory <: Exector {
    //事件容器创建
    public var eventMap: ConcurrentHashMap<String, EventManager> = nullConcurrentHashMap
    private var isFinished: Bool = false
    private init() {
    }
    static func getSubscriberFactoryInstacne(eventMap: ConcurrentHashMap<String, EventManager>): SubscriberFactory {
        var subFactory: SubscriberFactory = SubscriberFactory()
        subFactory.eventMap = eventMap
        return subFactory
    }
    let mtx: ReentrantMutex = ReentrantMutex()
    public func execute(event: Event): Unit {
        isFinished = false
        if (let Some(eventIn) <- eventMap.get(event.evevtTypeName)) {
            mtx.lock()
            eventIn.eventContainer.append(event)
             mtx.unlock()
        } else {
            var eventContainer: CopyOnWriterContainer = CopyOnWriterContainer()
            mtx.lock()
            eventContainer.append(event)
            mtx.unlock()
            var eventManager: EventManager = EventManager(eventContainer)
            eventMap.put(event.evevtTypeName, eventManager)
        }
        isFinished = true
    }

    public func isFinshed(): Bool {
        return this.isFinished
    }
}

public class PublisherFactory <: Exector {
    // private let Logger: SimpleLogger = SimpleLogger()
    //事件容器创建
    public var eventMap: ConcurrentHashMap<String, EventManager> = nullConcurrentHashMap
    private var isFinished: Bool = false
    private init() {
    }
    static func getPublisherFactoryInstance(eventMap: ConcurrentHashMap<String, EventManager>): PublisherFactory {
        var pubInst: PublisherFactory = PublisherFactory()
        pubInst.eventMap = eventMap
        return pubInst
    }

    public func execute(event: Event): Unit {
        isFinished = false
        if (event.linkedListNode.isSome()) {
            event.publisher.publish(event)
        }
        isFinished = true
    }

    public func isFinshed(): Bool {
        return this.isFinished
    }
}


public class UnSubscriberFactory <: Exector {
    //事件容器创建
    public var eventMap: ConcurrentHashMap<String, EventManager> = nullConcurrentHashMap
    private var isFinished: Bool = false

    private init() {
    }

    public static func getUnSubscriberFactoryInstance(eventMap: ConcurrentHashMap<String, EventManager>): Exector {
        var subFactory: UnSubscriberFactory = UnSubscriberFactory()
        subFactory.eventMap = eventMap
        return subFactory
    }

    let mtx: ReentrantMutex = ReentrantMutex()
    public func execute(event: Event): Unit {
        isFinished = false
        mtx.lock()
        eventMap.get(event.evevtTypeName)?.eventContainer.remove(event)
        mtx.unlock()
        isFinished = true
    }
    public func isFinshed(): Bool {
        return this.isFinished
    }
}
