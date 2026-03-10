---
layer: system
doc_type: data-model
module: global
topic: data-model
aliases:
  - entities
  - tables
symbols:
  - `{Entity}`
  - `{table_name}`
related:
  - index.md
  - tech-stack.md
  - conventions.md
  - ../02-modules/index.md
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
---

# 核心数据模型

> 只保留最关键的实体、主表和状态定义，不展开所有字段细节。

## 1. Core Entities

| Entity | Table | Responsibility | Key Status/Enum | Owner Module |
|--------|-------|----------------|-----------------|--------------|
| `{EntityA}` | `{t_entity_a}` | {职责} | `{StatusEnumA}` | `{module-a}` |
| `{EntityB}` | `{t_entity_b}` | {职责} | `{StatusEnumB}` | `{module-b}` |

## 2. Important Relations

| From | To | Relation | Why |
|------|----|----------|-----|
| `{EntityA}` | `{EntityB}` | {1:N / N:1} | {说明} |
| `{EntityB}` | `{EntityC}` | {1:1 / N:N} | {说明} |

## 3. Important Enums

| Enum | Used By | Meaning |
|------|---------|---------|
| `{StatusEnum}` | `{Entity}` | {说明} |
| `{TypeEnum}` | `{Entity}` | {说明} |

## 4. Retrieval Keywords

`{entity}` / `{table}` / `{enum}` / `{status}` / `{owner-module}`

## 5. Navigation

- ↑ 上级: [System Index](index.md)
- ← 相关: [tech-stack.md](tech-stack.md)
- → 相关: [conventions.md](conventions.md)
- ↓ 深入: [Modules Index](../02-modules/index.md)
