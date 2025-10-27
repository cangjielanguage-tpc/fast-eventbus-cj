package ohos_app_cangjie_fastevent_hybrid

import ohos.ark_interop.*
import ohos.ark_interop_macro.*
import fasteventbus.*
import ohos.hilog.*

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

public func unregisterAsync(context: JSContext, callInfo: JSCallInfo): JSValue{
    // 1. 解析ArkTS侧传入的事件名称
    let eventTypeName: String = callInfo[0].toString(context);

    // 2. 创建Promise容器，用于向ArkTS侧返回异步结果
    let promise = context.promiseCapability();
    spawn {
        let container = m.mbassadorConfiguration.eventMap.get(eventTypeName).getOrThrow().eventContainer
        for(e in container){
            m.unregister(e)
        }
        // 3 取消成功：切换到JS线程，resolve Promise
        context.postJSTask { =>
            promise.resolve(context.undefined().toJSValue());
        };
    }
        // 4. 返回Promise给ArkTS侧，支持await调用
    return promise.toJSValue();
}

let EXPORT_MODULE1 = JSModule.registerModule {
    runtime, exports => exports["unregisterAsync"] = runtime.function(unregisterAsync).toJSValue()
}

@Interop[ArkTS]
public func publish(eventTypeName:String):Unit{
let container = m.mbassadorConfiguration.eventMap.get(eventTypeName).getOrThrow().eventContainer
    Hilog.debug(0X001,"hybrid-fasteventbus","container.size:${container.size}")
    for(e in container){
        m.publish(e)
    }
}

public func publishAsync(context: JSContext, callInfo: JSCallInfo): JSValue{
    // 1. 解析ArkTS侧传入的事件名称
    let eventTypeName: String = callInfo[0].toString(context);

    // 2. 创建Promise容器，用于向ArkTS侧返回异步结果
    let promise = context.promiseCapability();
    spawn {
        let container = m.mbassadorConfiguration.eventMap.get(eventTypeName).getOrThrow().eventContainer
        for(e in container){
            m.unregister(e)
        }
        // 3 取消成功：切换到JS线程，resolve Promise
        context.postJSTask { =>
            promise.resolve(context.undefined().toJSValue());
        };
    }
        // 4. 返回Promise给ArkTS侧，支持await调用
    return promise.toJSValue();
}
let EXPORT_MODULE2 = JSModule.registerModule {
    runtime, exports => exports["publishAsync"] = runtime.function(publishAsync).toJSValue()
}
@Interop[ArkTS]
public func clearContainerByEventTypeName(eventTypeName:String):Unit{
    let container = m.mbassadorConfiguration.eventMap.get(eventTypeName).getOrThrow().eventContainer
    container.clear()
}




