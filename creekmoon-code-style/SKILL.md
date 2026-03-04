---
name: creekmoon-code-style
description: 江岳的代码风格规范（方法设计、入参风格、流程组织、命名与副作用边界）。编写或修改代码时自动遵循，审查代码时按清单检查。适用于所有编程语言。Use when writing code, modifying code, reviewing code, checking code style, refactoring, scanning compliance, or doing code review.
---

# Creekmoon Code Style

适用于所有编程语言和项目。规范方法设计与抽取粒度、Service 层公共方法入参风格、方法内部流程组织（主流程优先）、命名与副作用边界（Name == Behavior）。

## 核心规则

### R1. 保持方法内聚

将逻辑收束在方法本身，通过"顺序组织 + 清晰命名 + 早返回"控制复杂度。不要为了"看起来更优雅"而引入多层跳转。

### R2. 禁止过度抽取

不抽取仅有一个调用点的 private 方法。抽取的前提是"降低理解成本"而非"减少行数"。如果抽取导致上下文丢失、频繁跳转、增加阅读负担，应回退内联。

### R3. Name == Behavior

方法名应当完整覆盖实现行为。当方法内部存在**业务上独立的复合操作**时，强烈建议在方法名中体现。

- 前置检查并可能静默 return 时，必须在方法名中体现（如 `IfExists`）
- 宁可名字长，也不要契约模糊

**需要体现在方法名中的（业务独立的复合操作）：**
- 发送通知、级联删除关联数据、写入其他业务表、发消息等——这些是独立的业务场景，与核心操作并非天然绑定
- 正面: `createUserAndSendNotice`、`deleteUserAndNoticeIfExists`、`deleteOrgAndCascadeUsers`

**不需要体现在方法名中的（内生耦合的附带行为）：**
- 修改密码时更新 updateTime、写库时自动填充审计字段、保存实体时维护版本号等——这些是操作的自然伴随结果，与核心操作强耦合且业务上必然发生
- 判断标准: 如果省略该附带行为会让人困惑或违反预期，说明它是内生耦合的，不需要写进方法名

- 反面信号: 方法名叫 `deleteUser` 但内部还发了通知（通知是独立业务行为）；方法名叫 `deleteOrg` 但内部级联删除了用户（级联删除是独立的关联操作）

### R4. Service 公共方法入参优先基本类型

public 方法入参优先使用基本类型（String、Long、int 等）或简单值对象，避免聚合对象包裹。

- 优先传主键 id，方法内部自行查库获取对象
- 若除 id 外还需少量额外值，显式列出基本类型参数
- 参数数量多且强关联时，才考虑简单对象（仅承载 2-5 个强关联基本字段）
- 例外：private 方法允许 DTO/BO；直接为 Controller 层服务的方法允许 DTO/BO
- 正面: `bindTrackingNo(Long orderId, String trackingNo)`
- 反面信号: `bindTrackingNo(Order order, String trackingNo)` — 迫使调用方先查库拼装对象

### R5. Happy Path First

每个方法将主流程作为主线。先处理异常/空值（early return 或 throw），再执行主流程。

- 禁止将主流程逻辑写在 if 分支内部
- 不要为了 if 分支先做空声明（如 `String x = null;`），应先按正向预期取值，再判断
- 若某值的正向预期是"直接取到并继续使用"，先取值再校验
- 正面: `if (bad) return;` 然后主流程平铺
- 反面信号: `if (data != null) { if (status != null) { /* 主逻辑全在这里 */ } }`

### R6. 可选后续逻辑：回调组合 vs 显式命名

禁止将可选的非核心后续逻辑硬编码在方法内部。两种策略选其一：

**策略一（回调组合）** — 后续操作是临时的、场景特定的：
- 方法名保持核心动词（`saveUser`），通过 `Consumer<T> afterXxx` 回调参数交给调用方
- 调用方按需组合: `saveUser(userBO, userId -> noticeService.sendWelcomeMsg(userId));`

**策略二（显式命名）** — 后续操作是固定业务规则，每次必须执行：
- 把行为写进方法名: `saveUserAndNotice`
- 禁止出现可跳过的副作用（如 `saveUserAndNotice` 内用 boolean 控制是否通知）

命名约定：
- 回调参数: `afterXxx` 或 `onXxx`
- 复合操作: 用 `And` 连接（`saveUserAndNotice`）
- 时序: `AndThen` / `Then`（`validateAndThenSave`）

强烈建议避免: 当后续操作是业务上独立的行为（如发通知）而非内生耦合行为（如更新时间戳）时，方法名叫 `saveUser` 却内部偷偷发通知

### R7. 纯 CPU 转换用 Stream

不涉及 I/O 的纯转换（过滤、映射、排序、取最值、格式化），允许合并为流式转换以减少一次性中间变量。

- 必须在流式转换前**顶部写清楚步骤注释**
- 链路过长时保留 1-2 个具名中间变量
- I/O 操作必须拆出，不混进 stream
- 适用前提: 不触发 HTTP/RPC/DB/MQ/文件/缓存等外部操作

### R8. tryXxx 前缀约定

`try` 前缀意味着调用方"不关心是否成功"。

- 不得向外抛出任何异常（包括运行时异常）
- 返回类型仅允许 `void` 或 `boolean`
- 内部捕获异常，日志级别用 `debug`，日志文案包含"可能是正常情况无须理会"
- 不得打断外部调用方的事务
- 必须保证逻辑完备：即使失败也能在内部兜住

```java
public boolean trySendWelcomeNotice(Long userId) {
    try {
        noticeService.sendWelcomeMsg(userId);
        return true;
    } catch (Exception e) {
        log.debug("发送欢迎通知失败(可能是正常情况无须理会), userId={}", userId, e);
        return false;
    }
}
```

### R9. 方法体 0-4 分区组织（最高频规则）

方法体按可读性分区组织，使读者一眼看出先校验什么、再准备什么、默认值如何补齐、最后执行什么业务。

**分区顺序：**

- **区域 0 — fast-fail 校验**: 入参/上下文的第一时间校验，不通过就 throw/return
- **区域 1 — 参数声明**: 声明后续使用的变量，做初次赋值（从入参/上下文/查询结果中取值）
- **区域 2 — 默认值兜底**: 对可为空的参数补默认值或做优先级合并
- **区域 3 — 二次 fast-fail**: 依赖关系校验（对象是否存在、状态是否合法、跨字段约束）
- **区域 4 — 执行业务**: 只做业务动作，不再混入大量防御性编程

区域 2 和 3 允许混合存在。核心对象的 null 校验可在声明阶段紧跟 fast-fail（避免无意义的后续声明）。

**注释规范：**

- 每个分区顶部必须有有意义的块注释，说明"做了什么"
- 单行注释用 `/* xxx */`，多行用 `/* ... */`
- **禁用** `//` 做阶段标题
- 禁止无价值占位注释（如 `// 1. 参数声明区域`）
- 注释精准简洁: 正例 `/* 查 order 表拿对象 */`；反例 `/* 建立依赖关系：先把后续要用到的对象查出来... */`
- 同一分区默认只写一条阶段注释，内部禁止与代码行为重复的注释
- 仅在"业务规则不直观/有坑/反直觉"时允许极少量局部注释，且必须解释"为什么"

**空行规则：**

- 空行**仅用于分区切割**
- 同分区内部操作连续排列，不用空行分隔步骤
- 块注释与本阶段第一行代码之间不插空行
- 空分区直接省略

**入参变量复用：**

- 允许直接对入参变量重新赋值（补默认值/归一化），不额外声明同含义变量
- 例外：语义发生转换时可声明新变量（如 `rawCode` vs `normalizedCode`）

**方法体模板：**

```java
public void bindTrackingNo(Long orderId, String trackingNo, String platformName) {
    /* 入参 fast-fail */
    if (orderId == null) {
        throw new BizException("订单ID不能为空");
    }
    if (StrUtil.isBlank(trackingNo)) {
        throw new BizException("追踪号不能为空");
    }

    /* 查核心对象（后续变量强依赖它们） */
    TOrder order = orderService.getById(orderId);
    if (order == null) {
        throw new BizException("找不到订单");
    }
    TLogistics logistics = logisticsMapper.selectByOrderId(orderId);
    if (logistics == null) {
        throw new BizException("找不到物流单");
    }
    String physicalCarrierCode = order.getPhysicalCarrierCode();

    /* 默认值兜底 */
    if (physicalCarrierCode == null) {
        physicalCarrierCode = logistics.getPhysicalCarrierCode();
    }
    if (StrUtil.isBlank(platformName)) {
        platformName = resolveTrackingPlatformName(order.getRefCarrierId(), order.getId());
    }

    /* 执行业务 */
    log.info("绑定追踪号, orderId={}, trackingNo={}", orderId, trackingNo);
    tryBindTrackingNumberToPlatform(orderId, trackingNo, platformName, physicalCarrierCode);
}
```

### R10. 避免过度防御性编程包装

防御性编程应服务于"边界清晰 + 主流程顺畅"，不要把多个防御动作堆进一行参数表达式。

- 禁止在一个参数表达式里同时做空判断 + 取值 + 归一化/兜底
- 强依赖: 在入口 fast-fail，后续主流程不夹杂防御分支
- 弱依赖: 下沉到被调用方集中承接，调用点只透传值
- 反面信号: `.addUserMessage(StrUtil.nullToEmpty(requestBO != null ? requestBO.getText() : null))`

### R11. 禁止为微小性能牺牲可读性

可读性优先于微优化。

- 禁止手写字节魔数做逻辑判断（即使提取为具名常量也不行）
- 有成熟工具库能完成的工作（如 Apache Tika 检测文件类型），必须优先使用
- 无可观测性能瓶颈支撑的"优化"，视为过早优化

---

## 场景 A：编写代码（核心场景，默认激活）

为用户编写或修改代码时，自动遵循全部 11 条规则，无需用户提示。

**执行要项：**

1. 方法体严格按 R9 的 0-4 分区模板组织
2. 每个分区顶部使用块注释 `/* xxx */`，内容精准简洁
3. 空行仅出现在分区之间，同分区内操作连续排列
4. 方法名按 R3 完整描述行为，副作用和条件必须体现
5. Service public 方法入参按 R4 优先基本类型
6. 主流程按 R5 Happy Path First 组织
7. 入参变量可直接复用赋默认值，不额外声明同义变量
8. tryXxx 方法按 R8 约定实现
9. 可选后续逻辑按 R6 选择回调或改名策略
10. 纯 CPU 转换按 R7 使用 Stream 并顶部写步骤注释

## 场景 B：代码审查（按需触发）

触发词：审查、review、检查代码风格、检查 diff、扫描合规、code review

**工作流：**

1. 确定审查范围（用户指定的方法/文件/git diff/目录）
2. 读取 [checklist.md](checklist.md) 获取完整检查项
3. 逐项检查，需要判断规则边界时读取 [rules-detail.md](rules-detail.md)
4. 对每条建议确定依据类型（见下），输出带依据类型的违规报告

**依据类型（四选一，必填）：**

- **Style Rule**：明确对应 R1–R11 中的某条规则，**必须写规则号**
- **Project Convention**：项目内部约定/历史一致性，**必须写约定来源**（如"同文件既有常量风格"）
- **Correctness**：正确性/Bug 风险，**必须描述风险与触发条件**
- **Preference**：可读性偏好，**不得带规则号，不得强制修改**

> **规则引用门禁**：找不到明确规则禁止写规则号。宁可标 Preference，也不要误标 R。

**规则引用三段式（依据类型为 Style Rule 时强制）：**

当依据类型为 Style Rule 时，`依据` 字段必须包含三段：① 规则号 ② 规则关键句摘录（原文 1 句）③ 落点说明（代码哪里违背/哪里符合）。三段缺一，自动降级为 Preference。

**输出格式：**

按严重程度分组输出，每项包含：

```
### [必须修复] Style Rule · R3 Name == Behavior
- 位置: `XxxService.java:42` — `deleteUser()`
- 依据: R3 关键句 "当方法内部存在业务上独立的复合操作时，强烈建议在方法名中体现" → 本处违背：deleteUser 内部含通知操作
- 建议: 重命名为 `deleteUserAndNotice()`，或将通知逻辑拆出
```

偏好类建议示例：

```
### [偏好建议] Preference · 局部变量可读性
- 位置: `PilotRequestParser.java:35`
- 依据: 可读性偏好，非 creekmoon-code-style 规则，不强制
- 建议: 将 getter 回读改为局部变量
```

严重程度：
- **必须修复**：违反核心契约（R3 命名不符、R8 tryXxx 抛异常、R6 隐藏副作用），依据类型必须为 Style Rule 或 Correctness
- **建议优化**：影响可读性和可维护性（R9 分区不清、R5 嵌套过深、R2 过度抽取），有规则可引用
- **偏好建议**：无规则覆盖，属 Convention 或 Preference，**不得带规则号**，开发者自行决定是否修改

## 场景 C：重构建议（伴随编码触发）

修改文件中的某处功能时，如果发现**同文件**其他代码存在高置信度的风格违规：

1. 先完成用户要求的修改
2. 在回复末尾以"顺便提一下"的方式列出发现的违规点
3. 仅提示，不自动修改；只报告当前文件内的违规

---

## 详细参考

- 完整规则与代码示例: [rules-detail.md](rules-detail.md)
- 审查检查清单: [checklist.md](checklist.md)
