# creekmoon-claude-skill

一套给 Claude / Cursor 用的技能规范，用来约束 AI 在写文档、写代码时的风格和颗粒度。

## 包含内容

| 目录 | 作用 |
|------|------|
| `creekmoon-prd-spec` | PRD 写作规范：大白话、图表优先，面向业务人员 |
| `creekmoon-trd-spec` | TRD 写作规范：架构/模块/接口层面，不写代码细节 |
| `creekmoon-code-style` | 代码风格：方法设计、入参、流程组织、命名 |
| `creekmoon-project-memory` | 项目记忆：`.agent-memory/` 渐进式知识库，方便 AI 快速接手项目 |

## 使用方式

把对应目录下的 `SKILL.md` 配置到 Claude 或 Cursor 的 skill 中，在相关场景下会自动触发。

## 状态

初版，后续会按实际使用情况慢慢调整。
