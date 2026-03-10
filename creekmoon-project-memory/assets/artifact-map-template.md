---
layer: business
doc_type: artifact-map
coverage: complete
last_verified: YYYY-MM-DD
confidence: high
---

# Artifact Map

> 业务产物全景图。一眼看清所有产物、它们是什么类型、彼此关系如何。

## 1. Artifact List

| Artifact ID | 业务名 | 类型 | 一句话描述 | 文档 |
|-------------|--------|------|------------|------|
| {artifact-id-1} | {业务名} | 主交易单据 | {一句话} | [artifact-{artifact-id-1}.md](artifacts/artifact-{artifact-id-1}.md) |
| {artifact-id-2} | {业务名} | 派生产物 | {一句话} | [artifact-{artifact-id-2}.md](artifacts/artifact-{artifact-id-2}.md) |
| {artifact-id-3} | {业务名} | 审计流水 | {一句话} | [artifact-{artifact-id-3}.md](artifacts/artifact-{artifact-id-3}.md) |

**类型说明**：
- **主交易单据**：业务的核心实体，驱动状态流转（如订单、询价请求）
- **派生产物**：由主链路自动生成，服务于诊断/审计/展示（如分析报告、余额流水）
- **审计流水**：变更记录，只写不改（如余额流水、操作日志）
- **配置/规则**：驱动业务行为的规则定义（如报价流程、费率规则）

## 2. Artifact Relations

```
{artifact-id-1} ──驱动──▶ {artifact-id-2}
    │
    └──触发──▶ {artifact-id-3}（审计流水）
               {artifact-id-4}（派生产物）
```

或用表格描述：

| From | To | Relation | When |
|------|----|----------|------|
| {artifact-a} | {artifact-b} | 驱动创建 | {触发条件} |
| {artifact-a} | {artifact-c} | 自动生成 | {触发条件} |

## 3. Key Journeys

跨产物端到端流程（详见 [journeys/index.md](journeys/index.md)）：

| Journey | Artifacts Involved | 文档 |
|---------|-------------------|------|
| {journey-id-1} | {artifact-a} → {artifact-b} → {artifact-c} | [journey-{journey-id-1}.md](journeys/journey-{journey-id-1}.md) |
