# LightCone 业务图谱 - 详细参考

深度业务图谱型记忆系统的完整规范、模板和示例。

---

## 1. 写作流程

### Phase 1: 全代码扫描（必须）

```bash
# 1. 识别所有相关代码文件
grep -r "{keyword}" --include="*.java" src/ | grep -v test

# 2. 找出状态枚举
grep -r "enum.*Status\|STATUS_" --include="*.java" src/

# 3. 找出数据库表
grep -r "@TableName\|CREATE TABLE" --include="*.java" --include="*.sql" src/ doc/

# 4. 找出核心 Service
grep -r "class.*Service" --include="*.java" src/main/java | grep -v impl

# 5. 找出消费者（调用方）
grep -r "{serviceName}\.{method}" --include="*.java" src/
```

### Phase 2: 深度挖掘

使用以下问题清单：

```markdown
## 深度挖掘检查清单

### 跨模块耦合
- [ ] 哪些模块读取此产物的数据？
- [ ] 哪些模块监听此产物的状态变化？
- [ ] 是否存在隐式契约（如"状态=X时必有字段Y"）？
- [ ] 修改此产物会影响哪些报表/统计/下游系统？

### 状态与生命周期
- [ ] 所有可能的状态值？
- [ ] 状态转换的触发条件？
- [ ] 每个状态转换的副作用（发送消息、调用API、更新其他表）？
- [ ] 是否存在终态？终态后还能做什么？
- [ ] 状态回退是否允许？什么场景？

### 时序与依赖
- [ ] 操作的必须顺序？
- [ ] 哪些操作可以并行？
- [ ] 哪些操作必须原子？
- [ ] 违反时序会导致什么业务问题？

### 失败场景
- [ ] 每个外部依赖的失败处理？
- [ ] 部分失败如何补偿？
- [ ] 是否存在无法自动恢复的状态？
- [ ] 人工介入的触发条件和流程？

### 数据一致性
- [ ] 哪些数据可能不一致？
- [ ] 不一致的检测方式？
- [ ] 不一致的修复方式？
- [ ] 业务能否接受暂时不一致？多久？
```

---

## 2. 文档模板

### 2.1 00-index.md 模板

```markdown
---
type: index
name: root
title: 项目入口
coverage: complete
last_verified: YYYY-MM-DD
confidence: high
---

# {项目名称} 业务图谱

## 一句话描述

{项目核心业务}

## 核心产物（Artifacts）

| 产物 | 业务目标 | 关键状态 | 文档位置 |
|------|----------|----------|----------|
| {artifact-1} | {解决什么问题} | {INIT → PROCESSING → DONE} | [business/artifacts/{artifact-1}.md](business/artifacts/{artifact-1}.md) |
| {artifact-2} | {解决什么问题} | {CREATED → PAID → SHIPPED} | [business/artifacts/{artifact-2}.md](business/artifacts/{artifact-2}.md) |

## 核心流程（Flows）

| 流程 | 涉及产物 | 业务场景 | 文档位置 |
|------|----------|----------|----------|
| {flow-1} | {artifact-1} → {artifact-2} | {端到端场景} | [business/flows/{flow-1}.md](business/flows/{flow-1}.md) |

## 快速导航

- **业务背景**：[`business/context.md`](business/context.md)
- **症状排查**：[`atlas/symptom.md`](atlas/symptom.md)
- **代码符号**：[`atlas/symbol.md`](atlas/symbol.md)
- **模块归属**：[`code/modules.md`](code/modules.md)

## 阅读指南

1. **新接手项目**：context → 核心产物 → 核心流程
2. **改代码**：定位产物 → 阅读 Deep Business Rules → 查看 Trace
3. **排查问题**：symptom索引 → 产物 Failure 章节
```

### 2.2 business/artifacts/{artifact}.md 模板

```markdown
---
type: artifact
name: {artifact-id}
title: {业务名称}
coverage: complete
last_verified: YYYY-MM-DD
confidence: high
---

# {业务名称}

## Why Exists

**一句话定义**：{这个产物是什么}

**业务目标**：{解决谁的什么问题}

**失败影响**：{失败时影响什么业务}

**无影响范围**：{失败时不影响什么，可降级}

## Lifecycle

### Stages（阶段矩阵）

| Stage | Trigger | Actor | Input | Processing | Output | Persist | Next Consumer |
|-------|---------|-------|-------|------------|--------|---------|---------------|
| {stage-1} | {trigger} | {actor} | {input} | {processing} | {output} | {persist} | {consumer} |
| {stage-2} | {trigger} | {actor} | {input} | {processing} | {output} | {persist} | {consumer} |

### Data Flow（数据流矩阵）

| Data | Source | Transform | Stored | Exposed Via | Consumed By | Failure Impact |
|------|--------|-----------|--------|-------------|-------------|----------------|
| {data-1} | {source} | {transform} | {stored} | {exposed} | {consumer} | {impact} |

### State Machine（状态机）

```mermaid
stateDiagram-v2
    [*] --> CREATED: 初始化
    CREATED --> PROCESSING: 提交处理
    PROCESSING --> COMPLETED: 成功
    PROCESSING --> FAILED: 异常
    FAILED --> RETRYING: 重试
    RETRYING --> COMPLETED: 成功
    RETRYING --> FAILED: 最终失败
```

**状态说明**：

| State | Meaning | Allowed Transitions | Business Rule |
|-------|---------|---------------------|---------------|
| {state} | {含义} | {可转换到} | {约束} |

## Deep Business Rules ★

### Cross-Module Constraints（跨模块约束）

```
约束1: {模块A} 依赖 {模块B} 的 {条件}
- 场景: {什么情况下}
- 风险: {违反时发生什么}
- 代码位置: {file:line}
```

### Implicit Dependencies（隐式依赖）

```
依赖1: {字段} 实际由 {X} 维护，{Y} 直接读取
- 假设: {Y} 假设 {条件}
- 违反场景: {什么情况}
- 后果: {会发生什么}
```

### Business Invariants（业务不变量）

| Invariant | Enforced By | Violation Scenario | Impact | Detection |
|-----------|-------------|-------------------|--------|-----------|
| {规则} | {谁保证} | {什么情况下} | {后果} | {如何发现} |

### Temporal Rules（时序规则）

| Order | Operation A | Operation B | Violation Impact | Enforced By |
|-------|-------------|-------------|------------------|-------------|
| MUST  | {操作A} | {操作B} | {后果} | {机制} |
| MUST_NOT | {操作A} | {操作B} | {后果} | {机制} |

## Trace（代码追踪）

### Core Call Chain

```
{EntryPoint}
  → {Method1}() [{事务边界}]
    → {Method2}() [副作用: {说明}]
    → {Method3}() [异步: {说明}]
  → [{事务提交/结束}]
  → {AsyncHandler}()
```

### Transaction & Async Boundaries

| Method | Type | Notes |
|--------|------|-------|
| `{method}()` | Transactional | 回滚范围: {说明} |
| `{method}()` | Async | 线程池: {pool}, 超时: {time} |
| `{method}()` | External API | 超时: {time}, 重试: {yes/no} |

### Side Effects（副作用顺序）

| Order | Effect | Trigger | Compensate On Failure |
|-------|--------|---------|----------------------|
| 1 | {副作用} | {触发点} | {补偿方式} |

### Dangerous Change Points

| Location | Current Logic | Risk If Changed | Validation Rule |
|----------|---------------|-----------------|-----------------|
| `{file}:{line}` | {当前逻辑} | {改动风险} | {必须遵守的规则} |

## Failure & Degradation

| Scenario | Behavior | Business Impact | Recovery | Related Code |
|----------|----------|-----------------|----------|--------------|
| {场景} | {表现} | {影响} | {恢复} | {代码位置} |

## Evidence Anchors

### Core Classes
- `{ClassName}`: `{package}/{ClassName}.java`

### Enums
- `{StatusEnum}`: `{package}/{StatusEnum}.java`

### DB Tables
- `{table}`: `{ddl-file}.sql`

### Key Methods
- `{method}()`: `{ClassName}.java:{line}`

## Related

- **Flows**: [{flow}](business/flows/{flow}.md)
- **Related Artifacts**: [{artifact}](business/artifacts/{artifact}.md)
```

### 2.3 business/flows/{flow}.md 模板

```markdown
---
type: flow
name: {flow-id}
title: {流程名称}
coverage: complete
last_verified: YYYY-MM-DD
confidence: high
---

# {流程名称}

## Overview

**业务场景**：{描述}

**参与产物**：{artifact-1} → {artifact-2} → {artifact-3}

**触发条件**：{什么情况下触发}

**成功标准**：{怎么算完成}

## Flow Diagram

```mermaid
sequenceDiagram
    participant A as {Actor-1}
    participant X as {Artifact-1}
    participant B as {Actor-2}
    participant Y as {Artifact-2}

    A->>X: {操作}
    X->>X: {内部处理}
    X->>B: {通知}
    B->>Y: {操作}
```

## Stage Details

### Stage 1: {阶段名}

| 属性 | 值 |
|------|-----|
| 触发 | {trigger} |
| 执行者 | {actor} |
| 输入 | {input} |
| 输出 | {output} |
| 移交点 | {handoff to next stage} |

## Data Flow

| Data | From | To | Transform | Failure Impact |
|------|------|-----|-----------|----------------|
| {data} | {from} | {to} | {transform} | {impact} |

## Failure Propagation

| Failure At | Impact On | Propagation | Compensation |
|------------|-----------|-------------|--------------|
| {stage} | {impact} | {如何传播} | {补偿} |

## Related Artifacts

- [{artifact-1}](business/artifacts/{artifact-1}.md)
- [{artifact-2}](business/artifacts/{artifact-2}.md)
```

### 2.4 business/context.md 模板

```markdown
---
type: context
name: context
title: 项目背景
coverage: complete
last_verified: YYYY-MM-DD
confidence: high
---

# 项目背景

## Business Domain

**行业**：{行业}

**核心业务**：{一句话}

**目标用户**：{用户}

## Scope Boundary

### In Scope
- {范围内}

### Out of Scope
- {范围外}

## Core Terminology

| 术语 | 英文 | 含义 | 示例 |
|------|------|------|------|
| {术语} | {english} | {含义} | {示例} |

## Architecture Overview

```
[External] → [Controller] → [Service] → [Mapper] → [DB]
                ↓
            [External API]
```

## Tech Stack

- {技术}: {版本}

## Related Systems

| System | Relation | Protocol | Purpose |
|--------|----------|----------|---------|
| {系统} | {关系} | {协议} | {目的} |
```

### 2.5 atlas/keyword.md 模板

```markdown
---
type: index
name: keyword
title: 关键词索引
coverage: complete
last_verified: YYYY-MM-DD
confidence: high
---

# 关键词索引

| Key | Kind | Target | Notes |
|-----|------|--------|-------|
| {关键词} | 业务词 | [business/artifacts/{X}.md](business/artifacts/{X}.md) | {说明} |
| {关键词} | 产物名 | [business/artifacts/{X}.md](business/artifacts/{X}.md) | {说明} |
| {关键词} | 状态 | [business/artifacts/{X}.md](business/artifacts/{X}.md) #{章节} | {说明} |
| {关键词} | 角色 | [business/artifacts/{X}.md](business/artifacts/{X}.md) | {说明} |
```

### 2.6 atlas/symbol.md 模板

```markdown
---
type: index
name: symbol
title: 代码符号索引
coverage: complete
last_verified: YYYY-MM-DD
confidence: high
---

# 代码符号索引

## Classes

| Symbol | Kind | Artifact | Location |
|--------|------|----------|----------|
| `{ClassName}` | Service | [{artifact}](business/artifacts/{artifact}.md) | `{package}/{ClassName}.java` |

## Methods

| Symbol | Artifact | Location | Purpose |
|--------|----------|----------|---------|
| `{ClassName}.{method}()` | [{artifact}](business/artifacts/{artifact}.md) | `{file}:{line}` | {用途} |

## Tables

| Symbol | Artifact | Description |
|--------|----------|-------------|
| `{table}` | [{artifact}](business/artifacts/{artifact}.md) | {描述} |
```

### 2.7 atlas/symptom.md 模板

```markdown
---
type: index
name: symptom
title: 症状索引
coverage: complete
last_verified: YYYY-MM-DD
confidence: high
---

# 症状索引

| Symptom | Possible Root Cause | Target Doc | Section |
|---------|---------------------|------------|---------|
| {错误现象} | {根因} | [business/artifacts/{X}.md](business/artifacts/{X}.md) | Failure |
| {异常信息} | {根因} | [business/artifacts/{X}.md](business/artifacts/{X}.md) | Trace |
```

### 2.8 code/modules.md 模板

```markdown
---
type: module
name: modules
title: 模块归属
coverage: complete
last_verified: YYYY-MM-DD
confidence: high
---

# 模块归属

## 按包结构

| Package | Primary Artifact | Related Flows | Notes |
|---------|------------------|---------------|-------|
| `{package}` | [{artifact}](business/artifacts/{artifact}.md) | [{flow}](business/flows/{flow}.md) | {说明} |

## 按技术层

| Layer | Classes | Purpose |
|-------|---------|---------|
| Controller | {classes} | {purpose} |
| Service | {classes} | {purpose} |
| Mapper | {classes} | {purpose} |
```

---

## 3. 好 vs 坏 示例

### Bad：信息密度低，只有表面描述

```markdown
# 订单

订单是系统的核心模块。

## 生命周期

1. 创建订单
2. 支付订单
3. 发货
4. 完成

## 相关代码

- OrderService
- OrderMapper
```

### Good：高信息密度，包含深度业务规则

```markdown
---
type: artifact
name: order
title: 物流订单
coverage: complete
last_verified: 2024-03-14
confidence: high
---

# 物流订单

## Why Exists

**一句话定义**：客户委托平台完成货物运输的契约凭证

**业务目标**：承载从下单到签收的全流程状态，连接客户、运营、财务、承运商四方

**失败影响**：订单丢失=客户无法跟踪货物+财务无法结算+客服无法响应查询

**无影响范围**：订单查询失败不影响正在执行的运输任务（承运商侧独立运行）

## Lifecycle

### Stages

| Stage | Trigger | Actor | Input | Processing | Output | Persist | Next Consumer |
|-------|---------|-------|-------|------------|--------|---------|---------------|
| CREATED | 客户下单 | OrderService | QuoteResult+Address+SKU | 校验报价有效性+库存预留 | 订单记录 | t_order.status=CREATED | 支付系统 |
| PAID | 支付回调 | PaymentService | PaymentRecord | 确认款项+推送承运商 | 扣款凭证+运单号申请 | t_order.status=PAID, t_payment | 承运商接口 |
| SHIPPED | 承运商回调 | CarrierCallback | TrackingNo+PickupTime | 更新轨迹起始信息 | 可跟踪状态 | t_order.status=SHIPPED, t_tracking | 客户通知系统 |
| DELIVERED | 签收回调 | CarrierCallback | DeliveryTime+Signee | 确认完成+生成账单 | 完成凭证 | t_order.status=DELIVERED, t_bill | 财务系统 |

### State Machine

```mermaid
stateDiagram-v2
    [*] --> CREATED: 下单
    CREATED --> PAID: 支付回调
    PAID --> SHIPPED: 承运商接单
    PAID --> CANCELLED: 超时未接单(24h)
    SHIPPED --> DELIVERED: 签收
    SHIPPED --> EXCEPTION: 异常上报
    EXCEPTION --> SHIPPED: 异常解决
    EXCEPTION --> FAILED: 无法解决
```

**关键约束**：
- PAID 后 24h 未转 SHIPPED 自动取消退款（防止承运商挂起）
- EXCEPTION 状态超过 72h 必须人工介入（自动重试已耗尽）

## Deep Business Rules ★

### Cross-Module Constraints

1. **财务结算依赖订单终态，但终态变更是异步的**
   - 场景：定时任务扫描 DELIVERED 订单生成账单
   - 风险：订单刚变 DELIVERED 时若立即查询，可能因事务未提交而漏单
   - 缓解：账单任务扫描 `update_time > {last_scan} - 5min` 的窗口

2. **客服查询直接读主库，运营报表读从库**
   - 隐式契约：客服响应速度优先，容忍5秒内数据延迟
   - 运营报表可容忍分钟级延迟

### Implicit Dependencies

1. **order.trackingNo 由承运商异步回调写入**
   - 假设：查询接口假设 trackingNo 非空（SHIPPED 后）
   - 违反场景：承运商回调延迟，客户已看到 SHIPPED 但 trackingNo 为空
   - 后果：客户端 NPE（历史事故 #2342）
   - 当前处理：查询接口做空值兜底，显示 "物流信息同步中"

### Business Invariants

| Invariant | Enforced By | Violation Scenario | Impact | Detection |
|-----------|-------------|-------------------|--------|-----------|
| `status=PAID → payment_record exists` | PaymentCallback | 回调重复触发 | 重复扣款 | 对账时发现单边账 |
| `status=SHIPPED → tracking_no != null` | CarrierCallback | 承运商返回空单号 | 无法跟踪 | 定时扫描检测 |
| `status=DELIVERED → actual_delivery_time != null` | StatusTransition | 手动改库 | 账期计算错误 | 数据校验任务 |

### Temporal Rules

| Order | Operation A | Operation B | Violation Impact | Enforced By |
|-------|-------------|-------------|------------------|-------------|
| MUST | 扣款 | 推送承运商 | 承运商已接单但款未扣，坏账 | 事务包裹 @OrderService.createShipment |
| MUST_NOT | 取消订单 | 推送承运商后 | 承运商已产生成本，取消无效 | 状态检查 @OrderService.cancel |
| MUST | 生成账单 | 结算打款 | 先打款后生成账单，无法追溯 | 账单审批流 @FinanceService |

## Trace

### Core Call Chain

```
OrderController.create()
  → OrderService.createOrder() [TX: REQUIRED]
    → OrderValidator.validateQuote() [报价有效性]
    → InventoryService.reserve() [副作用: 预留库存]
    → OrderMapper.insert() [订单入库]
  → PaymentService.charge() [TX: REQUIRES_NEW]
    → 外部支付接口 [异步: 支付结果回调]
  → CarrierService.submit() [TX: 独立]
    → 承运商API [超时: 30s, 重试: 3次]
```

### Transaction Boundaries

| Method | Boundary | Notes |
|--------|----------|-------|
| `OrderService.createOrder()` | TX 内 | 包含库存预留，失败回滚 |
| `PaymentService.charge()` | 独立 TX | 即使订单后续失败，支付记录保留用于退款 |
| `CarrierService.submit()` | TX 外 | 异步执行，失败进入重试队列 |

### Async Boundaries

| Event | Producer | Consumer | Delay | Failure |
|-------|----------|----------|-------|---------|
| payment.completed | PaymentCallback | OrderStatusUpdater | ~1s | 进死信队列，人工处理 |
| shipment.submitted | OrderService | CarrierAdapter | ~0s | 重试3次后告警 |

### Dangerous Change Points

| Location | Current Logic | Risk If Changed | Validation |
|----------|---------------|-----------------|------------|
| `OrderService.java:156` | `cancel()` 检查 `status ∈ [CREATED, PAID]` | 若允许取消 SHIPPED，承运商成本无人承担 | 必须保持状态检查 |
| `OrderMapper.xml:89` | `updateStatus` 使用乐观锁 | 若改为直接更新，并发状态覆盖 | 必须保持 version 字段 |

## Failure & Degradation

| Scenario | System Behavior | Business Impact | Recovery |
|----------|-----------------|-----------------|----------|
| 支付回调超时 | 订单保持 CREATED，15min后超时取消 | 客户需重新下单 | 自动退款，客户通知 |
| 承运商API故障 | 订单PAID但无法提交，进重试队列(5min间隔) | 发货延迟 | 自动重试，超24h人工介入 |
| 签收回调丢失 | 订单保持SHIPPED，48h后自动结单 | 实际已签收但系统未结 | 人工确认后补回调 |
| 库存预留失败 | 订单创建失败，返回错误 | 客户无法下单 | 客户重试或联系运营 |

## Evidence Anchors

- **OrderService**: `com.efficross.web.service.order.OrderService`
- **OrderStatus Enum**: `com.efficross.web.model.enums.OrderStatus`
- **DB Table**: `t_order` (DDL: `.cursor/mysql-ddl/order.sql`)
- **状态机校验**: `OrderService.java:234` `validateStatusTransition()`
```

---

## 5. 质量检查清单

在标记文档为 `coverage: complete` 前，必须检查：

### 基础完整性
- [ ] 包含 Frontmatter，所有字段已填
- [ ] 包含 Why Exists 章节
- [ ] 包含 Lifecycle 章节（Stages 表格 + Data Flow 表格）
- [ ] 包含 Trace 章节（调用链 + 事务边界）
- [ ] 包含 Failure & Degradation 章节
- [ ] 包含 Evidence Anchors（代码位置）

### 深度业务规则 ★
- [ ] 至少识别 1 个跨模块约束
- [ ] 至少识别 1 个隐式依赖
- [ ] 至少列出 2 个业务不变量
- [ ] 至少列出 2 条时序规则
- [ ] 所有规则都关联到具体代码位置

### 信息密度
- [ ] 没有纯方法名列举而无业务说明
- [ ] 没有纯状态列表而无转换规则
- [ ] 没有纯流程步骤而无输入输出
- [ ] 每个表格都有明确的业务含义
