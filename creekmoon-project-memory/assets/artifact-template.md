---
layer: artifact
doc_type: artifact
artifact: {artifact-id}
business_name: {业务名称}
aliases:
  - {别名1}
  - {别名2}
why_exists: {一句话：这个产物为什么存在，它解决了什么问题}
business_goal: {业务目标：服务谁，达成什么效果}
producers:
  - {创建者1：系统/角色/事件}
consumers:
  - {消费者1：系统/角色/下游流程}
data_in:
  - {主要输入：来源 + 格式}
data_out:
  - {主要输出：存放位置 + 格式}
failure_impact: {失败时影响什么业务流程}
no_failure_impact: {失败时不影响什么（降级声明）}
related_artifacts:
  - {相关产物 ID}
related_journeys:
  - {相关流程 ID}
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
---

# {业务名称}

## 1. Why Exists

{详细说明为什么需要这个产物。它解决了什么痛点？没有它会怎样？它是主业务结果还是辅助产物？}

**业务目标**：{具体的业务目标，例如"让运营可以解释某次询价为什么是这个价格"}

## 2. Producers & Consumers

**创建者**：
- {创建者1}：{创建时机和条件}
- {创建者2}：{创建时机和条件}

**消费者**：
- {消费者1}：{消费方式和目的}
- {消费者2}：{消费方式和目的}

## 3. Main Lifecycle（摘要）

> 完整的阶段表和数据流表见 [{artifact-id}/lifecycle.md]({artifact-id}/lifecycle.md)

| Stage | Summary |
|-------|---------|
| {阶段1} | {一句话说明发生了什么} |
| {阶段2} | {一句话说明发生了什么} |
| {阶段3} | {一句话说明发生了什么} |

## 4. Inputs & Outputs

**输入**：
- {输入1}：来自 {来源}，格式 {格式}

**输出**：
- {输出1}：存放在 {位置}，通过 {方式} 访问

## 5. Failure Behavior

**失败时影响**：{失败时哪些业务流程受影响}

**失败时不影响**：{哪些流程可以正常继续（降级声明）}

**关键规则**：{例如"生成失败不能阻断主链路"，或"失败必须中断后续流程"}

## 6. Related Artifacts

| Artifact | Relation |
|----------|----------|
| {相关产物} | {关系描述，如"由本产物驱动创建"/"本产物消费其输出"} |

## 7. Evidence Anchors

- `{EntryClass.method()}`（{职责}）
- `{table_name}`（{存储描述}）
- `{POST /api/path}`（{API 说明}）

## 8. Navigation

- ↑ 上级：[artifacts/index.md](../index.md)
- ↓ 生命周期详情：[{artifact-id}/lifecycle.md]({artifact-id}/lifecycle.md)
- ↓ 代码 Trace（如已建立）：[{artifact-id}/trace-{area}.md]({artifact-id}/trace-{area}.md)
- → 相关流程：[journeys/index.md](../../journeys/index.md)

## 9. When To Escalate

- 需要了解每个生命周期阶段的数据流转和消费者 → `{artifact-id}/lifecycle.md`
- 需要改对应代码、排查副作用顺序 → `{artifact-id}/trace-{area}.md`
