// EXEC: cjc %import-path %L %l %f entry.cj --test
// EXEC: ./main
// RESOURCES: entry.cj
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.sync.*
import std.time.*
import mbassador4cj.*


@Test
public class oomIssueTest{

    var arr : Array<Int64> = [10,100]

    @TestCase
    func test(){
        for(n in arr){
            registerTest(n)
        }

        for(n in arr){
            publishTest(n)
        }

        for(n in arr){
            unregisterTest(n)
        }
    }

    func registerTest(n:Int64):Unit{
        var mbassador = Mbassador()
        var eventContainer: CopyOnWriterContainer = CopyOnWriterContainer()
        //数据准备
        for (_ in 0..10000) {
            var event: Event = Event("IntergerType",IntegerSubscriber(),IntegerPublisher())
            eventContainer.append(event)
        }
        
        let startTime = DateTime.now()
        for (_ in 0..n) {
           //Int64归零
            DataProvider.recoveryCounter()
            for (event in eventContainer) {
                mbassador.register(event)
            }    
        }
        let endTime = DateTime.now()
        let dur=(endTime-startTime).toNanoseconds()
        println("test_bench_Register_${n} = ${dur/n} ns/op\n")
    }

    func unregisterTest(n:Int64):Unit{
        var eventContainer: CopyOnWriterContainer = CopyOnWriterContainer()
        //数据准备
        for (_ in 0..10000) {
            var event: Event = Event("IntergerType",IntegerSubscriber(),IntegerPublisher())
            eventContainer.append(event)
        }
        
        var timeArryList: ArrayList<Duration> = ArrayList<Duration>()
        for (_ in 0..n) {
            var mbassador = Mbassador()
            //Int64归零
            DataProvider.recoveryCounter()
            for (event in eventContainer) {
                mbassador.register(event)
            }
            let eventContainerHasRegister = mbassador.mbassadorConfiguration.eventMap.get("IntergerType").getOrThrow().eventContainer
            //sleep(1*Duration.millisecond)
            let startTime = DateTime.now()
            for (i in 0..eventContainerHasRegister.size) {
                mbassador.unregister(eventContainerHasRegister[i])
            }
            let endTime = DateTime.now()
            timeArryList.add(endTime - startTime)
            mbassador.mbassadorConfiguration.eventMap.get("IntergerType").getOrThrow().eventContainer.removeNoneEvent()
            mbassador.mbassadorConfiguration.eventMap.get("IntergerType").getOrThrow().eventContainer = CopyOnWriterContainer()
        }
        var totalTime: Duration = Duration.millisecond * 0	   
        for (time in timeArryList) {
            totalTime += time
        }
        let dur=totalTime.toNanoseconds()
        println("test_bench_UnRegister_${n} = ${dur/n} ns/op\n")
    }

    func publishTest(n:Int64):Unit{
        var mbassador = Mbassador()
        var eventContainer: CopyOnWriterContainer = CopyOnWriterContainer()
        //数据准备
        for (_ in 0..10000) {
            var event: Event = Event("IntergerType",IntegerSubscriber(),IntegerPublisher())
            eventContainer.append(event)
        }
        
        for (i in 0..eventContainer.size) {
            mbassador.register(eventContainer[i])
        }


        let eventContainerHasRegister = mbassador.mbassadorConfiguration.eventMap.get("IntergerType").getOrThrow().eventContainer
        let startTime = DateTime.now()
        for (_ in 0..n) {
            
            //Int64归零
            DataProvider.recoveryCounter()
            for (i in 0..eventContainerHasRegister.size) {
                mbassador.publish(eventContainerHasRegister[i])
            }
        }
        let endTime = DateTime.now()
        let dur=(endTime-startTime).toNanoseconds()
        println("test_bench_Publish_${n} = ${dur/n} ns/op \n")
    }

}