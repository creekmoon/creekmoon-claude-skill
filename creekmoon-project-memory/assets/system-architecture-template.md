---
layer: system
doc_type: architecture
module: global
topic: system-architecture
aliases:
  - architecture
  - topology
symbols:
  - `{Application}`
related:
  - index.md
  - context.md
  - tech-stack.md
  - ../02-modules/index.md
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
---

# 架构概览

> 解释系统如何组织、主要组件如何协作，以及主要运行边界在哪里。

## 1. Architecture Style

{单体分层 / 微服务 / 事件驱动 / 六边形架构 / CQRS ...}

## 2. Runtime Layers

| Layer | Responsibility | Code Location |
|-------|----------------|---------------|
| Presentation | {处理请求、参数校验、协议转换} | `{path}` |
| Application | {编排用例、事务边界} | `{path}` |
| Domain | {核心业务规则、领域对象} | `{path}` |
| Infrastructure | {存储、外部调用、消息} | `{path}` |

## 3. Core Components

| Component | Type | Responsibility | Entry Anchor |
|-----------|------|----------------|--------------|
| `{component-a}` | {service/module} | {职责} | `{ClassName}` |
| `{component-b}` | {service/module} | {职责} | `{ClassName}` |

## 4. Module Interaction Summary

| From | To | Why |
|------|----|-----|
| `{module-a}` | `{module-b}` | {调用原因} |
| `{module-b}` | `{external-system}` | {依赖原因} |

## 5. Retrieval Keywords

`{architecture-style}` / `{component}` / `{app-entry}` / `{config-key}` / `{runtime-boundary}`

## 6. Navigation

- ↑ 上级: [System Index](index.md)
- ← 相关: [context.md](context.md)
- → 相关: [tech-stack.md](tech-stack.md)
- ↓ 深入: [Modules Index](../02-modules/index.md)
