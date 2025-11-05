/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package mbassador4cj

public interface Subscriber {
    func onEvent(event: Event): Unit
}
