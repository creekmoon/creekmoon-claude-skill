# LLM Memory Skill V3 Reference

面向 LLM 的目录式记忆文档规范。目标是让模型像查目录块一样，先进入唯一根索引，再逐级下钻，并在 topic 层真正拿到可用于编码的业务事实，只有必要时才进入 deep。

## 1. Single Entry Rule

唯一合法首跳：

- `.agent-memory/00-index.md`

任何查询都必须遵循：

1. `00-index.md`
2. `01-system/index.md` 或 `02-modules/index.md`
3. `mod-{module}.md` 或系统内容页
4. `topic-{topic}.md`
5. `deep-{topic}.md`（仅在 topic 已明确不足时）

禁止：

- 把 `lookup.md` 当首跳
- 把 `mod-{module}.md` 当首跳
- 把 `topic-{topic}.md` 当首跳
- 把 `deep-{topic}.md` 当首跳
- 在根层按“符号问题/场景问题/流程问题”做语义分流

### 1.1 Efficient Continuation Exception

为了效率，允许一个有限例外：

- 如果当前轮已经通过父级 index 明确定位到了某个子路径，可以直接继续读取该子路径
- 这个例外只适用于“已确认路径的续读”，不适用于“未知路径下的猜测性直达”

例子：

- 先读 `00-index.md` → `02-modules/index.md` → `mod-order.md` 后，当前轮可以直接继续读 `02-modules/order/topic-create-order.md`
- 若 `topic-create-order.md` 已明确指出“库存预扣核心判断见 `deep-create-order.md`”，则当前轮可继续读 deep
- 但不能在没有经过父级 index 的前提下，直接把 `topic-create-order.md` 或 `deep-create-order.md` 当首跳

## 2. Directory Semantics

```text
00-index.md                         -> 根目录块，只决定下一步进 system 还是 modules
01-system/index.md                 -> 系统目录块，只列系统事实文档和 lookup
01-system/lookup.md                -> 唯一反向索引，收符号、别名、场景、故障现象
02-modules/index.md                -> 模块目录块，只列模块和一句话职责
02-modules/mod-{module}.md         -> 模块主入口，列边界、入口、主题
02-modules/{module}/topic-{topic}.md -> 主题叶子，承载主题主线、关键决策、边界摘要
02-modules/{module}/deep-{topic}.md  -> topic 的谨慎子层，承载方法级核心逻辑和状态变化
```

## 3. Progressive Disclosure Rules

### 3.1 目录块和内容块必须分离

- `index.md` 只负责导航，不负责长解释
- 内容文档负责事实，不负责充当导航中心

### 3.2 信息密度必须单调增加

- 越上层，细节越少，选择越多
- 越下层，细节越多，选择越少
- `topic` 应先满足大多数编码任务，`deep` 只补 topic 无法承载的低层逻辑

### 3.3 不能跳过父级

如果最终要读 `02-modules/order/topic-create-order.md`，必须先经过：

1. `00-index.md`
2. `02-modules/index.md`
3. `02-modules/mod-order.md`

如果最终要读 `02-modules/order/deep-create-order.md`，还必须先经过：

1. `00-index.md`
2. `02-modules/index.md`
3. `02-modules/mod-order.md`
4. `02-modules/order/topic-create-order.md`

## 4. Frontmatter Schema

每篇记忆文档都必须包含以下 frontmatter：

```yaml
layer: root|system|module|topic|deep
doc_type: index|context|architecture|tech-stack|data-model|conventions|lookup|module|topic|deep
module: global|{module}
topic: {topic}
aliases:
  - {别名1}
symbols:
  - {ClassName.methodName()}
related:
  - {相对路径}
coverage: stub|partial|complete|deprecated
last_verified: YYYY-MM-DD
confidence: low|medium|high
```

字段要求：

- `aliases`: 用户可能怎么叫它
- `symbols`: 代码里怎么找到它
- `related`: 只放父级或最相关的叶子，不放一堆横跳链接
- `coverage`: 说明覆盖程度
- `confidence`: 说明验证深度

## 5. Lookup Rules

`01-system/lookup.md` 是唯一反向索引。

用途：

- 符号定位模块
- 别名定位模块
- 场景词定位模块
- 故障现象定位模块

它不是首跳，只能作为 `01-system/index.md` 的子入口。

### 5.1 Growth Rule

`lookup.md` 默认保持单文件，不因为项目变大就主动拆成多个入口文件。

原因：

- 索引天然会变大
- 单文件 lookup 比多入口 lookup 更稳定
- 真正要控制的是结构和排序，不是强行拆文件

### 5.2 Organization Rule

`lookup.md` 必须满足：

1. 按模块分段，或按稳定的键顺序组织
2. 每条记录都落到 `mod-{module}.md`
3. 有明确主题时优先落到对应 `topic-{topic}.md`
4. 只有当某个 key 主要对应方法级内部逻辑时，才额外落到 `deep-{topic}.md`
5. 不在 lookup 中写主题或 deep 细节摘要

### 5.3 Split Only When Tooling Breaks

只有当单文件 lookup 已经因为工具读取/搜索限制而明显不可用时，才允许拆分。

默认拆分方式：

- 仍保留一个 `lookup.md` 作为总入口
- 由 `lookup.md` 指向分段文件
- 分段文件只能作为 `lookup.md` 的子页，不得成为新的首跳入口

推荐格式：

```markdown
| Key | Kind | Module | Primary Doc | Topic | Deep |
|-----|------|--------|-------------|-------|------|
| `OrderService.createOrder()` | symbol | `order` | [mod-order](../02-modules/mod-order.md) | [topic-create-order](../02-modules/order/topic-create-order.md) | |
| 下单 | alias | `order` | [mod-order](../02-modules/mod-order.md) | [topic-create-order](../02-modules/order/topic-create-order.md) | |
| `StockService.reserve()` | symbol | `order` | [mod-order](../02-modules/mod-order.md) | [topic-create-order](../02-modules/order/topic-create-order.md) | [deep-create-order](../02-modules/order/deep-create-order.md) |
| 订单重复创建 | symptom | `order` | [mod-order](../02-modules/mod-order.md) | [topic-order-idempotency](../02-modules/order/topic-order-idempotency.md) | |
```

## 6. Fact Placement Rules

| 信息类型 | 正确位置 | 不该出现的位置 |
|----------|----------|----------------|
| 项目背景、边界、技术选型 | `01-system/*.md` | `topic-{topic}.md` |
| 符号/别名/场景词到模块的映射 | `01-system/lookup.md` | 根索引 |
| 模块职责、拥有入口、主题清单 | `mod-{module}.md` | 根索引 |
| 主题流程、关键分支、异常现象、边界处理 | `topic-{topic}.md` | `mod-{module}.md` |
| 方法级判断树、核心状态变化、副作用细节 | `deep-{topic}.md` | `mod-{module}.md` / `lookup.md` |

规则：

- `mod-{module}.md` 只给主题摘要，不展开主题内部逻辑
- `topic-{topic}.md` 承载“主题主线 + 为什么这样走 + 边界摘要”
- `deep-{topic}.md` 只承载 topic 不足以表达的方法级逻辑，不重复整篇 topic
- 不再把主题拆成 `flow` / `logic` / `interaction` 等多篇首跳文档

## 7. Index Size Rules

为了避免头重脚轻：

- `00-index.md` 建议控制在 80-120 行
- 同一层 index 的可选项尽量不超过 7-9 个
- 根索引只允许出现两类下一跳：`01-system/index.md` 与 `02-modules/index.md`
- `mod-{module}.md` 只列本模块的 3-8 个核心主题
- 核心模块在初次建立记忆时，至少要有 1 篇真正可用于编码的 `topic`

### 7.1 Module Growth Rules

`mod-{module}.md` 只保留：

- 模块边界
- 模块拥有入口
- 主题清单
- 少量模块级关键词

出现以下情况时，不允许继续往 `mod-{module}.md` 追加，而应改为新建或补充 topic：

1. 开始解释某个主题的完整步骤
2. 开始解释某个主题的关键条件分支
3. 开始解释某个主题的边界情况或异常现象
4. 某个新增内容只能回答“这个主题怎么走/为什么这样走”，而不是“这个模块负责什么”

### 7.2 Topic Split Triggers

`topic-{topic}.md` 必须保持单主题边界。

出现以下任一情况时，应拆成新的 `topic-*.md`，而不是继续并入旧 topic：

1. 新增内容对应不同入口方法或不同主 API
2. 新增内容回答的是另一类独立问题，而不是当前主题的自然分支
3. 新增内容形成另一组独立的异常/边界处理族
4. 读者如果只想理解原主题，却被迫同时理解另一条主题主线

判断原则：

- “同一主题的自然分支”可以并入
- “另一条可独立命名的主题主线”必须拆出

### 7.3 Deep Creation Triggers

`deep-{topic}.md` 不是常规必建文档，只在以下情况出现时创建：

1. 单个 topic 已无法在可控篇幅内说明关键方法级判断树
2. 某个主题的核心价值来自底层状态变化或副作用顺序，缺少 deep 会明显影响编码正确性
3. 调试和改代码经常需要落到同一组内部方法，而这些细节不适合塞回 topic 主线

以下情况禁止创建 deep：

1. 只是想把 topic 再写长一点
2. 只是复制实现代码或大段伪代码
3. 该细节很少被编码任务使用，读它的收益明显低于上下文成本

### 7.4 Deep Writing Rules

- `deep-{topic}.md` 必须从属于一个已存在的 `topic-{topic}.md`
- deep 只解释方法级核心逻辑、关键 guard、状态变化、副作用顺序
- deep 不再重新介绍模块边界、主题背景、无关边界情况
- topic 中要明确说明“什么时候需要进入 deep”

## 8. Evidence Anchors

每条事实都必须带证据锚点，推荐格式：

| 类型 | 示例 |
|------|------|
| 类 | `OrderService` (`src/service/OrderService.java`) |
| 方法 | `OrderService.createOrder()` |
| 路由 | `POST /api/v1/orders` |
| 配置 | `application.yml:order.max-items` |
| 表 | `t_order` |
| 消息 | `ORDER_CREATED` Topic |

不要写无锚点陈述。

## 9. Verification Rules

写入前必须验证：

| 维度 | 检查方式 | 通过条件 |
|------|----------|----------|
| 存在性 | 搜索符号 | 代码中真实存在 |
| 完整性 | 阅读关键实现 | 非空实现，无明显占位 |
| 可用性 | 搜索调用方/入口 | 有实际调用链或配置生效 |
| 排除项 | 抽查注解/开关 | 非废弃、非 mock、非注释代码 |

以下内容不进入记忆：

- 开发中的需求
- 技术方案讨论
- PR 描述
- TODO 列表
- 仅测试可见的 mock 逻辑

## 10. Good vs Bad

**Bad**

```markdown
# 订单模块

- 有下单流程
- 有异常处理
- 有一些边界判断
```

**Good**

```markdown
# order 模块

- **主入口**: `OrderService.createOrder()`
- **主题**: [topic-create-order](order/topic-create-order.md)
- **主题**: [topic-order-idempotency](order/topic-order-idempotency.md)
```

**Good Deep**

```markdown
# deep-create-order

- **目标方法**: `OrderService.createOrder()`
- **关键判断**: 是否重复下单、是否需要预占库存、事务内外哪些副作用必须分离
- **状态变化**: `NEW -> RESERVED -> CREATED`
```

## 11. Template Index

| 模板文件 | 目标文件 |
|----------|----------|
| `assets/root-index-template.md` | `.agent-memory/00-index.md` |
| `assets/system-index-template.md` | `.agent-memory/01-system/index.md` |
| `assets/system-lookup-template.md` | `.agent-memory/01-system/lookup.md` |
| `assets/system-context-template.md` | `.agent-memory/01-system/context.md` |
| `assets/system-architecture-template.md` | `.agent-memory/01-system/architecture.md` |
| `assets/system-tech-stack-template.md` | `.agent-memory/01-system/tech-stack.md` |
| `assets/system-data-model-template.md` | `.agent-memory/01-system/data-model.md` |
| `assets/system-conventions-template.md` | `.agent-memory/01-system/conventions.md` |
| `assets/modules-index-template.md` | `.agent-memory/02-modules/index.md` |
| `assets/module-template.md` | `.agent-memory/02-modules/mod-{module}.md` |
| `assets/topic-template.md` | `.agent-memory/02-modules/{module}/topic-{topic}.md` |
| `assets/deep-template.md` | `.agent-memory/02-modules/{module}/deep-{topic}.md` |
