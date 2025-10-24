package ohos_app_cangjie_fastevent_hybrid

import ohos.ark_interop.*
import ohos.ark_interop_macro.*
import fasteventbus.*
import ohos.ark_interop_helper.*

@Interop[ArkTS]
public class Demo {
    var evevtTypeName: String = ""
    public init(evevtTypeName:String) {
         this.evevtTypeName = evevtTypeName

    }
}

//@Interop[ArkTs]
//public class EventTs1{
//    var evevtTypeName: String = ""
////    var subscriber: ?(Event) -> Unit = None
////    var publisher: ?(Event) -> Unit = None
//
////    var e:?Event = None
////    public init(evevtTypeName:String,subscriber:(Demo) -> Unit,publisher:(Demo) -> Unit) {
//        public init(evevtTypeName:String) {
//        this.evevtTypeName = evevtTypeName
////        this.subscriber = {
////            event => (subscriber)
////        }
////        this.publisher = {
////            event => (publisher)
////        }
////        e = Event(this.evevtTypeName,this.subscriber,this.publisher)
//    }
//}