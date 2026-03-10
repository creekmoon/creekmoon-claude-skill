---
layer: code
doc_type: module
module: {module-id}
business_name: {模块业务名称}
owned_artifacts:
  - {artifact-id-1}
  - {artifact-id-2}
owned_traces:
  - {artifact-id-1}/trace-{area}
coverage: complete
last_verified: YYYY-MM-DD
confidence: high
---

# {模块业务名称} 模块

> 代码归属视图。只回答"这个模块拥有哪些 artifacts / traces"。
> 业务主叙事在 `01-business/artifacts/` 层，不在这里。

## 1. Module Boundary

- **In Scope**：{模块负责的代码范围，如 controller/service/mapper 路径}
- **Out of Scope**：{明确不属于本模块的，且容易混淆的内容}

## 2. Owned Artifacts

| Artifact | 业务名 | Doc |
|----------|--------|-----|
| {artifact-id-1} | {业务名} | [artifact-{artifact-id-1}.md](../../01-business/artifacts/artifact-{artifact-id-1}.md) |
| {artifact-id-2} | {业务名} | [artifact-{artifact-id-2}.md](../../01-business/artifacts/artifact-{artifact-id-2}.md) |

## 3. Owned Traces

| Trace | Artifact | Doc |
|-------|----------|-----|
| trace-{area} | {artifact-id} | [trace-{area}.md](../../01-business/artifacts/{artifact-id}/trace-{area}.md) |

## 4. Key Entry Points

| Kind | Symbol | Artifact |
|------|--------|----------|
| API | `{POST /api/path}` | {artifact-id} |
| Method | `{Service.method()}` | {artifact-id} |
| Scheduler | `{ScheduledTask.run()}` | {artifact-id} |

## 5. Navigation

- ↑ 上级：[03-code/index.md](index.md)
- → 业务层：[01-business/artifacts/index.md](../../01-business/artifacts/index.md)
