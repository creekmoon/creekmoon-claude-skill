---
type: index
name: root
title: 项目入口
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
---

# {项目名称} 业务图谱

## 一句话描述

{项目核心业务}

## 核心产物（Artifacts）

| 产物 | 业务目标 | 关键状态 | 文档位置 |
|------|----------|----------|----------|
| {artifact-1} | {解决什么问题} | {状态流转} | [business/artifacts/{artifact-1}.md](business/artifacts/{artifact-1}.md) |
| {artifact-2} | {解决什么问题} | {状态流转} | [business/artifacts/{artifact-2}.md](business/artifacts/{artifact-2}.md) |

## 核心流程（Flows）

| 流程 | 涉及产物 | 业务场景 | 文档位置 |
|------|----------|----------|----------|
| {flow-1} | {artifact-1} → {artifact-2} | {端到端场景} | [business/flows/{flow-1}.md](business/flows/{flow-1}.md) |

## 快速导航

- **业务背景**：[business/context.md](business/context.md)
- **症状排查**：[atlas/symptom.md](atlas/symptom.md)
- **代码符号**：[atlas/symbol.md](atlas/symbol.md)
- **模块归属**：[code/modules.md](code/modules.md)

## 阅读指南

1. **新接手项目**：context → 核心产物 → 核心流程
2. **改代码**：定位产物 → 阅读 Deep Business Rules → 查看 Trace
3. **排查问题**：symptom索引 → 产物 Failure 章节
