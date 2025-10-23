/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package fasteventbus

import std.collection.*
import std.sync.*
import std.sort.*

/*
 * CopyOnWriterContainer  COW 无阻塞读，写时加锁
 */
public class CopyOnWriterContainer <: Collection<Event> {

    private var container: ArrayList<Event>
    let mtx: Mutex = Mutex()

    public init() {
        this.container = ArrayList<Event>()
    }

    public func isEmpty(): Bool {
        return this.container.isEmpty()
    }
    public prop size: Int64 {
        get() {
            return this.container.size
        }
    }

    @Frozen
    public func append(t: Event): Unit {
        mtx.lock()
        this.container.add(t)
        t.id = this.size - 1
        mtx.unlock()
    }
    @Frozen
    public func remove(t: Event): Unit {
        t.id = None
    }

    @Frozen
    public func iterator(): Iterator<Event> {
        this.container.iterator()
    }

    public func clear() {
        this.container.clear()
    }

    @Frozen
    public operator func [](index: Int64): Event{
        return this.container[index]
    }

    @Frozen
    public func removeNoneEvent(){
        mtx.lock()
        this.container.removeIf({
            item => 
            return if (item.id.isNone() ) {
                true
            } else {
                false
            }
        })
        mtx.unlock()
    }
}