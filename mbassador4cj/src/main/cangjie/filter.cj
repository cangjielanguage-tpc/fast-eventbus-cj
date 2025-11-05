/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package mbassador4cj

import std.collection.*

public interface Filter {
    func filter(event: ArrayList<Event>): ArrayList<Event>
}

public class FilterChain {
    private var filters: ArrayList<Filter> = ArrayList<Filter>()

    public func addFilter(filter: Filter): Unit {
        filters.add(filter)
    }

    public func filter(events: ArrayList<Event>): ArrayList<Event> {
        var result: ArrayList<Event> = events
        for (f in filters) {
            result = f.filter(result)
        }

        return result
    }
}
