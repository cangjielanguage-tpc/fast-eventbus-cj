/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights resveved.
 */
// EXEC: cjc %import-path %L %l %f entry.cj --test
// EXEC: ./main
// RESOURCES: entry.cj
import mbassador4cj.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*

@Test
public class IssueTest {

    //https://gitcode.com/Cangjie-TPC/mbassador4cj/issues/5
    @TestCase
    public func testissues5_1(): Unit {
        var ex:ExecutorService = ExecutorService(-6,0,-6)
        @Assert(ex.subscriberParallel,1)
        @Assert(ex.unsubscriberParallel,1)
        @Assert(ex.publishParallel,1)
    }

    //https://gitcode.com/Cangjie-TPC/mbassador4cj/issues/5
    @TestCase
    public func testissues5_2(): Unit {
        var ex:ExecutorService = ExecutorService(100,100,800)
        @Assert(ex.subscriberParallel,3)
        @Assert(ex.unsubscriberParallel,3)
        @Assert(ex.publishParallel,25)
    }

    //https://gitcode.com/Cangjie-TPC/mbassador4cj/issues/6
    @TestCase
    public func testissues6(): Unit {
        var mbassador = Mbassador()
        var event: Event = Event("IntergerType",IntegerSubscriber(),IntegerPublisher())
        let e:MbassadorException = @AssertThrows[MbassadorException](mbassador.unregister(event))
        @Assert(e.toString(),"MbassadorException: unSubscribe error.The current event has not been subscribed, please operate subscription first.")
        
    }

    //https://gitcode.com/Cangjie-TPC/mbassador4cj/issues/4
    @TestCase
    public func testissues4(): Unit {
        var events = ArrayList<Event>()
        for(i in 0..20){
            events.add(Event("IntergerType_${i}",IntegerSubscriber(),IntegerPublisher()))
        }
        var mbassador = Mbassador()
        for(i in 0..20){
            mbassador.register(events[i])
            if(i%2 == 1){
                for(it in mbassador.mbassadorConfiguration.eventMap.get("IntergerType_${i}").getOrThrow().eventContainer.iterator()){
                    mbassador.unregister(it)
                }
            }
        }
    }
    //https://gitcode.com/Cangjie-TPC/mbassador4cj/issues/7
    @TestCase
    public func testissues7(): Unit {
        var mbassador = Mbassador()
        var event: Event = Event("IntergerType",IntegerSubscriber(),IntegerPublisher())
        @Assert(mbassador.register(event),true)
        @Assert(mbassador.publish(event),true)
        @Assert(mbassador.unregister(event),true)
    }

}