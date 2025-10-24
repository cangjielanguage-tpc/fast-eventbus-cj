package ohos_app_cangjie_fastevent_hybrid
//
//import ohos.ark_interop.*
//import ohos.ark_interop_macro.*
//import fasteventbus.*
//import ohos.ark_interop_helper.*
//
////@Interop[ArkTS]
////public func addF64(a: Float64, b!: Float64): Float64 {
////    a + b
////}
//
//
//@Interop[ArkTS]
//public class Demo {
//    public init() {
//
//    }
//}
//
//
//
//@Interop[ArkTs]
//public class EventTs1{
//    var evevtTypeName: String = ""
//    var subscriber: ?(Event) -> Unit = None
//    var publisher: ?(Event) -> Unit = None
//
//    var e:?Event = None
//    public init(evevtTypeName:String,subscriber:(Demo) -> Unit,publisher:(Demo) -> Unit) {
//        this.evevtTypeName = evevtTypeName
//        this.subscriber = {
//            event => (subscriber)
//        }
//        this.publisher = {
//            event => (publisher)
//        }
//        e = Event(this.evevtTypeName,this.subscriber,this.publisher)
//    }
//}
//
//@Interop[ArkTs]
//public class EventTs{
//    var evevtTypeName: String = ""
//    var subscriber: ?(Event) -> Unit = None
//    var publisher: ?(Event) -> Unit = None
//
//    var e:?Event = None
//    public init(evevtTypeName:String,subscriber:(EventTS) -> Unit,publisher:(EventTS) -> Unit) {
//        this.evevtTypeName = evevtTypeName
//        this.subscriber = {
//            event => (subscriber)
//        }
//        this.publisher = {
//            event => (publisher)
//        }
//        e = Event(this.evevtTypeName,this.subscriber,this.publisher)
//    }
//}
//
//@Interop[ArkTS]
//public func arktsFuncToCj(name:String,sub:(EventTS1) -> Unit,pub:(EventTS1) -> Unit):Unit{
//    let m:Mbassador = Mbassador()
//    let eventTs:EventTs1 = EventTs1(name,sub,pub)
////    if(let Some(event) <- EventTs1.e){
////        m.register(event)
////    }
//}
//
//
//
//
