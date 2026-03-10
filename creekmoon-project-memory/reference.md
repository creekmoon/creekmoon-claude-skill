# LLM Memory Skill V4 Reference

面向 LLM 的业务产物优先型记忆文档规范。目标是让模型可以先理解业务，再看代码；先命中正确文档，再深入细节。

---

## 1. Single Entry Rule

唯一合法首跳：`.agent-memory/00-index.md`

合法导航路径：

```
00-index.md
  ↓
01-business/index.md          # 理解业务
  ↓
01-business/artifacts/index.md
  ↓
artifacts/artifact-{artifact}.md      # 够用就停
  ↓
artifacts/{artifact}/lifecycle.md     # 需要生命周期细节时
  ↓
artifacts/{artifact}/trace-{area}.md  # 需要改代码时

或

02-indexes/index.md           # 检索入口
  ↓
keyword-index / symbol-index / symptom-index / stage-index
  ↓
artifact-*.md 或 trace-*.md

或

03-code/index.md              # 代码归属查询
  ↓
module-{module}.md
```

禁止：
- 直接把 `artifact-*.md` 当首跳
- 直接把 `lifecycle.md` 当首跳
- 直接把任意索引文件当首跳
- 在 `03-code/` 层理解业务主线

---

## 2. Frontmatter Schema

### 2.1 通用必填字段

所有文档都必须包含：

```yaml
layer: root|business|artifact|lifecycle|trace|journey|indexes|code
doc_type: index|context|artifact-map|artifact|lifecycle|trace|journey|keyword-index|symbol-index|symptom-index|stage-index|module|integration-map
coverage: stub|partial|complete
last_verified: YYYY-MM-DD
confidence: low|medium|high
```

### 2.2 artifact-{artifact}.md 必填

```yaml
---
layer: artifact
doc_type: artifact
artifact: {artifact-id}          # 机器可读 ID，如 analysis-report
business_name: {业务名称}         # 人类可读名，如 询价分析报告
aliases:
  - {别名1}
  - {别名2}
why_exists: {一句话：这个产物为什么存在}
business_goal: {业务目标：它解决了谁的什么问题}
producers:
  - {创建者1}                     # 角色/系统/事件
consumers:
  - {消费者1}                     # 角色/系统/下游流程
data_in:
  - {主要输入：来源 + 格式}
data_out:
  - {主要输出：存在哪里 + 格式}
failure_impact: {失败时影响什么}
no_failure_impact: {失败时不影响什么（降级声明）}
related_artifacts:
  - {相关产物 ID}
related_journeys:
  - {相关流程 ID}
coverage: stub|partial|complete
last_verified: YYYY-MM-DD
confidence: low|medium|high
---
```

### 2.3 lifecycle.md 必填

```yaml
---
layer: lifecycle
doc_type: lifecycle
artifact: {artifact-id}
related:
  - ../artifact-{artifact}.md
coverage: stub|partial|complete
last_verified: YYYY-MM-DD
confidence: low|medium|high
---
```

### 2.4 trace-{area}.md 必填

```yaml
---
layer: trace
doc_type: trace
artifact: {artifact-id}
area: {trace-area}              # 如 generation、approval、cancellation
symbols:
  - {CoreService.method()}
transaction_boundary: {说明事务边界，如 deductOrder 在同一事务内}
async_boundary: {说明异步边界，如 asyncPersist 在主链路之外}
related:
  - ../lifecycle.md
  - ../artifact-{artifact}.md
coverage: stub|partial|complete
last_verified: YYYY-MM-DD
confidence: low|medium|high
---
```

### 2.5 journey-{scenario}.md 必填

```yaml
---
layer: journey
doc_type: journey
scenario: {scenario-id}
business_name: {业务场景名称}
aliases:
  - {别名}
artifacts_involved:
  - {artifact-id-1}
  - {artifact-id-2}
related:
  - ../artifacts/index.md
coverage: stub|partial|complete
last_verified: YYYY-MM-DD
confidence: low|medium|high
---
```

---

## 3. Artifact Document Standards

### 3.1 artifact-{artifact}.md 必须回答的 10 个问题

每篇产物主文档，必须完整回答以下问题。这不是建议，是强制要求：

| 问题 | 对应字段 / 章节 |
|------|-----------------|
| 这个产物是什么？ | 文档标题 + `why_exists` |
| 为什么存在？解决谁的什么问题？ | `why_exists` + `business_goal` |
| 谁创建它？ | `producers` + 正文 |
| 谁消费它？ | `consumers` + 正文 |
| 主生命周期有哪几个阶段？ | 正文 Main Lifecycle 章节 |
| 输入是什么？ | `data_in` + 正文 |
| 输出是什么？存在哪里？ | `data_out` + 正文 |
| 失败时会影响什么？ | `failure_impact` |
| 失败时不影响什么？ | `no_failure_impact` |
| 相关代码和文档在哪？ | Evidence Anchors + related |

### 3.2 lifecycle.md 阶段表（8 列）

每个生命周期阶段必须包含 8 列：

| Stage | Trigger | Actor | Input | Processing Rule | Output | Persist/Cache/Write | Next Consumer |
|-------|---------|-------|-------|-----------------|--------|---------------------|---------------|

- **Stage**：阶段名，与 `stage-index.md` 中的状态对齐
- **Trigger**：什么事件触发这个阶段
- **Actor**：哪个系统/服务/角色执行
- **Input**：输入数据，必须包括来源
- **Processing Rule**：核心处理规则，不是代码细节
- **Output**：产出物
- **Persist/Cache/Write**：持久化/缓存/外部写入的具体位置
- **Next Consumer**：下一个消费这个阶段产出的角色/系统

### 3.3 lifecycle.md 数据流表（6 列）

每个主要数据对象必须有一行：

| Source | Transformation | Stored In | Exposed Via | Consumed By | Failure Impact |
|--------|----------------|-----------|-------------|-------------|----------------|

- **Source**：数据从哪里来
- **Transformation**：经过什么处理
- **Stored In**：存在哪里（DB / Redis / OSS / 内存 / 返回值）
- **Exposed Via**：通过什么方式暴露（API / 文件 / 消息 / 下载链接）
- **Consumed By**：最终消费者
- **Failure Impact**：这条数据链断了会怎样

### 3.4 lifecycle.md 必须声明的 Invariants

每个 `lifecycle.md` 必须包含以下章节：

```markdown
## Key Invariants

- {不变量1}：{不满足时的影响}
- {不变量2}：{为什么必须保持}

## Failure Degradation

| Failure Scenario | Degradation Rule | Affected Artifacts |
|------------------|------------------|--------------------|
| {失败场景} | {降级规则} | {影响范围} |
```

---

## 4. Index Organization Rules

### 4.1 keyword-index.md 必须覆盖的 Key 类型

| Key 类型 | 示例 |
|----------|------|
| 业务能力词 | 询价、审批、退款、轨迹同步、报告生成 |
| 业务产物名 | 分析报告、询价请求、账单、余额流水 |
| 生命周期阶段词 | 创建、处理中、完成、失败、取消、归档、补扣 |
| 角色词 | 运营、财务、承运商、审批公司、调度任务 |
| 数据对象名 | quoteRequestNo、trackingNo、OSS 文件 |
| 目标/意图词 | 诊断、追踪、审计、对账、降本、排错 |

格式：

```markdown
| Key | Kind | Target Doc | Notes |
|-----|------|------------|-------|
| 询价 | 业务能力 | [artifact-quote-request](../01-business/artifacts/artifact-quote-request.md) | |
| 分析报告 | 产物名 | [artifact-analysis-report](../01-business/artifacts/artifact-analysis-report.md) | 也叫诊断报告 |
```

### 4.2 symbol-index.md 格式

```markdown
| Symbol | Kind | Artifact Doc | Trace Doc |
|--------|------|--------------|-----------|
| `QuoteService.quote()` | method | [artifact-quote-request](../01-business/artifacts/artifact-quote-request.md) | [trace-quoting](../01-business/artifacts/quote-request/trace-quoting.md) |
| `t_order` | table | [artifact-order](../01-business/artifacts/artifact-order.md) | |
```

Symbol 必须落到 `artifact-*.md`；若有对应 trace，同时落到 `trace-*.md`。

### 4.3 symptom-index.md 格式

```markdown
| Symptom | Possible Artifact | Trace Doc | Notes |
|---------|-------------------|-----------|-------|
| 询价进行中无法再次触发 | [artifact-quote-request](../01-business/artifacts/artifact-quote-request.md) | [trace-quoting](../01-business/artifacts/quote-request/trace-quoting.md) | processing 状态未收敛 |
| 报告下载链接 404 | [artifact-analysis-report](../01-business/artifacts/artifact-analysis-report.md) | [trace-generation](../01-business/artifacts/analysis-report/trace-generation.md) | OSS 文件未上传成功 |
```

### 4.4 stage-index.md 格式

```markdown
| Stage / State | Artifact | Lifecycle Doc | Meaning |
|---------------|----------|---------------|---------|
| `processing` | quote-request | [lifecycle](../01-business/artifacts/quote-request/lifecycle.md) | 询价进行中，防重入锁已设置 |
| `approved` | order | [lifecycle](../01-business/artifacts/order/lifecycle.md) | 审批链全部通过，扣款已完成 |
```

---

## 5. Growth / Split Triggers

### 5.1 何时创建 lifecycle.md

满足以下任一条件时，必须创建：

1. artifact 有超过 2 个明确的生命周期阶段
2. artifact 有非平凡的数据流（跨系统 / 跨存储）
3. artifact 有失败降级规则需要说明
4. 修改 artifact 对应代码时会因为不了解阶段顺序而出错

不需要创建的情况：
- artifact 只有"创建 → 存储 → 读取"三个阶段且无复杂规则

### 5.2 何时创建 trace-{area}.md

满足以下任一条件时，才创建：

1. lifecycle.md 已无法承载方法级调用顺序，且这个顺序会影响编码正确性
2. 存在非直觉的事务边界或异步边界，缺少说明会导致 bug
3. 改代码时需要反复查阅同一组内部方法的副作用顺序

不需要创建的情况：
- 只是想让 lifecycle.md 显得更完整
- 只是复制代码片段
- 该 trace 极少被编码任务使用

### 5.3 何时创建 journey-{scenario}.md

满足以下任一条件时，创建：

1. 一条完整业务流程跨越 2 个及以上 artifact
2. 跨 artifact 的移交点或数据流需要被显式说明
3. 端到端的失败传播规则不容易从单个 artifact 推导

### 5.4 artifact 拆分时机

一个 artifact 文档满足以下任一条件时，拆分为多个：

1. 业务目标对应不同的产物（如"询价请求"和"询价结果"是两个不同产物）
2. 消费者完全不同，且生命周期没有重叠
3. 失败影响范围完全独立

---

## 6. Good vs Bad

### Bad：只有方法名，没有业务目的

```markdown
## 2. Main Steps

1. `QuoteService.quote()` 执行
2. `AsyncQuoteSupport.tryMarkProcessing()` 调用
3. `QuoteService.completeTracking()` 完成
```

### Good：讲清楚为什么存在、谁消费

```markdown
## Why Exists

询价分析报告是询价主链路的**诊断增强物**，不是主业务结果。
它的存在目标是：让运营、客服、研发可以解释"这次为什么是这个报价结果"，
降低询价黑盒排查成本。

## Producers

- 系统自动生成：询价完成后异步汇总执行轨迹 + 命中规则 + API 调用结果 + 异常记录

## Consumers

- 运营：排查异常报价
- 客服：向客户解释报价依据
- 研发：调试引擎规则命中情况
```

### Bad：lifecycle 只有流程，没有数据流和消费者

```markdown
| 1 | 询价完成 | 触发报告生成 |
| 2 | 渲染 markdown | 生成文本 |
| 3 | 上传 OSS | 文件存储 |
```

### Good：lifecycle 8 列阶段表 + 6 列数据流表

```markdown
| Stage | Trigger | Actor | Input | Processing Rule | Output | Persist | Next Consumer |
|-------|---------|-------|-------|-----------------|--------|---------|---------------|
| 汇总执行轨迹 | 询价 completeTracking 回调 | `QuoteService.asyncPersistQuoteTracker()` | quoteTracker 对象（引擎结果+API结果+异常记录+请求上下文） | 按承运商维度合并，区分引擎命中与 API 调用结果 | 结构化 markdown 文本 | 暂存内存 | 渲染阶段 |
| 上传 OSS | 渲染完成 | `OssService.upload()` | markdown 文本 + 文件名（含 quoteRequestNo） | 文件名规则：`quote-report/{quoteRequestNo}.md` | OSS 文件 Key | OSS + DB 文件记录 | 运营/客服（下载查看） |

| Source | Transformation | Stored In | Exposed Via | Consumed By | Failure Impact |
|--------|----------------|-----------|-------------|-------------|----------------|
| quoteTracker（引擎+API 执行轨迹） | 格式化为 markdown | OSS | `GET /quote/downloadDiagnosticReport` | 运营/客服/研发 | 报告缺失，但主询价结果不受影响 |
```

### Bad：trace 只列调用链，没有说危险点

```markdown
调用顺序：quote() → markProcessing() → quoteByEngine() → quoteByApi() → completeTracking()
```

### Good：trace 标注事务/异步边界 + 危险改动点

```markdown
## Transaction / Async Boundary

- `tryMarkProcessing()` 写 Redis，**不在事务内**，是独立的幂等锁
- `quoteByEngine()` 和 `quoteByApi()` 并发执行，`asyncPersist` 在 CompletableFuture 之外
- `asyncPersistQuoteTracker()` 异步，**失败不回滚主询价结果**

## Dangerous Change Points

| Point | Risk | Rule |
|-------|------|------|
| `markFinished` 调用时机 | 若从 catch 分支移除，会导致 processing 状态永远不收敛 | 正常路径和异常路径都必须到达 markFinished |
| `completeTracking` 回调注册 | 若在 API future 完成之前注册，会丢失 API 结果 | 必须在所有并发任务 allOf 之后注册 |
```

---

## 7. Template Index

| 模板文件 | 目标文件 |
|----------|----------|
| `assets/00-index-template.md` | `.agent-memory/00-index.md` |
| `assets/01-business-index-template.md` | `.agent-memory/01-business/index.md` |
| `assets/context-template.md` | `.agent-memory/01-business/context.md` |
| `assets/artifact-map-template.md` | `.agent-memory/01-business/artifact-map.md` |
| `assets/artifacts-index-template.md` | `.agent-memory/01-business/artifacts/index.md` |
| `assets/artifact-template.md` | `.agent-memory/01-business/artifacts/artifact-{artifact}.md` |
| `assets/lifecycle-template.md` | `.agent-memory/01-business/artifacts/{artifact}/lifecycle.md` |
| `assets/trace-template.md` | `.agent-memory/01-business/artifacts/{artifact}/trace-{area}.md` |
| `assets/journeys-index-template.md` | `.agent-memory/01-business/journeys/index.md` |
| `assets/journey-template.md` | `.agent-memory/01-business/journeys/journey-{scenario}.md` |
| `assets/02-indexes-index-template.md` | `.agent-memory/02-indexes/index.md` |
| `assets/keyword-index-template.md` | `.agent-memory/02-indexes/keyword-index.md` |
| `assets/symbol-index-template.md` | `.agent-memory/02-indexes/symbol-index.md` |
| `assets/symptom-index-template.md` | `.agent-memory/02-indexes/symptom-index.md` |
| `assets/stage-index-template.md` | `.agent-memory/02-indexes/stage-index.md` |
| `assets/03-code-index-template.md` | `.agent-memory/03-code/index.md` |
| `assets/module-template.md` | `.agent-memory/03-code/module-{module}.md` |
