/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights resveved.
 */
package mbassador4cj

import std.collection.*
import std.collection.concurrent.*
/*
 * 使用方法：
 * 1、需要使用者实现接口subscriber，publish（对于仓颉语言）其他语言需要宏编译
 * 2、创建event对象容器，有三个属性，发布者，订阅者，事件名称
 * 3、使用event对象容器，初始化订阅工厂，发布工厂，然后创建Mbassador对象(单例的发布工厂，订阅工厂)
 * 4、使用Mbassador的register订阅，unregister取消订阅，publish发布
 */
public class Mbassador {
    // private let Logger: SimpleLogger = SimpleLogger()
    //事件总线配置：事件map映射，发布工厂，订阅工厂，异步的并行参数 支持默认的
    public var mbassadorConfiguration: MbassadorConfiguration

    public init() {
        mbassadorConfiguration = MbassadorConfiguration()
    }

    public init(mbassadorConfiguration: MbassadorConfiguration) {
        this.mbassadorConfiguration = mbassadorConfiguration
    }

    //同步订阅
    public func register(event: Event): Unit {
        try {
            mbassadorConfiguration.getExector(Constant.REGISTER).execute(event)
        }catch(e:MbassadorException){
            throw MbassadorException("register fail")
        }

    }
    //取消订阅
    public func unregister(event: Event): Unit {
        try{
            mbassadorConfiguration.getExector(Constant.UNREGISTER).execute(event)
        }catch(e:MbassadorException){
            throw MbassadorException("unregister fail")
        }

    }
    //发布
    public func publish(event: Event): Unit {
        try{
            mbassadorConfiguration.getExector(Constant.PUBLISH).execute(event)
        }catch(e:MbassadorException){
            throw MbassadorException("publish fail")
        }
    }

    //异步订阅
    public func registerAsny(mbassadorConfiguration: MbassadorConfiguration, eventQueue: LinkedBlockingQueue<Event>): Unit {
        try {
            mbassadorConfiguration.executorService.asyncExec(FeatureType.REGISTER, mbassadorConfiguration, eventQueue)
        }catch(e:MbassadorException){
            throw MbassadorException("registerAsny fail")
        }
    }

    //异步取消订阅
    public func unregisterAsny(mbassadorConfiguration: MbassadorConfiguration, eventQueue: LinkedBlockingQueue<Event>): Unit {
        try{
            mbassadorConfiguration.executorService.asyncExec(FeatureType.UNREGISTER, mbassadorConfiguration, eventQueue)
        }catch(e:MbassadorException){
            throw MbassadorException("unregisterAsny fail")
        }

    }

    //异步发布
    public func publishAsny(mbassadorConfiguration: MbassadorConfiguration, eventQueue: LinkedBlockingQueue<Event>): Unit {
        try{
            mbassadorConfiguration.executorService.asyncExec(FeatureType.PUBLISH, mbassadorConfiguration, eventQueue)
        }catch(e:MbassadorException){
            throw MbassadorException("publishAsny fail")
        }
    }
}
