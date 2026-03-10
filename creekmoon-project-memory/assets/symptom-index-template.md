---
layer: indexes
doc_type: symptom-index
coverage: complete
last_verified: YYYY-MM-DD
confidence: high
---

# Symptom Index

> 故障现象倒排索引。通过可观测的错误表现、异常行为快速定位 artifact 和 trace。

## 1. 状态卡死 / 无法推进

| Symptom | Possible Cause | Artifact Doc | Trace Doc |
|---------|----------------|--------------|-----------|
| {症状描述1，如"询价无法再次发起，提示进行中"} | {可能原因，如"processing 状态未收敛"} | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | [trace-{area}](../01-business/artifacts/{artifact-id}/trace-{area}.md) |
| {症状描述2} | {可能原因} | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | — |

## 2. 数据异常 / 不一致

| Symptom | Possible Cause | Artifact Doc | Trace Doc |
|---------|----------------|--------------|-----------|
| {症状描述，如"余额扣减后账单未创建"} | {可能原因} | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | [trace-{area}](../01-business/artifacts/{artifact-id}/trace-{area}.md) |
| {症状描述，如"重复扣款"} | {可能原因，如"退款幂等未生效"} | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | [trace-{area}](../01-business/artifacts/{artifact-id}/trace-{area}.md) |

## 3. 产物缺失 / 不生成

| Symptom | Possible Cause | Artifact Doc | Trace Doc |
|---------|----------------|--------------|-----------|
| {症状描述，如"诊断报告下载 404"} | {可能原因，如"OSS 上传失败"} | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | [trace-{area}](../01-business/artifacts/{artifact-id}/trace-{area}.md) |

## 4. 权限 / 认证问题

| Symptom | Possible Cause | Artifact Doc | Trace Doc |
|---------|----------------|--------------|-----------|
| {症状描述，如"接口返回 401"} | {可能原因} | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | — |

## 5. 业务流程异常

| Symptom | Possible Cause | Artifact Doc | Trace Doc |
|---------|----------------|--------------|-----------|
| {症状描述，如"轨迹未更新但追踪号已绑定"} | {可能原因} | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | [trace-{area}](../01-business/artifacts/{artifact-id}/trace-{area}.md) |

---

**索引规则**：
- 症状描述尽量使用可观测的表现（报错信息、界面异常、数据不对），而不是原因
- 每条记录至少落到一个 `artifact-*.md`；若有对应 trace，同时落 `trace-*.md`
- Possible Cause 只写初步判断，不展开完整排查步骤
