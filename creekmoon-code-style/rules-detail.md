# Creekmoon Code Style — 完整规则与代码示例

本文件包含全部 11 条规则的详细说明与正反面代码示例，供审查和深入判断时参考。

---

## R1. 保持方法内聚（收束逻辑，降低复杂度）

将代码逻辑收束在方法本身，保持修改精准简洁，禁止引入不必要的复杂度。

- 优先通过"顺序组织 + 清晰命名 + 早返回"来控制复杂度
- 不要为了"看起来更优雅"而引入多层跳转

---

## R2. 禁止过度抽取（Avoid Over-Extraction）

不要抽取仅有一个调用点的 private 方法，此类逻辑应直接内联到原方法体中。

- 抽取的前提是"降低理解成本"，而不是"减少行数"
- 如果抽取会导致上下文丢失、频繁跳转、增加阅读负担，则应回退内联

---

## R3. Name == Behavior

方法名应当完整覆盖实现行为。当方法内部存在**业务上独立的复合操作**时，强烈建议在方法名中体现。

- 若方法做多件事且各操作是独立的业务行为，强烈建议把行为写进方法名（宁可名字长，也不要契约模糊）
- 若存在前置检查并可能静默 return，必须在方法名中显式体现（例如 `IfExists`）

**需要体现在方法名中的（业务独立的复合操作）：**
- 发送通知、级联删除关联数据、写入其他业务表、发消息等
- 这些是独立的业务场景，与核心操作并非天然绑定

**不需要体现在方法名中的（内生耦合的附带行为）：**
- 修改密码时更新 updateTime、写库时自动填充审计字段、保存实体时维护版本号等
- 判断标准: 如果省略该附带行为会让人困惑或违反预期，说明它是内生耦合的，不需要写进方法名

### 示例：内生耦合 vs 业务独立

内生耦合（不需要改方法名）：

```java
/* 修改密码时更新 updateTime 是自然伴随行为，不需要叫 changePasswordAndUpdateTime */
public void changePassword(Long userId, String newPassword) {
    User user = userRepository.getById(userId);
    user.setPassword(encrypt(newPassword));
    user.setUpdateTime(LocalDateTime.now());
    userRepository.updateById(user);
}
```

业务独立（强烈建议体现在方法名中）：

```java
/* 创建用户 + 发送欢迎通知是两个独立业务场景，强烈建议方法名体现 */
public void createUserAndSendNotice(UserBO userBO) {
    userMapper.insert(userBO);
    noticeService.sendWelcomeMsg(userBO.getId());
}
```

### 示例：存在性检查 + 删除 + 通知

正面示例（方法名完整描述行为）：

```java
public void deleteUserAndNoticeIfExists(Long userId) {
    User user = userRepository.findById(userId);
    if (user == null) {
        log.warn("用户不存在，跳过删除: {}", userId);
        return;
    }

    userRepository.delete(userId);
    log.info("用户已删除: {}", userId);

    notificationService.sendDeleteNotice(user.getEmail());
}
```

反面示例（方法名隐瞒实际行为与副作用）：

```java
public void deleteUser(Long userId) {
    User user = userRepository.findById(userId);
    if (user == null) {
        return;
    }

    userRepository.delete(userId);
    notificationService.sendDeleteNotice(user.getEmail());
}
```

### 示例 2：禁止方法名暗示单操作，实际执行级联操作

正面示例（方法名与行为严格一致）：

```java
public void deleteOrg(Long orgId) {
    orgRepository.deleteById(orgId);
}
```

反面示例（方法名掩盖级联副作用）：

```java
public void deleteOrg(Long orgId) {
    orgRepository.deleteById(orgId);

    List<Long> userIds = userRepository.findByOrgId(orgId);
    userIds.forEach(userRepository::delete);
}
```

---

## R4. Service 层公共方法入参：优先基本类型/简单对象

Service 层 public 方法入参应尽可能使用基本类型（Primitive Types）或简单对象，避免使用聚合对象包裹。

例外情况：
- Service 方法为 private，用于内部特殊处理封装：允许入参使用 DTO/BO
- Service 方法直接为前端 Controller 层提供服务：允许入参使用 DTO/BO

### 落地标准

- 默认优先使用基本数据类型（含 String、各类 Id、数值/时间等简单值对象）
- 若某个对象是业务核心承载对象且获取代价明显较高（复杂 join、跨服务调用、昂贵聚合计算），允许保留"传对象"
- 若对象获取非常容易（单表 getById），建议优化为"传主键 id"
- 若除 id 外还需少量额外值，优先显式列出基本类型参数；只有参数数量多且强关联时才考虑简单对象

### 代码示例

正面示例：

```java
public void doSomething(String name, int age, String email) {
    // 业务逻辑
}
```

反面示例：

```java
public void doSomething(UserInfoDTO userInfo) {
    // 需要拆解对象获取字段，增加不必要的依赖
}
```

"传对象"与"传主键 id"对比：

```java
/* 反面: public 方法要求调用方先准备聚合对象 */
public void bindTrackingNo(Order order, String trackingNo) {
    // order 往往意味着调用方需要先查库/装配
}

/* 正面: public 方法只要求主键，内部自行获取 */
public void bindTrackingNo(Long orderId, String trackingNo) {
    Order order = orderService.getById(orderId);
    // 业务逻辑
}
```

---

## R5. 主流程优先（Happy Path First）

每个方法应将业务主要预期（主流程）作为主线逻辑。if 分支仅用于额外校验或设置默认值，严禁将主流程逻辑写在分支内部。

### 先判断谁才是主流程

先判断"调用方默认预期会走哪条路径"，而不是先看"哪段代码是新加的"。

- **主流程**：方法的默认合同、最常规路径、大多数调用方正常情况下会走到的路径
- **次流程**：测试捷径、兼容旧逻辑、灰度开关、降级兜底、临时旁路、特殊账号白名单等

判断顺序：

1. 先看业务合同，不看实现先后
2. 先看常规调用，不看新增逻辑
3. 先看调用方心智模型，不看哪段代码更短或更好改

写法要求：

- 主流程必须平铺为主线
- 次流程只能做前置分流、早返回、局部兜底
- 禁止把主流程写成 `if (未命中特例)`、`if (!isGray)`、`if (不是测试 token)` 这类负条件分支里的"补洞逻辑"

### 常见误判：把新增特例写成视觉主线

新增的测试 token、兼容参数、灰度白名单，往往只是为少量场景开的口子。它们可以存在，但不能在代码结构上压过正式业务路径。

反面示例（把内部测试凭证写成主线，正式鉴权反而成了回退逻辑）：

```java
String credential = request.getCredential();
Long userId = INTERNAL_TEST_CREDENTIAL_USER_MAP.get(credential);

if (userId == null) {
    CredentialRecord credentialRecord = credentialRepository.findByCredential(credential);
    if (credentialRecord == null) {
        throw new BizException("凭证不存在或已失效");
    }
    if (!credentialRecord.isEnabled()) {
        throw new BizException("凭证已停用");
    }
    userId = credentialRecord.getUserId();
}

authSessionService.login(userId);
```

问题不在于"能不能工作"，而在于代码向读者表达成了：
- 先走内部测试凭证
- 没命中才回退到正式鉴权

这会把测试旁路抬成视觉主线，违背"主流程优先"。

正面示例（把特例明确收束为前置分流，正式鉴权流程保持主线表达）：

```java
String credential = request.getCredential();
Long internalUserId = INTERNAL_TEST_CREDENTIAL_USER_MAP.get(credential);
if (internalUserId != null) {
    authSessionService.login(internalUserId);
    return buildAccessTokenVO();
}

CredentialRecord credentialRecord = credentialRepository.findByCredential(credential);
if (credentialRecord == null) {
    throw new BizException("凭证不存在或已失效");
}
if (!credentialRecord.isEnabled()) {
    throw new BizException("凭证已停用");
}

authSessionService.login(credentialRecord.getUserId());
return buildAccessTokenVO();
```

这里内部测试凭证仍然可用，但它被表达成一个"明确的特殊分流"；正式鉴权流程保持平铺，读者一眼就能知道哪条才是默认业务路径。

### 代码示例

正面示例（先处理异常/空值，再执行主逻辑）：

```java
if (data == null) {
    return;
}
if (status == null) {
    status = Status.DEFAULT;
}

processBusinessLogic(data);
saveToDatabase(data);
sendNotification(data);
```

反面示例（主逻辑嵌套在 if 中）：

```java
if (data != null) {
    if (status != null) {
        processBusinessLogic(data);
        saveToDatabase(data);
        sendNotification(data);
    }
}
```

### 补充：禁止为 if 分支做空声明

当某个值的正向预期是"直接取到并继续使用"，应先按预期取值再判断，不要先做空声明。

反例（先空声明，再在分支里做主流程赋值）：

```java
String trackingNumber = null;
if (logistics != null && StringUtils.isNotBlank(logistics.getTrackingNumber())) {
    trackingNumber = logistics.getTrackingNumber().trim();
    log.info("{} 物流信息查询成功，trackingNumber={}", logPrefix, trackingNumber);
} else {
    log.warn("{} 未找到物流信息或 trackingNumber 为空", logPrefix);
}
```

推荐写法（先按正向预期取值，再做校验/兜底）：

```java
String trackingNumber = logistics.getTrackingNumber();
if (StringUtils.isNotBlank(trackingNumber)) {
    trackingNumber = trackingNumber.trim();
    log.info("{} 物流信息查询成功，trackingNumber={}", logPrefix, trackingNumber);
} else {
    log.warn("{} 未找到物流信息或 trackingNumber 为空", logPrefix);
}
```

如果 `logistics` 可能为 null 且属于异常分支，应把校验前移为 fast-fail 或兜底。

---

## R6. 可选的后续逻辑：回调组合 vs 显式命名

禁止将"可选的、非核心的后续逻辑"硬编码在方法内部。

### 策略一：回调组合（保持方法名纯粹）

方法只负责核心逻辑，后续操作通过回调参数交给调用方决定。适用于后续操作是临时的、场景特定的。

```java
public void saveUser(UserBO userBO, Consumer<Long> afterSave) {
    userMapper.insert(userBO);
    if (afterSave != null) {
        afterSave.accept(userBO.getId());
    }
}

saveUser(userBO, userId -> noticeService.sendWelcomeMsg(userId));
saveUser(userBO, null);
```

### 策略二：显式命名（方法名承担描述职责）

后续操作是固定业务规则、每次调用都必须执行时，必须把行为写进方法名。

```java
public void saveUserAndNotice(UserBO userBO) {
    userMapper.insert(userBO);
    noticeService.sendWelcomeMsg(userBO.getId());
}
```

### 禁止的做法

```java
/* 方法名叫 saveUser，内部却偷偷发通知 */
public void saveUser(UserBO userBO) {
    userMapper.insert(userBO);
    noticeService.sendWelcomeMsg(userBO.getId());
}

/* 方法名叫 saveUserAndNotice，却允许跳过通知 */
public void saveUserAndNotice(UserBO userBO, boolean needNotice) {
    userMapper.insert(userBO);
    if (needNotice) {
        noticeService.sendWelcomeMsg(userBO.getId());
    }
}
```

### 决策指南

- 选回调: 后续操作是临时的、场景特定的；希望保持方法名简洁且逻辑纯粹；调用方需要灵活组合
- 选改名: 后续操作是固定业务规则；操作具有业务重要性；团队约定某副作用必须一眼看出

### 命名约定

- 回调参数: `afterXxx` 或 `onXxx`（`afterSave`、`onCreated`）
- 复合操作: 用 `And` 连接（`saveUserAndNotice`）
- 时序: `AndThen` / `Then`（`validateAndThenSave`）
- 禁止: 可跳过的副作用命名（如 `saveUserAndMaybeNotice`）

---

## R7. 纯 CPU 业务转换：减少一次性中间变量

若逻辑不涉及对外 I/O、仅为纯 CPU 的业务转换，允许将只消费一次的中间变量合并为流式转换。

适用前提：
- 转换过程不触发外部 I/O（HTTP、RPC、DB、MQ、文件、缓存等）
- 转换过程不包含关键副作用

约束：
- 顶部写清楚步骤注释
- 链路过长时保留 1-2 个具名中间变量
- I/O 操作必须拆出

### 代码示例

```java
// 纯 CPU 转换（不涉及 I/O）：
// 1. 过滤空记录
// 2. 过滤 documentType=BOL
// 3. 提取非空 documentId
// 4. 按业务规则取最小值（最早签发版本）
Long earliestBolDocumentId = documentIds.stream()
        .filter(item -> item != null)
        .filter(item -> "BOL".equalsIgnoreCase(item.getDocumentType()))
        .map(CHRobinsonDocumentIdResponse::getDocumentId)
        .filter(documentId -> documentId != null)
        .min(Long::compareTo)
        .orElse(null);

// I/O 操作（单独处理，不混进 stream）
CHRobinsonDocumentContentResponse contentResponse = getDocumentContent(earliestBolDocumentId);
```

---

## R8. 方法名前缀约定：tryXxx

使用 `try` 前缀意味着调用方"不关心是否成功"，且该方法不会向外抛出异常。

契约约定：
- 不得向外抛出任何异常（包括运行时异常）
- 返回类型仅允许 void 或 boolean
- 必须保证逻辑完备：即使失败也能在内部兜住
- 不得打断外部调用方的事务

建议做法：
- 内部对异常进行捕获、记录必要日志，并返回 false 或直接结束
- 日志级别建议使用 debug；日志文案必须明确包含"可能是正常情况无须理会"

### 代码示例

正面示例：

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

反面示例：

```java
public boolean trySendWelcomeNotice(Long userId) {
    // 违规：try 前缀方法向外抛异常
    noticeService.sendWelcomeMsg(userId);
    return true;
}
```

---

## R9. 方法体分区组织（0-4，可读性模板）

方法体必须按可读性分区组织。

### 分区约定

- **区域 0 — fast-fail 校验**: 入参/上下文的第一时间校验，不通过就 throw/return
- **区域 1 — 参数声明**: 对后续会使用的参数/变量进行声明，做初次赋值
- **区域 2 — 默认值兜底**: 对可为空的参数补默认值或做优先级合并
- **区域 3 — 二次 fast-fail**: 依赖关系建立后立即校验（对象是否存在、状态是否合法、跨字段约束）
- **区域 4 — 执行业务**: 只做明确的业务动作，不再混入大量防御性编程

允许区域 2 与 3 混合存在。核心对象强依赖时，允许在声明阶段查到对象后立刻 fast-fail。

### 注释规范

- 每个阶段顶部必须有有意义的块注释
- 单行注释用 `/* xxx */`，多行用 `/* ... */`
- 禁用 `//` 做阶段标题
- 禁止无价值占位注释（如 `// 1. 参数声明区域`）
- 注释精准简洁，至少覆盖"做了什么"，可选补充"为了什么"
- 同一阶段默认只写一条阶段注释；内部禁止与代码行为重复的注释
- 仅在"业务规则不直观/有坑/反直觉"时允许极少量局部注释，且解释"为什么"

反例（意图过细）：`/* 建立依赖关系：先把后续要用到的对象查出来，避免在业务执行阶段穿插防御分支 */`
正例（精准简洁）：`/* 查 xx 表拿对象 */`

### 空行规则

- 同一分区内部不允许意义不明的空行；同阶段操作连续排列
- 块注释与本阶段第一行代码之间不插空行
- 空行只用于分区切割
- 空分区直接省略

### 入参变量复用

- 允许直接对方法入参变量重新赋值（补默认值/归一化）
- 不额外声明同含义变量（如 `String bizCode = code`）
- 例外：语义发生转换时允许（如 `rawCode` vs `normalizedCode`）

### 完整示例

```java
public void doSomething(Long id, String code) {
    /* 入参 fast-fail 校验 */
    if (id == null) {
        throw new BizException("id 不能为空");
    }

    /* 查 BizEntity 表拿对象 */
    BizEntity entity = bizService.getById(id);

    /* 默认值兜底：补齐 code */
    if (StrUtil.isBlank(code)) {
        code = entity != null ? entity.getDefaultCode() : null;
    }

    /* 二次 fast-fail：依赖关系校验 */
    if (entity == null) {
        throw new BizException("记录不存在");
    }
    if (StrUtil.isBlank(code)) {
        throw new BizException("业务编码不能为空");
    }

    /* 执行业务 */
    bizService.process(entity, code);
}
```

### 核心对象强依赖的声明阶段 fast-fail

若后续变量初始化都强依赖某个核心对象，一旦该对象为 null 后续声明都没有意义，允许在声明阶段刚拿到核心对象后立刻 fast-fail：

```java
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
```

### 反例：把"声明 + 兜底"揉成一次性表达式

```java
/* 反面: 阶段边界不清晰 */
String physicalCarrierCode = StrUtil.isNotBlank(order.getPhysicalCarrierCode())
        ? order.getPhysicalCarrierCode()
        : logistics.getPhysicalCarrierCode();

/* 正面: 先声明，再兜底，优先级清晰 */
String physicalCarrierCode = order.getPhysicalCarrierCode();
if (physicalCarrierCode == null) {
    physicalCarrierCode = logistics.getPhysicalCarrierCode();
}
```

---

## R10. 避免过度防御性编程包装

防御性编程应服务于"边界清晰 + 主流程顺畅"，不要把多个防御动作堆进一行参数表达式里。

### 典型坏味道

在一个参数表达式里同时做空判断 + 取值 + 归一化/兜底，尤其是把三元表达式嵌到 `xxxToDefault(...)` 里。

### 落地建议

- **强依赖**（缺失就无法继续）: 在业务层入口 fast-fail
- **弱依赖**（允许为空但需统一语义）: 下沉到被调用方集中承接，业务层只透传值
- 若确实存在"兼容空值"的行为差异: 写进方法名或拆成两个方法

### 代码示例

反例：

```java
.addUserMessage(StrUtil.nullToEmpty(requestBO != null ? requestBO.getText() : null))
.execute();
```

推荐写法 A（强依赖：前置 fast-fail）：

```java
if (requestBO == null) {
    throw new BizException("requestBO 不能为空");
}

String text = requestBO.getText();
if (StrUtil.isBlank(text)) {
    throw new BizException("text 不能为空");
}

prompt.addUserMessage(text).execute();
```

推荐写法 B（上游已保证非空：直接透传，底层承接空值）：

```java
prompt.addUserMessage(requestBO.getText()).execute();
```

底层承接方式示意：

```java
public Prompt addUserMessage(String text) {
    /* text 允许为 null：底层统一归一化 */
    this.userMessage = StrUtil.nullToEmpty(text);
    return this;
}
```

---

## R11. 禁止为微小性能提升牺牲可读性

可读性优先于微优化。禁止用手写魔数、位运算技巧、手动内联等手段换取可忽略的性能提升。

### 代码示例

反例（手写字节魔数检测文件格式）：

```java
if ((content[0] & 0xFF) == 0x89 && content[1] == 0x50 && content[2] == 0x4E && content[3] == 0x47) {
    extension = ".png";
} else if ((content[0] & 0xFF) == 0xFF && (content[1] & 0xFF) == 0xD8 && (content[2] & 0xFF) == 0xFF) {
    extension = ".jpg";
} else if (content[0] == 0x47 && content[1] == 0x49 && content[2] == 0x46 && content[3] == 0x38) {
    extension = ".gif";
}
```

推荐写法（使用标准库）：

```java
String mimeType = tika.detect(content);
if ("image/png".equals(mimeType)) {
    extension = ".png";
} else if ("image/jpeg".equals(mimeType)) {
    extension = ".jpg";
} else if ("image/gif".equals(mimeType)) {
    extension = ".gif";
}
```

约束：
- 禁止在业务代码中用手写字节魔数做逻辑判断
- 有成熟工具库能完成的工作，必须优先使用
- 微优化的前提是"有可观测的性能瓶颈"，否则视为过早优化
