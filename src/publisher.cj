/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights resveved.
 */
package mbassador4cj

public interface Publisher {
    func publish(event: Event): Unit
}
