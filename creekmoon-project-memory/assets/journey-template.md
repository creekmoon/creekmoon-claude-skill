---
layer: journey
doc_type: journey
scenario: {scenario-id}
business_name: {业务场景名称}
aliases:
  - {别名1}
artifacts_involved:
  - {artifact-id-1}
  - {artifact-id-2}
  - {artifact-id-3}
related:
  - ../artifacts/index.md
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
---

# {业务场景名称}

## 1. Scenario Purpose

**为什么需要端到端视角**：{说明这条 journey 解决什么问题，为什么不能只看单个 artifact}

**完整链路覆盖**：从 {起点：用户操作/事件} 到 {终点：最终业务结果}

## 2. Cross-Artifact Sequence

| Step | Actor | Artifact | Action | Output | Next |
|------|-------|----------|--------|--------|------|
| 1 | {角色/系统} | {artifact-id} | {做什么} | {产出物} | 进入步骤 2 |
| 2 | {角色/系统} | {artifact-id} | {做什么} | {产出物} | 进入步骤 3 |
| 3 | {角色/系统} | {artifact-id} | {做什么} | {产出物} | 流程结束 |

## 3. Handoff Points

跨产物之间的移交节点：

| Handoff | From Artifact | To Artifact | Transfer Data | Transfer Mechanism |
|---------|---------------|-------------|---------------|---------------------|
| {移交1} | {artifact-a} | {artifact-b} | {移交的数据} | {同步调用/异步消息/数据库轮询} |
| {移交2} | {artifact-b} | {artifact-c} | {移交的数据} | {移交机制} |

## 4. Key Decisions

| Condition | Action | Why |
|-----------|--------|-----|
| {条件A} | {跳转到哪个分支} | {原因} |
| {条件B} | {终止流程 / 降级} | {原因} |

## 5. Failure Propagation

| Failure At | Propagates To | Impact | Recovery |
|------------|---------------|--------|----------|
| {artifact-a 阶段X失败} | {artifact-b / 整个流程} | {影响范围} | {恢复方式} |
| {artifact-b 阶段Y失败} | {后续artifact / 不传播} | {影响范围} | {降级规则} |

## 6. Evidence Anchors

- {artifact-id-1}：[artifact-{artifact-id-1}.md](../artifacts/artifact-{artifact-id-1}.md)
- {artifact-id-2}：[artifact-{artifact-id-2}.md](../artifacts/artifact-{artifact-id-2}.md)

## 7. Navigation

- ↑ 上级：[journeys/index.md](index.md)
- → 详细产物逻辑：[artifacts/index.md](../artifacts/index.md)
