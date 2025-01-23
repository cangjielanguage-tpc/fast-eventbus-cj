/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights resveved.
 */
// EXEC: cjc %import-path %L %l %f entry.cj --test
// EXEC: ./main
// RESOURCES: entry.cj
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.collection.concurrent.*
import std.sync.*
import std.time.*
import mbassador4cj.*

@Test
public class MbassadorTest {
    public var instance = 10

    @TestCase
    func testregister(): Unit {
        println("---------------------------------testregister------------------------------")
        //数据准备
        var eventList = DataProvider.prepareData(instance)
        // 创建事件对象和总线
        var mbassador = Mbassador()
        for (event in eventList) {
            mbassador.register(event)
        }
        @Assert(mbassador.mbassadorConfiguration.eventMap.get("IntergerType").getOrThrow().eventContainer.size,instance)
    }
    @TestCase
    public func testPublish(): Unit {
        println("---------------------------------testPublish------------------------------")
        //数据准备
        var eventList = DataProvider.prepareData(instance)
        // 创建事件对象和总线
        var mbassador = Mbassador()

        for (event in eventList) {
            mbassador.register(event)
        }
        for (event in eventList) {
            mbassador.publish(event)
        }
    }
    @TestCase
    public func testunregister(): Unit {
        println("---------------------------------testunregister------------------------------")
        //数据准备
        var eventList = DataProvider.prepareData(instance)

        // 创建事件对象和总线
        var mbassador = Mbassador()

        for (event in eventList) {
            mbassador.register(event)
        }
        for (event in eventList) {
            mbassador.unregister(event)
        }
        @Assert(mbassador.mbassadorConfiguration.eventMap.get("IntergerType").getOrThrow().eventContainer.size,0)
    }
    @TestCase
    public func testRegisterAsny() {
        println("---------------------------------testRegisterAsny------------------------------")
        //设置并行参数
        var mbconfig = MbassadorConfiguration()
        mbconfig.executorService=ExecutorService(3, 3, 30)
        var mbassador = Mbassador(mbconfig)
        //订阅
        var eventList = DataProvider.prepareData(instance)
        mbassador.registerAsny(mbconfig, DataProvider.prepareDataQueue(eventList))
        sleep(Duration.second * 10)
        @Assert(mbassador.mbassadorConfiguration.eventMap.get("IntergerType").getOrThrow().eventContainer.size,instance)
        //发布
        mbassador.publishAsny(mbconfig, DataProvider.prepareDataQueue(eventList))
        sleep(Duration.second * 10)
        //取消订阅
        mbassador.unregisterAsny(mbconfig, DataProvider.prepareDataQueue(eventList))
        sleep(Duration.second * 10)
        @Assert(mbassador.mbassadorConfiguration.eventMap.get("IntergerType").getOrThrow().eventContainer.size,0)
    }
}
