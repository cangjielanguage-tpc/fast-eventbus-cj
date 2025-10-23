/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package fasteventbus

public interface Publisher {
    func publish(event: Event): Unit
}
