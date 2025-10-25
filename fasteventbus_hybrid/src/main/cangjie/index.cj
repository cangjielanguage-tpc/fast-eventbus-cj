package ohos_app_cangjie_fastevent_hybrid

import ohos.ark_interop.*
import ohos.ark_interop_macro.*
import fasteventbus.*
import ohos.hilog.*
import std.collection.*

let m:Mbassador = Mbassador()

@Interop[ArkTS]
public class EventTs{
    var evevtTypeName: String = ""
    var subscriber: ?(Event) -> Unit = None
    var publisher: ?(Event) -> Unit = None
    var e:?Event = None
    public init(evevtTypeName:String,subscriber:(EventTs) -> Unit,publisher:(EventTs) -> Unit) {
        this.evevtTypeName = evevtTypeName
        this.subscriber = {
            event => (subscriber)
        }
        this.publisher = {
            event => (publisher)
        }
    }
}

@Interop[ArkTS]
public func register(name:String,sub:(EventTs) -> Unit,pub:(EventTs) -> Unit):Unit{
    let eventTs:EventTs = EventTs(name,sub,pub)
    let e = Event(eventTs.evevtTypeName,eventTs.subscriber.getOrThrow(),eventTs.publisher.getOrThrow())
    m.register(e)
}

@Interop[ArkTS]
public func unregister(eventTypeName:String):Unit{
    let container = m.mbassadorConfiguration.eventMap.get(eventTypeName).getOrThrow().eventContainer
    Hilog.debug(0X001,"hybrid-fasteventbus","container.size:${container.size}")
    for(e in container){
        m.unregister(e)
    }
}

@Interop[ArkTS]
public func publish(eventTypeName:String):Unit{
let container = m.mbassadorConfiguration.eventMap.get(eventTypeName).getOrThrow().eventContainer
    Hilog.debug(0X001,"hybrid-fasteventbus","container.size:${container.size}")
    for(e in container){
        m.unregister(e)
    }
}

@Interop[ArkTS]
public func clearContainerByEventTypeName(eventTypeName:String):Unit{
    let container = m.mbassadorConfiguration.eventMap.get(eventTypeName).getOrThrow().eventContainer
    container.clear()
}




