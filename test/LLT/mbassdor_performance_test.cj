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
import std.time.*
import std.sync.*
import mbassador4cj.*

@Test
class MbassadorPerformanceTest {
    var loopNmuber: Int64 = 1
    var instance: Int64 = 10000
    @TestCase
    func testRegisterperformance(): Unit {
        //数据准备
        var eventList = DataProvider.prepareData(instance)        
        // 创建事件对象和总线
        var mbassador = Mbassador()
        var timeArryList: ArrayList<Duration> = ArrayList<Duration>()

        for (i in 0..loopNmuber) {
            let startTime = DateTime.now()
            for (event in eventList) {
                mbassador.register(event)
            }
            let endTime = DateTime.now()
            timeArryList.add(endTime - startTime)
            // println("testRegisterperformance ${i} : ${(endTime-startTime)}")
        }
        var totalTime: Duration = Duration.millisecond * 0
        for (time in timeArryList) {
            totalTime += time
        }
        DataProvider.clearData(eventList)
        println("testRegisterperformance average ${loopNmuber} : ${totalTime/loopNmuber} ns")
    }
    @TestCase
    func testPublishperformance(): Unit {
        //数据准备
        var eventList = DataProvider.prepareData(instance)
        // 创建事件对象和总线
        var mbassador = Mbassador()
        for (event in eventList) {
            mbassador.register(event)
        }
        var timeArryList: ArrayList<Duration> = ArrayList<Duration>()
        for (i in 0..loopNmuber) {
            let startTime = DateTime.now()
            for (event in eventList) {
                mbassador.publish(event)
            }
            let endTime = DateTime.now()
            timeArryList.add(endTime - startTime)
            // println("testPublishperformance  ${i} : ${(endTime-startTime)}")
        }

        var totalTime: Duration = Duration.millisecond * 0
        for (time in timeArryList) {
            totalTime += time
        }
        DataProvider.clearData(eventList)
        println("testPublishperformance average: ${loopNmuber} : ${totalTime/loopNmuber} ns")
    }
    @TestCase
    func testUngerPerformance(): Unit {
        //数据准备
        var eventList = DataProvider.prepareData(instance)
        // 创建事件对象和总线
        var mbassador = Mbassador()

        var timeArryList: ArrayList<Duration> = ArrayList<Duration>()
        for (i in 0..loopNmuber) {
            for (event in eventList) {
                mbassador.register(event)
            }
            let startTime = DateTime.now()
            for (event in eventList) {
                mbassador.unregister(event)
            }
            let endTime = DateTime.now()
            timeArryList.add(endTime - startTime)
            // println("testUngerPerformance  ${i} : ${(endTime-startTime)}")
        }

        var totalTime: Duration = Duration.millisecond * 0
        for (time in timeArryList) {
            totalTime += time
        }
        DataProvider.clearData(eventList)
        println("testUngerPerformance average: ${loopNmuber} : ${totalTime/loopNmuber} ns")
    }
}