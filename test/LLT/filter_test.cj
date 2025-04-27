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
import std.sync.*

@Test
public class FileterTest {
    @TestCase
    public func testFilter() {
        var events: ArrayList<Event> = ArrayList<Event>()
        var eventA: Event = Event("eventA",IntegerSubscriber(),IntegerPublisher())
        var eventB: Event = Event("eventB",IntegerSubscriber(),IntegerPublisher())
        events.add(eventA)
        events.add(eventB)
        for (ev in events) {
            println("filter before --->  ${ev.evevtTypeName}")
        }
        let filterChanin: FilterChain = FilterChain()
        filterChanin.addFilter(EventNameAFilter())
        filterChanin.addFilter(PublisherFilter())
        var results: ArrayList<Event> = filterChanin.filter(events)
        for (result in results) {
            println("after filter --->  ${result.evevtTypeName}")
        }
    }
}

public class EventNameAFilter <: Filter {
    public func filter(event: ArrayList<Event>): ArrayList<Event> {
        var eventAfterFilter = ArrayList<Event>()
        for (e in event) {
            if (e.evevtTypeName == "eventA") {
                eventAfterFilter.add(e)
            }
        }
        return eventAfterFilter
    }
}

public class PublisherFilter <: Filter {
    public func filter(event: ArrayList<Event>): ArrayList<Event> {
        var eventAfterFilter = ArrayList<Event>()
        for (e in event) {
            if (e.publisher is IntegerPublisher) {
                eventAfterFilter.add(e)
            }
        }
        return eventAfterFilter
    }
}