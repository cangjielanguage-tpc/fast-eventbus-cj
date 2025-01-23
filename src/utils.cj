/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights resveved.
 */
package mbassador4cj

public class Utils {
    // private static let Logger: SimpleLogger = SimpleLogger()

    public static func checkObjectNone<T>(t: T): Bool {
        var tOption: ?T = Some(t)
        if (tOption.isNone()) {
            // Logger.info("tOption is None")
            return true
        }
        return false
    }
}
