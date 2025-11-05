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

    public var subscriberFactorry: SubscriberFactory = SubscriberFactory.getSubscriberFactoryInstacne(eventMap)
    public var publisherFactory: PublisherFactory = PublisherFactory.getPublisherFactoryInstance(eventMap)
    public var unSubscriberFactory: UnSubscriberFactory = UnSubscriberFactory.getUnSubscriberFactoryInstance(eventMap)

    public init() {

    }
}
