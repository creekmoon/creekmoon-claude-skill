---
name: agent-memory-skill
description: 面向 LLM 的单入口目录式项目记忆系统（.agent-memory/）。当项目存在 .agent-memory/ 时，在任何涉及代码的任务前先读取 `00-index.md`，然后按目录树逐级进入 `01-system/index.md` 或 `02-modules/index.md`，再进入模块主入口、主题叶子，必要时谨慎进入 deep 子层。Use when writing code, modifying code, debugging, reviewing code, refactoring, adding features, fixing bugs, understanding codebase, answering code questions, or when user mentions "分析项目", "建立记忆", "更新记忆", "了解项目", "接手项目". If .agent-memory/ exists, ALWAYS start from `00-index.md`, require topic-level memory for core modules, and use deep docs only when topic-level detail is insufficient.
---

# LLM Memory Skill V3

面向 LLM 的目录式项目记忆系统。目标不是“做一个精简目录”，而是“在渐进式披露前提下，把真正有用的业务主题和代码逻辑沉淀下来”。

**核心原则**: `.agent-memory/` 只记录经代码验证的事实，只保留稳定、可检索、按目录逐级暴露的信息。

## Quick Start

- **任何代码任务**: 若存在 `.agent-memory/`，先读 `.agent-memory/00-index.md`
- **根入口只有一个**: 不允许从 `system`、`modules` 或任何叶子文档直接作为首跳
- **严格逐级进入**: 根目录块 → 子目录块 → 模块主入口 → 主题叶子
- **目录块只导航**: `index.md` 只回答“下一跳去哪”
- **主题先于 deep**: 先写出能帮助编码的 topic，再决定是否需要 deep
- **叶子只讲事实**: `topic-{topic}.md` 负责主题主线、关键决策、边界摘要；`deep-{topic}.md` 负责方法级核心逻辑
- **效率优先**: 默认逐级跳转，但如果当前轮已经由父级 index 明确定位到子路径，可直接继续读取该子路径，不必回退到根

## Directory Truth

```
.agent-memory/
├── 00-index.md
├── 01-system/
│   ├── index.md
│   ├── context.md
│   ├── architecture.md
│   ├── tech-stack.md
│   ├── data-model.md
│   ├── conventions.md
│   └── lookup.md
├── 02-modules/
│   ├── index.md
│   └── mod-{module}.md
└── 02-modules/{module}/
    ├── topic-{topic}.md
    └── deep-{topic}.md
```

## Read Mode

### Scenario A: Auto Context

任何涉及代码的任务触发时：

1. 读 `.agent-memory/00-index.md`
2. 只在根层做一次选择：
   - 系统级问题 → `01-system/index.md`
   - 模块级问题 → `02-modules/index.md`
3. 如果进入 `01-system/index.md`：
   - 需要背景/架构/技术栈/模型/约定 → 读对应系统内容页
   - 需要通过符号、别名、场景词定位模块 → 读 `01-system/lookup.md`
4. 如果进入 `02-modules/index.md`：
   - 先定位模块，再读 `02-modules/mod-{module}.md`
5. 若模块主入口仍不够，再读 `02-modules/{module}/topic-{topic}.md`
6. 只有当 topic 仍不足以支持写代码、改逻辑、修复杂 bug 时，才读 `02-modules/{module}/deep-{topic}.md`
7. 如果当前轮已经由父级 index 明确得到了某个子路径，可直接继续该子路径，不必反复回退
8. 不在未知路径情况下把叶子文档当首跳
9. 够用就停，不默认全量阅读
10. 静默使用上下文，除非用户要求，不主动复述全部记忆

### Scenario B: Onboarding

用户让你“接手项目/了解项目”时：

1. `00-index.md`
2. `01-system/index.md`
3. 只按需要读 `context.md`、`architecture.md`、`tech-stack.md`
4. `02-modules/index.md`
5. 选相关模块，读 `mod-{module}.md`
6. 进入核心 `topic-{topic}.md`
7. 只在需要方法级逻辑时进入 `deep-{topic}.md`

## Efficiency Rules

1. **新查询**: 默认从 `00-index.md` 开始
2. **同轮续读**: 如果当前轮已经通过父级目录确认了精确子路径，允许直接续读该子路径
3. **不猜兄弟节点**: 不并行试读多个模块或多个 topic，除非父级索引明确提示它们都相关
4. **不为形式回退**: 已经确认 `mod-{module}.md` 或 `topic-{topic}.md` 与当前问题直接相关时，不必为了遵守流程再次回到根目录重读
5. **默认停在最浅可用层**: 模块文档足够回答时，不进入 topic；topic 足够回答时，不进入 deep

## Write Mode

### Verification Baseline

写入前，每条事实都必须完成下列验证：

1. **存在性**: 用搜索和阅读确认类名、方法名、路由、表名、Topic 真实存在
2. **完整性**: 抽查关键实现，确认不是空实现，也不是 `TODO`、`FIXME`、`HACK`
3. **可用性**: 有实际调用方、入口或配置支撑，不是孤立死代码
4. **排除项**:
   - `@Deprecated` / `deprecated`
   - 测试 mock
   - 注释掉的代码
   - 默认关闭的 feature flag
   - WIP / 实验性 / 临时方案

不确定的不写。

### Scenario C: Initial Setup

1. 先创建 `.agent-memory/00-index.md`
2. 建 `01-system/`，从 `index.md` 开始，再补系统事实内容页和 `lookup.md`
3. 建 `02-modules/`，先写 `index.md`，再按业务领域创建 `mod-{module}.md`
4. 对每个核心模块，必须创建 `1-3` 个真正能帮助编码的 `topic-{topic}.md`
5. 只有当 topic 无法承载方法级核心逻辑时，才创建 `deep-{topic}.md`
6. 每次新增模块、topic 或 deep 文档时，同步更新：
   - `00-index.md`
   - `01-system/index.md`
   - `01-system/lookup.md`
   - `02-modules/index.md`
   - 对应 `mod-{module}.md`

### Scenario D: Post-change Update

1. 先验证变更已真实落代码
2. 按影响面更新对应层级：
   - 系统定位、技术栈、约定变化 → `01-system/`
   - 模块边界、能力、入口变化 → `02-modules/mod-{module}.md`
   - 某主题的流程、边界、异常现象变化 → `02-modules/{module}/topic-{topic}.md`
   - 方法级核心逻辑、关键判断树、状态变更细节变化 → `02-modules/{module}/deep-{topic}.md`
3. 任何新增或失效的类名、方法名、路由、别名、场景词，都要同步更新 `01-system/lookup.md`
4. 若某个核心模块仍没有可用于编码的 topic，优先补 topic，而不是继续堆模块介绍

## Layer Rules

| 层级 | 目录 | 回答的问题 | 必须避免 |
|------|------|------------|----------|
| 根目录块 | `00-index.md` | 下一步进 system 还是 modules？ | 系统细节、模块细节 |
| 系统目录块 | `01-system/index.md` | 系统文档有哪些，lookup 在哪？ | 具体模块主题 |
| 模块目录块 | `02-modules/index.md` | 有哪些模块，先看哪个模块？ | 主题细节 |
| 模块主入口 | `02-modules/mod-{module}.md` | 这个模块负责什么，有哪些主题？ | 全量系统说明 |
| 主题叶子 | `02-modules/{module}/topic-{topic}.md` | 这个主题主线怎么走、关键决策和边界摘要是什么？ | 退化成纯目录说明 |
| deep 子层 | `02-modules/{module}/deep-{topic}.md` | 方法级核心逻辑、关键判断、状态变化、副作用是什么？ | 成为默认首跳或泛滥创建 |

## Mandatory Writing Standards

1. 每篇文档都必须带 machine-readable frontmatter
2. `lookup.md`、`mod-{module}.md`、`topic-{topic}.md` 都必须有 `aliases` 和 `symbols`
3. 每篇文档都必须有 `coverage`、`last_verified`、`confidence`
4. 每篇文档都必须有可检索关键词和导航链接
5. 同一事实只放在最合适的一层，避免跨层重复
6. 模块按业务领域划分，不按技术目录划分
7. 目录块只做导航，不承担大段解释
8. 每个核心模块初始化时必须产出 topic，而不是只产出模块页
9. topic 先承担主题主线与决策摘要，deep 只在必要时补方法级逻辑
10. lookup 有明确 topic 时必须尽量落到 topic，不能只停在模块页

详细格式、frontmatter、lookup 规则、增长约束、拆分触发和模板映射见 [reference.md](reference.md)。
