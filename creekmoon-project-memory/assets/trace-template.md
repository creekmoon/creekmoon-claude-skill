---
layer: trace
doc_type: trace
artifact: {artifact-id}
area: {trace-area}
symbols:
  - `{CoreService.method()}`
  - `{AnotherService.method()}`
transaction_boundary: {说明事务边界，如"deductOrder 和 updateOrderStatus 在同一个 @Transactional 内"}
async_boundary: {说明异步边界，如"asyncPersistQuoteTracker 在 CompletableFuture 外，失败不回滚主链路"}
related:
  - ../lifecycle.md
  - ../artifact-{artifact}.md
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
---

# {业务名称} — Trace: {area}

> `lifecycle.md` 的代码执行子层。这里只记录影响编码正确性的底层逻辑。
> 业务目的和生命周期见 `lifecycle.md`。

## 1. Trace Boundary

- 本页只覆盖 {哪一组内部方法或执行路径}
- 适用场景：{什么任务需要进入本页，如"修改审批行为"/"排查重复扣款"/"改异步收敛逻辑"}
- 不需要本页的情况：{什么任务只看 lifecycle.md 就够了}

## 2. Call Chain

```
{EntryMethod}({params})
  ├── {step1}：{一句话说明做什么}
  ├── {step2}：{一句话说明做什么}
  │    └── {step2-1}：{一句话说明做什么}
  ├── {step3-guard}：{guard 条件} → {不满足时的行为}
  └── {step4}：{一句话说明做什么}
```

## 3. Key Guards

| Step | Guard / Condition | Pass Action | Fail Action | Side Effect on Fail |
|------|-------------------|-------------|-------------|---------------------|
| {步骤1} | `{guard-condition}` | {继续执行} | {抛异常 / return / 跳过} | {事务回滚 / 状态不变 / 日志} |
| {步骤2} | `{guard-condition}` | {继续执行} | {抛异常 / return} | {副作用} |

## 4. Transaction / Async Boundary

**事务边界**：
- `{method-a}` 和 `{method-b}` 在同一个 `@Transactional` 内，任意失败均回滚
- `{method-c}` **不在事务内**，{原因说明}

**异步边界**：
- `{async-method}` 在主链路之外异步执行，失败**不影响**{什么}
- 若需要保证执行，必须确保 {什么条件}

## 5. Side Effect Ordering

以下副作用有严格顺序，不能随意调换：

| Order | Side Effect | Why This Order |
|-------|-------------|----------------|
| 1 | {副作用1} | {原因} |
| 2 | {副作用2，依赖1的结果} | {原因} |
| 3 | {副作用3} | {原因} |

## 6. State Changes

| From State | To State | Trigger | Persisted By |
|------------|----------|---------|--------------|
| `{state-a}` | `{state-b}` | {触发条件} | `{table.column}` via `{method}` |
| `{state-b}` | `{state-c}` | {触发条件} | `{table.column}` via `{method}` |

## 7. Dangerous Change Points

改动以下代码时，必须额外小心：

| Point | Risk | Rule |
|-------|------|------|
| `{method/location}` | {风险描述} | {必须满足的规则} |
| `{method/location}` | {风险描述} | {必须满足的规则} |

## 8. Evidence Anchors

- `{Service.method()}`（{职责说明}）
- `{table.column}`（{状态字段说明}）
- `{Redis Key / OSS Path}`（{缓存/文件说明}）

## 9. Navigation

- ↑ 返回生命周期：[lifecycle.md](lifecycle.md)
- ↑ 返回产物主文档：[artifact-{artifact}.md](../artifact-{artifact}.md)
