/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package mbassador4cj

import std.collection.*
import std.collection.concurrent.*
import std.sync.*

public class MbassadorConfiguration {

    //event容器 使用cj标准库的ConcurrentHashMap处理并发，读无锁，写分段锁
    public var eventMap: ConcurrentHashMap<String, EventManager> = ConcurrentHashMap<String, EventManager>(
        Constant.DEFAULT_EVENT_MAP_SIZE)

    public var exectorMap: HashMap<String, Exector> = HashMap<String, Exector>()
    //线程池，默认都是1
    public var executorService: ExecutorService = ExecutorService()

    public init() {
        var subscriberFactorry: Exector = SubscriberFactory.getSubscriberFactoryInstacne(eventMap)
        var publisherFactory: Exector = PublisherFactory.getPublisherFactoryInstance(eventMap)
        var UnSubscriberFactory: Exector = UnSubscriberFactory.getUnSubscriberFactoryInstance(eventMap)
        exectorMap.add(Constant.REGISTER, subscriberFactorry)
        exectorMap.add(Constant.PUBLISH, publisherFactory)
        exectorMap.add(Constant.UNREGISTER, UnSubscriberFactory)
    }

    public func getExector(typestr: String): Exector {
        return exectorMap[typestr]
    }
}
