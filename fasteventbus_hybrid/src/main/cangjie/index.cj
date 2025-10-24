package ohos_app_cangjie_fastevent_hybrid

import ohos.ark_interop.*
import ohos.ark_interop_macro.*
import fasteventbus.*
import ohos.ark_interop_helper.*


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
public func arktsFuncToCj(name:String,sub:(EventTs) -> Unit,pub:(EventTs) -> Unit):Unit{
    let m:Mbassador = Mbassador()
    let eventTs:EventTs = EventTs(name,sub,pub)
    let e = Event(eventTs.evevtTypeName,eventTs.subscriber.getOrThrow(),eventTs.publisher.getOrThrow())
    m.register(e)
}




