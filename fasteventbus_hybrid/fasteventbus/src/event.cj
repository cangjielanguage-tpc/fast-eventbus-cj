/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package fasteventbus

import std.collection.*
import std.sync.*


public class Event <: Equatable<Event> {
    public var evevtTypeName: String = ""
    public var subscriber: ?(Event) -> Unit = None
    public var publisher: ?(Event) -> Unit = None
    public var id:?Int64 = None
    
    public init() {}

    public init(evevtTypeName: String, subscriber: (Event) -> Unit, publisher: (Event) -> Unit) {
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
