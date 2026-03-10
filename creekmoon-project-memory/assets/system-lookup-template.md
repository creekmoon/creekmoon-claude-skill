---
layer: system
doc_type: lookup
module: global
topic: lookup
aliases:
  - global lookup
  - reverse index
symbols: []
related:
  - index.md
  - ../02-modules/index.md
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
---

# Lookup

> 唯一反向索引。通过符号、别名、场景词、故障现象优先定位到 topic；只有确实涉及方法级逻辑时才补充 deep。

## 1. Lookup Table

| Key | Kind | Module | Primary Doc | Topic | Deep |
|-----|------|--------|-------------|-------|------|
| `OrderService.createOrder()` | symbol | `order` | [mod-order](../02-modules/mod-order.md) | [topic-create-order](../02-modules/order/topic-create-order.md) | |
| 下单 | alias | `order` | [mod-order](../02-modules/mod-order.md) | [topic-create-order](../02-modules/order/topic-create-order.md) | |
| `StockService.reserve()` | symbol | `order` | [mod-order](../02-modules/mod-order.md) | [topic-create-order](../02-modules/order/topic-create-order.md) | [deep-create-order](../02-modules/order/deep-create-order.md) |
| 订单重复创建 | symptom | `order` | [mod-order](../02-modules/mod-order.md) | [topic-order-idempotency](../02-modules/order/topic-order-idempotency.md) | |

## 2. Organization Rules

- 本页不是首跳
- 本页只做映射，不展开主题细节
- 每个 key 必须落到模块主入口，并尽量落到一个主题叶子
- 只有当 key 明确指向方法级内部逻辑时，才填写 `Deep`
- 默认保持单文件，不主动拆成多个入口索引
- 推荐按模块或稳定键顺序组织，而不是随意追加

## 3. When To Split

- 仅在单文件 lookup 已因工具读取/搜索限制明显不可用时才拆分
- 即使拆分，也必须保留本页作为总入口
- 子 lookup 页不得成为新的首跳入口

## 4. Retrieval Keywords

`symbol` / `alias` / `scenario` / `symptom` / `topic`

## 5. Navigation

- ↑ 上级: [System Index](index.md)
- → 模块目录: [Modules Index](../02-modules/index.md)
