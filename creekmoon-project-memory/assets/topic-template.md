---
layer: topic
doc_type: topic
module: {module}
topic: {topic}
aliases:
  - {业务别名}
  - {故障现象别名}
symbols:
  - `{EntryClass.method()}`
  - `{POST /api/path}`
related:
  - ../mod-{module}.md
  - {optional: deep-{topic}.md}
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
---

# {topic}

> 单一主题叶子。这里同时回答“怎么走、为什么这样走、边界情况是什么”。

## 1. Topic Boundary

- {主题描述}
- {为什么需要独立成篇}
- {本主题的主入口或主问题}

## 2. Non-goals

- {不属于本主题、应由其他 topic 负责的内容}
- {另一条独立主线，不应并入本页}

## 3. Main Path

| Step | Actor | Action | Output |
|------|-------|--------|--------|
| 1 | `{Actor}` | {动作} | {输出} |
| 2 | `{Actor}` | {动作} | {输出} |
| 3 | `{Actor}` | {动作} | {输出} |

## 4. Key Decisions

| Condition | Action | Why |
|-----------|--------|-----|
| {条件A} | {动作A} | {解释} |
| {条件B} | {动作B} | {解释} |

## 5. Edge Cases

| Case | Guard | Outcome |
|------|-------|---------|
| {边界A} | `{guard}` | {结果} |
| {边界B} | `{guard}` | {结果} |

## 6. Evidence Anchors

- `{Class.method()}`
- `{POST /api/path}`
- `{table_or_topic}`

## 7. When To Escalate To Deep

- 当编码或调试需要落到稳定的内部方法组、关键 guard、状态变化顺序时，再进入 `deep-{topic}.md`
- 如果当前页已经足够回答“怎么改代码”，不要为了完整性进入 deep
- `deep-{topic}.md` 只能补充方法级逻辑，不能替代本页的主题主线

## 8. Split Trigger Check

- 如果新增内容对应另一组主入口、另一类独立异常族或另一条可独立命名的主线，应新建 `topic-*.md`
- 如果新增内容只是当前主题的自然分支，可继续并入本页

## 9. Retrieval Keywords

`{topic}` / `{alias}` / `{symptom}` / `{entry-method}` / `{edge-case}`

## 10. Navigation

- ↑ 上级: [mod-{module}.md](../mod-{module}.md)
- ↓ 如需要且已存在: `deep-{topic}.md`
