/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package mbassador4cj

import std.collection.*
import std.sync.*

/*
 * CopyOnWriterContainer  COW 无阻塞读，写时加锁
 */
public class CopyOnWriterContainer <: Collection<Event> {

    private var container: LinkedList<Event>

    public init() {
        this.container = LinkedList<Event>()
    }

    public func isEmpty(): Bool {
         var size = 0
        for(e in container){
            if(e.linkedListNode.isSome()){
                size++
                break
            }
        }
        if(size == 0){
            return true
        }
        return false     
    }
    public prop size: Int64 {
        get() {
            var size = 0
            for(e in container){
                if(e.linkedListNode.isSome()){
                    size++
                }
            }
            return size
        }
    }

    public func append(t: Event): Unit {
        var nodeIndfo = this.container.addLast(t)
        t.linkedListNode = nodeIndfo
    }
    public func remove(t: Event): Unit {
        t.linkedListNode = None
    }

    public func iterator(): Iterator<Event> {
        this.container.iterator()
    }

    public func clear() {
        for(e in container){
            e.linkedListNode = None
        }
        this.container.clear()
    }
}