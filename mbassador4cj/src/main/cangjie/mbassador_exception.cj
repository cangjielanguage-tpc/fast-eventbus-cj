/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package mbassador4cj

public class MbassadorException <: Exception {
    public init(message: ?String) {
        super(message.getOrThrow())
    }
    public override func toString(): String {
        "MbassadorException: ${message}"
    }
}
