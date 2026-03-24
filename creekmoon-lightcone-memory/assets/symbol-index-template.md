---
type: index
name: symbol
title: 代码符号索引
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
---

# 代码符号索引

## 类型/类

| 符号 | 类型 | 业务产物 | 位置 |
|------|------|----------|------|
| `{ClassName/TypeName}` | 业务逻辑层 | [{artifact}](business/artifacts/{artifact}.md) | `{文件路径}` |

## 方法/函数

| 符号 | 业务产物 | 位置 | 作用 |
|------|----------|------|------|
| `{ClassName}.{method}({ParamType})` 或 `{function_name}` | [{artifact}](business/artifacts/{artifact}.md) | `{文件路径}` | {用途} |

> **位置说明**：使用文件路径或 `{ClassName}.{method}(ParamType)` 签名格式，不记录行号。行号会漂移，签名更稳定。

## 表/集合

| 符号 | 业务产物 | 说明 |
|------|----------|------|
| `{table/collection}` | [{artifact}](business/artifacts/{artifact}.md) | {描述} |
