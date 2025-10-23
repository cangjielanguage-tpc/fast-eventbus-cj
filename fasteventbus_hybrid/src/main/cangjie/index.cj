package ohos_app_cangjie_fastevent_hybrid

internal import ohos.ark_interop.*
import ohos.ark_interop_macro.Interop
import fasteventbus.*

// 用户自定义的函数 addF64, 入参接收两个number，返回相加后的结果
@Interop[ArkTS]
public func addF64(a: Float64, b: Float64): Float64 {
    let t:TestH = TestH()
    t.addF64(a,b)
}

public func addF64(runtime: JSContext, callInfo: JSCallInfo): JSValue{
    let value0 = callInfo[0].toNumber()
    let value1 = callInfo[1].toNumber()
    let result = addF64(value0,value1)
    result.toJSValue(runtime)
}

let EXPORT_MODULE = JSModule.registerModule {
    runtime, exports =>
        exports["addF64"] = runtime.function(addF64).toJSValue()
}
