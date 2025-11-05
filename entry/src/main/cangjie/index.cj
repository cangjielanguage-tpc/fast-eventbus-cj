package ohos_app_cangjie_entry

internal import ohos.base.LengthProp
internal import ohos.component.Column
internal import ohos.component.Row
internal import ohos.component.Text
internal import ohos.component.CustomView
internal import ohos.component.CJEntry
internal import ohos.component.loadNativeView
internal import ohos.component.FontWeight
internal import ohos.state_manage.SubscriberManager
internal import ohos.state_manage.ObservedProperty
internal import ohos.state_manage.LocalStorage
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State
import ohos.component.Button
import ohos.system_date_time.SystemDateTime
import ohos.hilog.Hilog
import std.collection.*
import mbassador4cj.*
import std.sync.*
import std.time.DateTime

public var counter: AtomicInt64 = AtomicInt64(1)

@Entry
@Component
class EntryView {
    @State
    var message: String = "Hello World"

    var loopCounts: Array<Int64> = [1,10,100,1000,10000]
    
    func build() {
        Column() {
            Text("fasteventbus-cj")
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .onClick {
                    evt => this.message = "Hello Cangjie"
                }

            Button("test register(1,10,100,1000,10000)").width(90.percent).height(50).fontSize(18).margin(5).onClick({ =>
                spawn {
                	test_register_Entry()
                }
            })

            Button("test unregister(1,10,100,1000,10000)").width(90.percent).height(50).fontSize(18).margin(5).onClick({ =>
                spawn {
                    test_unregister_Entry()
                }
            })

            Button("test publish(1,10,100,1000,10000)").width(90.percent).height(50).fontSize(18).margin(5).onClick({ =>
                spawn {
                    test_publish_Entry()
                }
            })

        }.width(100.percent).height(100.percent)
    }

    func test_register_Entry() {
        for (count in loopCounts) {
        	benchRegister(count)
        }
    }

    func test_unregister_Entry() {
        for (count in loopCounts) {
        	benchUnRegister(count)
        }
    }

    func test_publish_Entry() {
        for (count in loopCounts) {
        	benchPublish(count)
        }
    }

    func benchUnRegister(n: Int64): Unit {
        counter = AtomicInt64(0)
        var eventList = preparedata(10000)
        // 创建事件对象和总线

        var timeArryList: ArrayList<Int64> = ArrayList<Int64>()
        for (_ in 0..n) {
            var mbassador = Mbassador()
            for (event in eventList) {
                mbassador.register(event)
            }
            let startTime = SystemDateTime.getTime(isNano: true)
            for (event in eventList) {
                mbassador.unregister(event)
            }
            let endTime = SystemDateTime.getTime(isNano: true)
            timeArryList.add(endTime - startTime)
        }
        var totalTime: Int64 = 0
        for (time in timeArryList) {
            totalTime += time
        }
        Hilog.error(999, "bench", "[bench]test_bench_UnRegister_${n} = ${totalTime/n} ns/op\n")
    }

    func benchRegister(n: Int64): Unit {
        counter = AtomicInt64(0)
        var eventList = preparedata(10000)
        let startTime = SystemDateTime.getTime(isNano: true)
        for (_ in 0..n) {
            var mbassador = Mbassador()
            for (event in eventList) {
                mbassador.register(event)
            }
        }
        let endTime = SystemDateTime.getTime(isNano: true)
        let dur= endTime - startTime
        Hilog.error(999, "bench", "[bench]test_bench_Register_${n} = ${dur/n} ns/op\n")
    }

    func benchPublish(n: Int64): Unit {
        counter = AtomicInt64(0)
        var eventList = preparedata(10000)
        var mbassador = Mbassador()
        for (event in eventList) {
            mbassador.register(event)
        }
        let startTime = SystemDateTime.getTime(isNano: true)
        for (_ in 0..n) {
            for (event in eventList) {
                mbassador.publish(event)
            }
        }
        let endTime = SystemDateTime.getTime(isNano: true)
        let dur = endTime - startTime
        Hilog.error(999, "bench", "[bench]test_bench_Publish_${n} = ${dur/n} ns/op \n")
    }

    func preparedata(count:Int64): CopyOnWriterContainer{
        var eventList: CopyOnWriterContainer = CopyOnWriterContainer()
        //数据准备
        for (_ in 0..count) {
            var event: Event = Event("IntergerType",IntegerSubscriber(),IntegerPublisher())
            eventList.append(event)
        }
        return  eventList
    }
}

class IntegerSubscriber <: Subscriber {
    public func getCounter(): Int64 {
        var tmp: Int64 = counter.load()
        return tmp
    }

    public func onEvent(event: Event): Unit {
        counter.fetchAdd(1)
    }
}

class IntegerPublisher <: Publisher {
    public func publish(event: Event): Unit {
        event.subscriber.onEvent(event)
    }
}