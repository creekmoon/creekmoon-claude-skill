---
name: agent-memory-skill
description: 项目记忆缓存系统（.agent-memory/）。项目存在 .agent-memory/ 目录时，在任何涉及代码的任务前自动读取记忆获取上下文。Use when writing code, modifying code, debugging, reviewing code, refactoring, adding features, fixing bugs, understanding codebase, answering code questions, or when user mentions "分析项目", "建立记忆", "更新记忆", "了解项目", "接手项目". If .agent-memory/ exists, ALWAYS read relevant memory before starting any code task.
---

# Agent Memory Skill

渐进式项目记忆系统。通过三层文档结构让 AI 快速理解项目全貌，按需深入细节。

**核心原则**: `.agent-memory/` 只记录**经代码验证的事实**，不记录未实现/开发中/WIP 内容。

## Quick start

- **任何代码任务** → 检查 `.agent-memory/` 是否存在，存在则先读取相关记忆
- **接手项目** → 从 `.agent-memory/01-system/00-index.md` 开始阅读
- **建立记忆** → 按 系统层 → 模块层 → 深度层 顺序创建文档
- **更新记忆** → 验证代码事实后，更新对应层级文档

## Mode detection

**第 0 步**: 检查项目根目录是否存在 `.agent-memory/` 目录。

| 场景 | 模式 | 动作 |
|------|------|------|
| 有 `.agent-memory/` + 任何涉及代码的任务 | **读模式-自动** | 静默读取相关记忆，辅助当前任务 |
| "帮我了解/接手这个项目" | **读模式-全量** | 按顺序阅读全部文档，向用户汇报 |
| "分析项目，建立记忆文档" | **写模式-初始化** | 扫描+验证代码，创建文档体系 |
| "XX已完成，更新记忆" | **写模式-更新** | 验证代码事实后更新对应文档 |

## Document structure

```
.agent-memory/
├── 01-system/                    # Layer 1: 全景概览（最稳定）
│   ├── 00-index.md              # 入口索引（总是首先读）
│   ├── 01-context.md            # 项目上下文
│   ├── 02-architecture.md       # 架构概览
│   ├── 03-tech-stack.md         # 技术栈
│   ├── 04-data-model.md         # 核心数据模型
│   └── 05-conventions.md        # 全局约定
│
├── 02-modules/                   # Layer 2: 业务领域划分（按需读）
│   ├── 00-index.md              # 模块清单
│   └── mod-{领域}.md            # 各模块文档
│
└── 03-deep/                      # Layer 3: 实现细节（深入时读）
    ├── 00-index.md              # 深度主题索引
    └── {模块名}/                # 按模块组织的深度文档
        ├── flow-{流程}.md       # 业务流程
        ├── lifecycle-{实体}.md  # 生命周期
        ├── dataflow-{场景}.md   # 数据流
        └── interaction-{协作}.md # 模块交互
```

---

## Instructions: Read mode

### Scenario A: Auto-context (自动上下文 — 最常用)

任何涉及代码的任务触发时：

1. 读 `01-system/00-index.md` → 获取系统定位和模块清单
2. 根据任务内容定位相关模块 → 读 `02-modules/mod-{模块}.md`
3. 需要实现细节时 → 读 `03-deep/{模块名}/` 下对应文档
4. **静默使用上下文**，不主动向用户转述记忆内容（除非被问到）

### Scenario B: Onboarding (接手项目)

按以下顺序阅读，由浅入深，并向用户汇报：

1. `01-system/00-index.md` → 系统定位和模块全景
2. `01-system/01-context.md` → 项目背景和边界
3. `01-system/02-architecture.md` → 架构分层
4. `01-system/03-tech-stack.md` → 技术选型
5. `02-modules/00-index.md` → 模块清单
6. 根据任务选择 `mod-{相关模块}.md` 深入

---

## Instructions: Write mode

### Verification baseline (写入底线)

**每条记录写入前，必须完成代码事实验证：**

1. **存在性**: 用 Grep/Read 确认类名/方法名/路由确实存在于代码中
2. **完整性**: Read 抽查方法体，确认非空实现，不含 `TODO`/`FIXME`/`HACK`/`NotImplementedException`
3. **可用性**: 有实际调用链（非孤立死代码），配置/依赖已就绪（非注释掉的配置）
4. **排除项**:
   - ❌ `@Deprecated` / `deprecated` 标记的代码
   - ❌ 测试类/测试方法中的 mock 实现
   - ❌ 注释掉的代码块
   - ❌ feature flag 关闭状态的功能
   - ❌ 开发中(WIP)、实验性、临时方案

**验证方法**: 对每个证据锚点，Grep 确认符号存在 + Read 抽查关键方法确认非空实现。不确定的不写。

### Scenario C: Initial setup (首次建立)

**Step 1 — 探索项目**
- 扫描项目结构（pom.xml/package.json、目录树、配置文件）
- 识别技术栈、架构风格、业务领域划分

**Step 2 — 创建系统层** (`01-system/`)
- 使用 `assets/system-*-template.md` 模板
- 从 `00-index.md` 开始，依次填充 01~05
- 约束: 全部控制在 500 行以内，只记录稳定信息

**Step 3 — 创建模块层** (`02-modules/`)
- 按业务领域划分（不按技术分层）
- 使用 `assets/module-template.md` 模板
- 约束: 每篇 ≤ 300 行，用类名/方法名代替代码示例

**Step 4 — 创建深度层** (`03-deep/`) — 按需
- 为每个需要深入的模块创建子目录
- 使用 `assets/deep-*-template.md` 模板
- 约束: 使用 Mermaid 图，禁止贴原始代码

**Step 5 — 验证（必须）**
- 对所有证据锚点执行 Verification baseline 检查
- 检查所有文档间链接可达
- 确保三层间有清晰的导航路径

### Scenario D: Post-change update (变更后更新)

**Step 1 — 审查代码现状**
- 用 Grep/Read 审查变更涉及的代码，确认实现完整且可用

**Step 2 — 识别变更范围**
- 架构/技术栈变化 → 更新系统层
- 模块能力变化 → 更新对应模块文档
- 数据流/生命周期变化 → 更新深度层

**Step 3 — 执行更新**
- 只修改受影响的文档
- 每条新增/修改记录需通过 Verification baseline
- 删除已废弃的信息

---

## Layer rules

| 层级 | 行数限制 | 核心内容 | 禁止内容 |
|------|----------|----------|----------|
| 系统层 | 全部 ≤ 500行 | 定位、架构、技术栈、数据模型、约定 | 具体接口列表、字段详情 |
| 模块层 | 每篇 ≤ 300行 | 边界、能力清单(+锚点)、入口类、流程概要 | 长篇代码示例 |
| 深度层 | 按需创建 | 业务流程、生命周期、数据流、模块交互 | 直接贴原始代码 |

## Writing standards

1. **证据锚点**: 每条记录必须有可验证的代码锚点（类名/方法名/路由/表名）
2. **禁止编造**: 不确定的信息不写
3. **面向检索**: 每个文档包含可检索关键词章节
4. **导航链接**: 每个文档底部包含 ↑上级 / →相关 / ↓深入 的导航
5. **模块划分**: 按业务领域划分，不按技术分层

详细格式规范、证据锚点格式、Mermaid 图表规范和正反示例见 [reference.md](reference.md)。

## Templates

模板文件位于本 Skill 的 `assets/` 目录，创建文档时按需使用：

| 层级 | 模板文件 | 生成目标 |
|------|----------|----------|
| 系统层 | `system-*-template.md` (6个) | `01-system/00~05-*.md` |
| 模块层 | `modules-index-template.md` | `02-modules/00-index.md` |
| 模块层 | `module-template.md` | `02-modules/mod-{领域}.md` |
| 深度层 | `deep-index-template.md` | `03-deep/00-index.md` |
| 深度层 | `deep-flow-template.md` | `03-deep/{模块}/flow-{流程}.md` |
| 深度层 | `deep-lifecycle-template.md` | `03-deep/{模块}/lifecycle-{实体}.md` |
| 深度层 | `deep-dataflow-template.md` | `03-deep/{模块}/dataflow-{场景}.md` |
| 深度层 | `deep-interaction-template.md` | `03-deep/{模块}/interaction-{协作}.md` |
