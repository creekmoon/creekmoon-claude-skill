---
layer: lifecycle
doc_type: lifecycle
artifact: {artifact-id}
related:
  - ../artifact-{artifact}.md
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
---

# {业务名称} — Lifecycle

> 完整生命周期 + 数据流。这里回答"每个阶段发生了什么、数据从哪来到哪去、消费者是谁"。
> 代码方法级调用顺序和副作用顺序见 `trace-*.md`。

## 1. Lifecycle Overview

```
{阶段1} ──→ {阶段2} ──→ {阶段3} ──→ {终态}
              │
              └── 失败 ──→ {失败处理阶段}
```

## 2. Stage Table（8 列）

| Stage | Trigger | Actor | Input | Processing Rule | Output | Persist / Cache / Write | Next Consumer |
|-------|---------|-------|-------|-----------------|--------|-------------------------|---------------|
| {阶段名1} | {什么事件触发} | `{Service.method()}` | {输入数据，含来源} | {核心处理规则，不是代码细节} | {产出物} | {持久化位置：DB表/Redis Key/OSS/内存} | {下一个消费者：角色/系统} |
| {阶段名2} | {什么事件触发} | `{Service.method()}` | {输入数据} | {核心处理规则} | {产出物} | {持久化位置} | {下一个消费者} |
| {阶段名3-失败分支} | {失败条件} | {Actor} | — | {失败处理规则} | {失败结果} | {是否持久化} | {是否通知消费者} |

## 3. Data Flow Table（6 列）

| Source | Transformation | Stored In | Exposed Via | Consumed By | Failure Impact |
|--------|----------------|-----------|-------------|-------------|----------------|
| {数据来源} | {经过什么处理} | {存在哪里：DB/Redis/OSS/内存/返回值} | {通过什么方式暴露：API/文件/消息/下载} | {最终消费者} | {这条数据链断了会怎样} |
| {数据来源2} | {经过什么处理} | {存在哪里} | {暴露方式} | {消费者} | {失败影响} |

## 4. Key Invariants

以下约束在任何代码变更中必须保持：

- **{不变量1}**：{不满足时的影响，例如"markFinished 必须在正常和异常路径都可达，否则 processing 状态永远不收敛"}
- **{不变量2}**：{为什么必须保持}
- **{不变量3}**：{为什么必须保持}

## 5. Failure Degradation

| Failure Scenario | Degradation Rule | Affected Downstream | Unaffected Downstream |
|------------------|------------------|---------------------|-----------------------|
| {失败场景1} | {降级规则：静默失败/重试/阻断} | {受影响的下游} | {不受影响的下游} |
| {失败场景2} | {降级规则} | {受影响} | {不受影响} |

## 6. Evidence Anchors

- `{Service.method()}`（{阶段对应方法}）
- `{table_name}`（{持久化位置}）
- `{Redis Key Pattern}`（{缓存说明}）

## 7. Navigation

- ↑ 返回产物主文档：[artifact-{artifact}.md](../artifact-{artifact}.md)
- ↓ 代码执行细节：[trace-{area}.md](trace-{area}.md)
