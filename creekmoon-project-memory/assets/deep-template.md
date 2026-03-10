---
layer: deep
doc_type: deep
module: {module}
topic: {topic}
aliases:
  - {方法级别名}
  - {调试别名}
symbols:
  - `{CoreService.method()}`
  - `{DomainObject.transition()}`
related:
  - ../mod-{module}.md
  - topic-{topic}.md
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
---

# deep-{topic}

> `topic-{topic}.md` 的谨慎子层。这里只记录真正会影响编码正确性的底层业务逻辑。

## 1. Deep Boundary

- {本页只解释哪一组内部方法或判断树}
- {为什么 topic 不足以承载这些细节}
- {哪些任务会需要进入本页，例如修复杂 bug / 改核心流程}

## 2. Core Methods

| Symbol | Role | Why It Matters |
|--------|------|----------------|
| `{Service.method()}` | {职责} | {原因} |
| `{Repository.method()}` | {职责} | {原因} |

## 3. Decision Tree

| Step | Guard / Condition | Action | Side Effect |
|------|-------------------|--------|-------------|
| 1 | `{condition-a}` | {动作} | {副作用} |
| 2 | `{condition-b}` | {动作} | {副作用} |
| 3 | `{condition-c}` | {动作} | {副作用} |

## 4. State Changes

| From | To | Trigger | Persisted By |
|------|----|---------|--------------|
| `{state-a}` | `{state-b}` | `{trigger}` | `{symbol}` |
| `{state-b}` | `{state-c}` | `{trigger}` | `{symbol}` |

## 5. Invariants And Guards

- `{guard}`: {不满足时会怎样}
- `{guard}`: {为什么必须保持}

## 6. Non-goals

- 不重复模块边界和 topic 主线
- 不粘贴整段实现代码
- 不记录收益低、读取成本高的枝节细节

## 7. Evidence Anchors

- `{Service.method()}`
- `{aggregate.field}`
- `{table_or_topic}`

## 8. Navigation

- ↑ 返回 topic: [topic-{topic}.md](topic-{topic}.md)
- ↑ 返回模块: [../mod-{module}.md](../mod-{module}.md)
