---
layer: indexes
doc_type: symbol-index
coverage: complete
last_verified: YYYY-MM-DD
confidence: high
---

# Symbol Index

> 代码符号倒排索引。通过类名、方法名、API 路径、表名、定时任务名快速定位 artifact 和 trace。

## 1. Service Methods

| Symbol | Kind | Artifact Doc | Trace Doc | Notes |
|--------|------|--------------|-----------|-------|
| `{Service.method()}` | method | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | [trace-{area}](../01-business/artifacts/{artifact-id}/trace-{area}.md) | {职责一句话} |
| `{Service2.method()}` | method | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | — | |

## 2. API Endpoints

| Symbol | Kind | Artifact Doc | Trace Doc | Notes |
|--------|------|--------------|-----------|-------|
| `POST /api/path` | api | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | — | {接口说明} |
| `GET /api/path` | api | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | — | |

## 3. Tables

| Symbol | Kind | Artifact Doc | Notes |
|--------|------|--------------|-------|
| `{table_name}` | table | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | {存储什么，key 字段} |

## 4. Scheduled Tasks

| Symbol | Kind | Artifact Doc | Notes |
|--------|------|--------------|-------|
| `{ScheduledTask.method()}` | scheduler | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | {调度频率 + 职责} |

## 5. Config Keys / Redis Keys

| Symbol | Kind | Artifact Doc | Notes |
|--------|------|--------------|-------|
| `{config.key}` | config | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | {作用说明} |
| `{REDIS:KEY:PATTERN}` | cache | [artifact-{artifact-id}](../01-business/artifacts/artifact-{artifact-id}.md) | {TTL + 用途} |

---

**索引规则**：
- Symbol 必须落到 `artifact-*.md`，有 trace 时同时落到 `trace-*.md`
- 禁止只落到 `module-*.md`
- Trace Doc 列为空表示暂无 trace，不代表方法不存在
