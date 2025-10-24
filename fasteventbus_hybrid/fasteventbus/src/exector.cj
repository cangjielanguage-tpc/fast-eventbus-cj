/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package fasteventbus

import std.collection.*
import std.collection.concurrent.*
import std.sync.*
public interface Exector {
    func execute(event: Event): Bool

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
    @Frozen
    public func execute(event: Event): Bool {
        isFinished = false
        try{
            if (let Some(eventIn) <- eventMap.get(event.evevtTypeName)) {
                eventIn.eventContainer.append(event)
            } else {
                var eventContainer: CopyOnWriterContainer = CopyOnWriterContainer()
                eventContainer.append(event)
                var eventManager: EventManager = EventManager(eventContainer)
                eventMap.add(event.evevtTypeName, eventManager)
            }
            isFinished = true
        }catch(e:MbassadorException){
            throw MbassadorException("")
        }
        return isFinished
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
    @Frozen
    public func execute(event: Event): Bool {
        isFinished = false
        if (event.id.isSome() && let Some(publish) <- event.publisher) {
            publish(event)
            isFinished = true
        }else{
            throw MbassadorException("")
        }
        return isFinished
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

    public static func getUnSubscriberFactoryInstance(eventMap: ConcurrentHashMap<String, EventManager>): UnSubscriberFactory {
        var subFactory: UnSubscriberFactory = UnSubscriberFactory()
        subFactory.eventMap = eventMap
        return subFactory
    }

    @Frozen
    public func execute(event: Event): Bool {
        isFinished = false
        if(let Some(v) <- eventMap.get(event.evevtTypeName)){
            v.eventContainer.remove(event)
            isFinished = true
        }else{
            throw MbassadorException("")
        }
        return isFinished
    }
    public func isFinshed(): Bool {
        return this.isFinished
    }
}
