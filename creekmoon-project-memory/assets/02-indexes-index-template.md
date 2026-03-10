---
layer: indexes
doc_type: index
coverage: complete
last_verified: YYYY-MM-DD
confidence: high
---

# Indexes Index

> 检索层目录块。按问题类型选择对应的倒排索引。

## 1. Index Selection

| 我想找什么 | 使用哪个索引 | Path |
|-----------|-------------|------|
| 业务词 / 产物名 / 角色名 / 目标词 | keyword-index | [keyword-index.md](keyword-index.md) |
| 类名 / 方法名 / API 路径 / 表名 / 定时任务 | symbol-index | [symbol-index.md](symbol-index.md) |
| 故障现象 / 错误表现 / 异常名 | symptom-index | [symptom-index.md](symptom-index.md) |
| 状态名 / 阶段名 / 枚举值 | stage-index | [stage-index.md](stage-index.md) |

## 2. Index Rules

- 所有索引落点必须是 `01-business/artifacts/artifact-*.md` 或 `trace-*.md`
- 禁止只落到 `03-code/module-*.md`
- 索引只做映射，不展开内容

## 3. Stop Rule

本页只导航，不列索引内容。
