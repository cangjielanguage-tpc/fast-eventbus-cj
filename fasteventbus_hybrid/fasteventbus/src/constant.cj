/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package fasteventbus

import std.time.*

class Constant {

    //eventmap默认256
    public static let DEFAULT_EVENT_MAP_SIZE: Int64 = 1024
    //并行个数，类似与线程池的线程个数    
    public static let REGISTER: String = "REGISTER"
    public static let PUBLISH: String = "PUBLISH"
    public static let UNREGISTER: String = "UNREGISTER"
}

enum FeatureType {
    | REGISTER
    | UNREGISTER
    | PUBLISH
}
