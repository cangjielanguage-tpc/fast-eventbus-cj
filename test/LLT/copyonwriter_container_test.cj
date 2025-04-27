/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
// EXEC: cjc %import-path %L %l %f entry.cj --test
// EXEC: ./main
// RESOURCES: entry.cj
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import mbassador4cj.*


@Test
class CopyOnWriterContainerTest {
    @TestCase
    func testCopyOnWriterContainerAppendAndGet(): Unit {
        let c = CopyOnWriterContainer()
        var eventA: Event = Event("eventA",IntegerSubscriber(),IntegerPublisher())
        var eventB: Event = Event("eventB",IntegerSubscriber(),IntegerPublisher())
        c.append(eventA)
        c.append(eventB)
        @Assert(c.size,2)

        c.remove(eventA)
        c.remove(eventB)
        @Assert(c.size,0)
        @Assert(c.isEmpty(),true)
    }
}
