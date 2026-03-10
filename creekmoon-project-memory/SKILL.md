---
name: agent-memory-skill
description: 面向 LLM 的业务产物优先型项目记忆系统（.agent-memory/）。以业务产物+生命周期为主线，倒排索引为检索入口，模块代码归属为辅助视图。Use when writing code, modifying code, debugging, reviewing code, refactoring, adding features, fixing bugs, understanding codebase, answering code questions, or when user mentions "分析项目", "建立记忆", "更新记忆", "了解项目", "接手项目". If .agent-memory/ exists, ALWAYS start from `00-index.md`.
---

# LLM Memory Skill V4

面向 LLM 的业务产物优先型项目记忆系统。

**核心原则**：文档的组织单位是**业务产物**（artifact）。每个产物清楚回答：为什么存在、谁创建、谁消费、如何流转、如何失败。检索靠人工倒排索引；代码归属是辅助视图，不是主叙事。

## Quick Start

- **任何代码任务**：若存在 `.agent-memory/`，先读 `00-index.md`
- **理解业务产物**：进 `01-business/artifacts/artifact-{artifact}.md`
- **看完整生命周期**：进 `artifacts/{artifact}/lifecycle.md`
- **改代码 / 排查副作用**：进 `artifacts/{artifact}/trace-{area}.md`
- **关键词 / 症状检索**：进 `02-indexes/` 找对应倒排索引
- **模块代码归属**：进 `03-code/module-{module}.md`

## Directory Truth

```
.agent-memory/
├── 00-index.md
├── 01-business/
│   ├── index.md
│   ├── context.md                        # 项目背景、边界、核心术语
│   ├── artifact-map.md                   # 业务产物全景图与关系
│   ├── artifacts/
│   │   ├── index.md
│   │   ├── artifact-{artifact}.md        # 业务产物主文档（why/who/what）
│   │   └── {artifact}/
│   │       ├── lifecycle.md              # 生命周期阶段 + 数据流
│   │       └── trace-{area}.md          # 代码执行 trace（调用链/副作用/边界）
│   └── journeys/
│       ├── index.md
│       └── journey-{scenario}.md        # 跨产物端到端流程
├── 02-indexes/
│   ├── index.md
│   ├── keyword-index.md                 # 业务词/产物名/角色 → artifact/journey
│   ├── symbol-index.md                  # 类/方法/API/表 → artifact/trace
│   ├── symptom-index.md                 # 故障现象/错误 → artifact/trace
│   └── stage-index.md                   # 状态/阶段名 → artifact/lifecycle
└── 03-code/
    ├── index.md
    ├── module-{module}.md               # 模块归属哪些 artifacts / traces
    └── integration-map.md               # 外部系统 / SDK 集成一览
```

## Read Mode

### Scenario A: 代码任务（默认）

1. 读 `00-index.md` → 决定进 `01-business`、`02-indexes` 还是 `03-code`
2. 多数编码任务先进 `01-business/artifacts/artifact-{artifact}.md`
3. 找不到目标 artifact → 先查 `02-indexes/keyword-index.md` 或 `symbol-index.md`
4. `artifact-{artifact}.md` 满足大多数理解任务，够用就停
5. 需要生命周期细节 / 数据流 → 续读 `{artifact}/lifecycle.md`
6. 需要改代码 / 看副作用顺序 → 续读 `{artifact}/trace-{area}.md`

### Scenario B: Onboarding

1. `00-index.md` → `01-business/context.md`（项目背景与核心术语）
2. `01-business/artifact-map.md`（业务产物全景）
3. `01-business/artifacts/index.md` → 选 2-3 个核心 artifact 主文档
4. 对关键 artifact 进入 `lifecycle.md`

### Scenario C: 关键词 / 症状检索

1. `00-index.md` → `02-indexes/index.md`
2. 按问题类型选索引：
   - 业务词 / 产物名 / 角色 → `keyword-index.md`
   - 类 / 方法 / 表名 → `symbol-index.md`
   - 故障现象 / 错误信息 → `symptom-index.md`
   - 状态 / 阶段名 → `stage-index.md`
3. 索引落点必须是 `artifact-*.md` 或 `trace-*.md`，不落 `03-code/module`

### Scenario D: 模块 / 代码归属查询

1. `00-index.md` → `03-code/index.md` → `module-{module}.md`
2. `module-{module}.md` 只回答"归属哪些 artifacts / traces"
3. 不在 `03-code/` 层理解业务主线

## Efficiency Rules

1. **够用就停**：`artifact-{artifact}.md` 满足时不进 `lifecycle`；`lifecycle` 满足时不进 `trace`
2. **同轮续读**：父级 index 已确认路径后，可直接续读，不必回退到根
3. **索引优先于猜测**：找不到 artifact 时先查 `02-indexes/`，不要猜文件名
4. **不猜兄弟节点**：不并行试读多个 artifact，除非父级索引明确提示

## Write Mode

### Verification Baseline

每条事实写入前必须验证：

| 维度 | 通过条件 |
|------|----------|
| 存在性 | 代码 / 配置 / 表中真实存在 |
| 完整性 | 非空实现，无明显 TODO / 占位 |
| 可用性 | 有实际调用方或配置生效 |
| 排除项 | 非废弃、非 mock、非 WIP、非注释代码 |

不确定的不写。

### Scenario E: 初始建立

1. 创建 `00-index.md`
2. 创建 `01-business/context.md`（项目背景）
3. 创建 `01-business/artifact-map.md`（业务产物全景，先列名和关系）
4. 逐个建 `artifact-{artifact}.md`，**核心产物必须同时建 `lifecycle.md`**
5. 建 `journeys/` 中跨产物流程文档（至少 1 个端到端主流程）
6. 建 `02-indexes/` 四个倒排索引文件
7. 建 `03-code/module-{module}.md` 代码归属视图
8. 每新增 artifact / journey / trace，必须同步更新受影响的 `index.md` 和 `02-indexes/`

### Scenario F: 变更后更新

1. 先验证变更已真实落代码
2. 按影响面更新：
   - 产物边界 / 目标 / 主流程变化 → `artifact-{artifact}.md`
   - 阶段 / 数据流 / 消费者变化 → `{artifact}/lifecycle.md`
   - 调用链 / 副作用 / 边界变化 → `{artifact}/trace-{area}.md`
   - 跨产物流程变化 → `journey-{scenario}.md`
   - 模块代码归属变化 → `03-code/module-{module}.md`
3. 新增 / 失效的关键词 / 症状 / 符号同步更新对应索引

## Layer Rules

| 层级 | 路径 | 必须回答 | 必须避免 |
|------|------|----------|----------|
| 根索引 | `00-index.md` | 进 business / indexes / code？ | 任何业务细节 |
| 业务索引 | `01-business/index.md` | 有哪些 artifacts / journeys？ | 展开 artifact 内容 |
| 上下文 | `01-business/context.md` | 项目背景、边界、核心术语 | 流程执行细节 |
| 产物图谱 | `01-business/artifact-map.md` | 所有业务产物与关系 | 单产物深度内容 |
| **产物主文档** | `artifacts/artifact-{artifact}.md` | why_exists、业务目标、主生命周期摘要、输入/输出、关联产物 | 代码执行细节 |
| **生命周期** | `{artifact}/lifecycle.md` | 阶段表（8 列）、数据流表（6 列）、消费者、失败降级规则 | 代码方法级细节 |
| **代码 Trace** | `{artifact}/trace-{area}.md` | 调用链、事务/异步边界、副作用顺序、危险改动点 | 重复业务目的说明 |
| 流程文档 | `journeys/journey-{scenario}.md` | 跨产物端到端流程、移交点、失败传播 | 单产物内部逻辑 |
| 索引总入口 | `02-indexes/index.md` | 有哪几个索引 + 各自找什么 | 索引内容 |
| 关键词索引 | `02-indexes/keyword-index.md` | 业务词 / 产物名 → artifact/journey | 超出映射的解释 |
| 符号索引 | `02-indexes/symbol-index.md` | 类 / 方法 / API / 表 → artifact/trace | — |
| 症状索引 | `02-indexes/symptom-index.md` | 故障现象 → artifact/trace | — |
| 阶段索引 | `02-indexes/stage-index.md` | 状态 / 阶段名 → artifact/lifecycle | — |
| 代码归属 | `03-code/module-{module}.md` | 模块归属哪些 artifacts / traces | 业务主叙事 |

## Mandatory Writing Standards

1. 每篇文档都必须带 machine-readable frontmatter
2. `artifact-{artifact}.md` 必须包含：`why_exists`、`consumers`、`failure_impact`、`data_in`、`data_out`
3. `lifecycle.md` 必须包含：阶段表（8 列）+ 数据流表（6 列）
4. `trace-{area}.md` 必须标注：事务边界、异步边界、副作用执行顺序、危险改动点
5. 倒排索引必须落到 `artifact` 或 `trace`，禁止只落到 `03-code/module`
6. 关键词索引必须覆盖：业务能力词、产物名、阶段名、角色名、数据对象名、症状词
7. 不允许只有流程步骤，没有输入 / 输出 / 消费者
8. 不允许只列方法名，不解释业务目的
9. 不允许漏掉"失败时影响什么、不影响什么"
10. 同一事实只放在最合适的层，避免跨层重复

详细 frontmatter schema、模板映射、好 / 坏示例见 [reference.md](reference.md)。
