/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package fasteventbus

import std.collection.*
import std.sync.*


public class Event <: Equatable<Event> {
    public var evevtTypeName: String = ""
    public var subscriber: Subscriber = unsafe { zeroValue<Subscriber>() }
    public var publisher: Publisher = unsafe { zeroValue<Publisher>() }
    public var id:?Int64 = None
    
    public init() {}

    public init(evevtTypeName: String, subscriber: Subscriber, publisher: Publisher) {
        this.evevtTypeName = evevtTypeName
        this.subscriber = subscriber
        this.publisher = publisher
    }

    public operator func ==(that: Event): Bool {
        return refEq(this, that)
    }
}

public class EventManager {
    public var eventContainer: CopyOnWriterContainer = CopyOnWriterContainer()

    public init(eventContainer: CopyOnWriterContainer) {
        this.eventContainer = eventContainer
    }

}
