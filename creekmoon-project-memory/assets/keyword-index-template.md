---
layer: indexes
doc_type: keyword-index
coverage: complete
last_verified: YYYY-MM-DD
confidence: high
---

# Keyword Index

> 业务关键词倒排索引。通过业务词、产物名、角色名、目标词快速定位 artifact 或 journey。

## 1. 业务能力词

| Key | Kind | Target Doc | Notes |
|-----|------|------------|-------|
| {业务能力词1} | 业务能力 | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | {补充说明} |
| {业务能力词2} | 业务能力 | [journey-{journey-id}](../01-business/journeys/journey-{journey-id}.md) | |

## 2. 业务产物名

| Key | Kind | Target Doc | Notes |
|-----|------|------------|-------|
| {产物名1} | 产物名 | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | {也叫 xxx} |
| {产物名2} | 产物名 | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | |

## 3. 生命周期阶段词

| Key | Kind | Target Doc | Notes |
|-----|------|------------|-------|
| {阶段词1} | 阶段 | [artifact-{artifact-id}/lifecycle](../01-business/artifacts/{artifact-id}/lifecycle.md) | |
| {阶段词2} | 阶段 | [artifact-{artifact-id}/lifecycle](../01-business/artifacts/{artifact-id}/lifecycle.md) | |

## 4. 角色词

| Key | Kind | Target Doc | Notes |
|-----|------|------------|-------|
| {角色名1} | 角色 | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | {消费者 / 创建者} |
| {角色名2} | 角色 | [journey-{journey-id}](../01-business/journeys/journey-{journey-id}.md) | |

## 5. 数据对象名 / 技术术语

| Key | Kind | Target Doc | Notes |
|-----|------|------------|-------|
| {数据对象名1} | 数据对象 | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | |
| {技术术语1} | 术语 | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | |

## 6. 目标 / 意图词

| Key | Kind | Target Doc | Notes |
|-----|------|------------|-------|
| {目标词1} | 意图 | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | {例如"诊断""排查""对账"} |

---

**索引规则**：
- 每个 Key 必须落到 `artifact-*.md` 或 `journey-*.md`，不落到 `module-*.md`
- 不在本页展开产物内容，只做映射
- 有别名时在 Notes 列注明
