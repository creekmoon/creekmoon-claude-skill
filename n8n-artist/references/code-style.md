# 场景 B：Code 节点代码风格（JS / Python）

Code 节点是 n8n 里最后的手段，不是第一选择；但一旦写了，就要写得优雅。本规则从 creekmoon-code-style（R1-R14）提炼适配到 n8n Code 节点的运行契约。

## B0. 使用门槛（写代码之前先过一遍）

- **能用内置节点表达的不写 Code**：字段增删改（Set / Edit Fields）、数组展开合并（Item Lists）、排序（Sort）、聚合（Aggregate）、日期处理（Date & Time）都有专用节点。可视化节点比代码更易读、更不容易坏。
- **单节点代码超 ~80 行考虑拆分**：抽成 Sub-workflow，或拆成两个职责单一的 Code 节点中间用 Set 衔接。
- **Code 节点不做 I/O 编排**：发 HTTP、写库走对应节点；Code 只做纯数据转换。把 HTTP 调用写进 Code 节点，错误处理、重试、凭据管理全部绕开 n8n 的节点级能力。

## B1. 两种运行模式的契约

**Run Once for All Items**（默认）：拿到全部 items，必须 return 一个数组。

```javascript
const items = $input.all();

/* 归一化邮箱并补齐称呼，过滤无邮箱条目 */
return items
  .filter(item => item.json.email)
  .map(item => ({
    json: {
      email: item.json.email.trim().toLowerCase(),
      name: item.json.name || 'unknown',
    },
  }));
```

**Run Once for Each Item**：逐条处理，返回 `[{ json: ... }]` 或 `[]`。

```javascript
const item = $input.item.json;

/* 单条数据为空时直接跳过，主流程平铺 */
if (!item.orderId) {
  return [];
}

return [{ json: { orderId: item.orderId, status: '已受理' } }];
```

- 无结果时 `return []`，不要 return undefined 或 null——n8n 会报错。
- Python 模式同理（`$input.all()` / `$input.item.json`，返回 list[dict]）。

## B2. Happy Path First（对应 R5）

主流程平铺为主线，异常数据早过滤、早返回。

- 反面：主逻辑缩在 `if (item.json && item.json.xxx && ...)` 的三层嵌套里
- 正面：先 `.filter()` 掉异常项，或对单条模式先 `if (!valid) return []`，然后主流程一路平铺

## B3. 分区组织与注释（对应 R9 / R14）

代码稍长（> 15 行）时按职责分区，空行只用于分区切割：

```
/* 入参校验 */        —— fast-fail，缺什么直接过滤或返回空
/* 数据转换 */        —— 纯 CPU 转换
/* 结果组装 */        —— 构造返回的 items 结构
```

注释遵循信息增量原则：只写代码说不出的（为什么这么做、业务坑、外部约束）。禁止复述代码行为的废话注释；中文注释。

## B4. Name == Behavior（对应 R3）

- 变量/函数名完整表达行为：`normalizeEmail`、`pickDispatchableOrders`，不是 `data`、`temp`、`result2`
- map/filter 里的转换函数抽成具名箭头函数，别塞匿名大括号块：

```javascript
/* 组装下游可消费的通知载荷 */
const toNoticePayload = (item) => ({
  json: {
    title: `订单 ${item.json.orderId} 发货超时`,
    receiver: item.json.ownerId,
  },
});

return $input.all().filter(item => item.json.delayHours > 24).map(toNoticePayload);
```

## B5. 不过度防御（对应 R10 / R13）

n8n 节点级已有错误处理（error output、retryOnFail、continueOnFail），Code 内不重复堆防御：

- 可选链 + 默认值覆盖 90% 场景：`item.json.name || 'unknown'`
- 不在分支谓词里混存在性检查改变路由——`if (item.json.type === 'urgent')` 就是业务判断，不要再 `&& item.json.title` 把合法的空标题数据漏到别的分支
- 真要 fail-fast（缺关键字段后续必崩），在入口一个 `if` 集中处理，之后主流程零防御

## B6. 禁止硬编码（对应 R11 精神）

- 密钥、Token、内网 URL、环境相关常量：走 `$env.VAR_NAME`、n8n Variables 或 credentials，禁止写死在代码里
- 魔法数字（状态码、类型枚举）提为顶部具名常量，并注释业务含义

```javascript
/* 订单状态：3=已发货，5=已签收（与 ERP 状态字典一致） */
const SHIPPED = 3;
const SIGNED = 5;
```

## B7. 审查输出格式

审查 Code 节点时按 creekmoon-code-style 的三级输出，依据类型四选一：

- **Style Rule**：对应 B0-B6 中某条，写规则号
- **Correctness**：运行即错/结果必错的风险（如该 return 数组却 return 对象）
- **Project Convention**：工作流内既有风格一致性
- **Preference**：纯审美，不强制

正面/反面对照例放在报告里——一段改前改后的代码比十句描述更有说服力。
