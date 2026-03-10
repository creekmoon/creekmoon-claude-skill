---
layer: system
doc_type: conventions
module: global
topic: conventions
aliases:
  - coding conventions
  - project conventions
symbols:
  - `{ExceptionClass}`
related:
  - index.md
  - data-model.md
  - ../02-modules/index.md
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
---

# 全局约定

> 记录跨模块共用的命名、异常、接口和工程约定。

## 1. Naming Rules

| Kind | Rule | Example |
|------|------|---------|
| Class | {规则} | `{ExampleClass}` |
| Method | {规则} | `{exampleMethod()}` |
| Table | {规则} | `{t_example}` |
| API Path | {规则} | `{/api/v1/example}` |

## 2. Error and Response Rules

| Scenario | Error Type | Status/Code | Notes |
|----------|------------|-------------|-------|
| {参数错误} | `{Exception}` | `{400 / 1000}` | {说明} |
| {未找到} | `{Exception}` | `{404 / 1001}` | {说明} |

## 3. Shared Engineering Conventions

- {事务边界约定}
- {日志约定}
- {幂等 / 重试 / 超时约定}
- {接口响应格式约定}

## 4. Retrieval Keywords

`{naming-rule}` / `{error-type}` / `{response-shape}` / `{shared-rule}`

## 5. Navigation

- ↑ 上级: [System Index](index.md)
- ← 相关: [data-model.md](data-model.md)
- ↓ 深入: [Modules Index](../02-modules/index.md)
