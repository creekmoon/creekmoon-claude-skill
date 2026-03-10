---
layer: indexes
doc_type: stage-index
coverage: complete
last_verified: YYYY-MM-DD
confidence: high
---

# Stage Index

> 状态/阶段倒排索引。通过状态名、枚举值、阶段名快速定位 artifact 和 lifecycle 文档。

## 1. Stage / State Table

| Stage / State | Artifact | Lifecycle Doc | Meaning | Entry Condition | Exit Condition |
|---------------|----------|---------------|---------|-----------------|----------------|
| `{STATE_NAME_1}` | {artifact-id} | [lifecycle](../01-business/artifacts/{artifact-id}/lifecycle.md) | {这个状态意味着什么} | {什么条件进入这个状态} | {什么条件离开} |
| `{STATE_NAME_2}` | {artifact-id} | [lifecycle](../01-business/artifacts/{artifact-id}/lifecycle.md) | {意义} | {进入条件} | {退出条件} |
| `{STATE_NAME_3}` | {artifact-id-2} | [lifecycle](../01-business/artifacts/{artifact-id-2}/lifecycle.md) | {意义} | {进入条件} | {退出条件} |

## 2. Enum / Constant Cross-Reference

| Enum Class | Value | Maps To | Notes |
|------------|-------|---------|-------|
| `{DictConstant.ORDER_STATUS_*}` | `{数值}` | `{STATE_NAME}` | {说明} |
| `{DictConstant.BILL_STATUS_*}` | `{数值}` | `{STATE_NAME}` | {说明} |

---

**索引规则**：
- 每个 Stage 必须落到对应的 `lifecycle.md`，而不是 `module-*.md`
- Entry/Exit Condition 要足够精确，方便直接用于代码排查
- 枚举值与状态名的对应关系尤其重要，避免因不了解枚举含义而改错条件判断
