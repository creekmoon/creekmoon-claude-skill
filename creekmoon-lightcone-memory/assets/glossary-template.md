---
type: glossary
name: {project-name}-glossary
title: 业务术语表
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
term_count: 0
---

# 业务术语表

> 本文档建立**业务语言 → 技术实现**的映射，统一团队术语，消除歧义。
> 术语与业务产物的关联见 [business/artifacts/](../business/artifacts/) 目录。

## 术语总览

| 统计项 | 数量 |
|--------|------|
| 业务术语 | {N} |
| 涉及表数 | {M} |
| 同义词组 | {K} |

---

## 按业务域分类

### {domain-name}（如：订单域）

#### {term-name}

| 属性 | 内容 |
|------|------|
| **业务定义** | {该术语的业务含义} |
| **物理字段** | `{table}.{field}` |
| **数据类型** | {type} |
| **计算逻辑** | `{formula}` 或 "直接存储" |
| **所属产物** | [{artifact}](../business/artifacts/{artifact}.md) |

**同义词/易混淆词**:
- ❌ 勿与 `{similar_term}` 混淆：{区别说明}
- ⚠️ 注意 `{another_term}` 在不同上下文的含义差异

**使用示例**:
```sql
-- 计算 {term-name}
SELECT {field}, {related_field}
FROM {table}
WHERE {condition}
```

---

## 完整术语矩阵

| 业务术语 | 物理字段 | 所属表 | 业务定义 | 计算逻辑 | 同义词陷阱 |
|----------|----------|--------|----------|----------|------------|
| {term_a} | `{field_a}` | [{table_a}](../schema/tables/{table_a}.md) | {定义} | {formula} | 勿与{term_b}混淆 |
| {term_b} | `{field_b}` | [{table_b}](../schema/tables/{table_b}.md) | {定义} | "原生存储" | {term_a}的旧称 |

---

## 术语歧义对照表

### "{ambiguous_term}" 的多重含义

| 上下文 | 含义 | 对应字段 | 使用场景 |
|--------|------|----------|----------|
| 财务模块 | {含义A} | `{table_a}.{field_a}` | 结算场景 |
| 运营模块 | {含义B} | `{table_b}.{field_b}` | 报表场景 |
| 客户模块 | {含义C} | `{table_c}.{field_c}` | 展示场景 |

> ⚠️ **建议**: 在{context}场景下统一使用"{recommended_term}"以避免混淆。

---

## 指标定义卡片

### {metric-name}（如：GMV成交金额）

```markdown
- **业务定义**: {指标的业务含义}
- **计算公式**: `{formula}`
- **来源表**: [{table}](../schema/tables/{table}.md)
- **更新频率**: {频率，如：实时/T+1/小时级}
- **负责人**: {责任人}
- **注意事项**:
  - {注意点1}
  - {注意点2}
```

**SQL模板**:
```sql
-- {metric-name} 计算
SELECT
    DATE(create_time) as dt,
    SUM({amount_field}) as {metric_name}
FROM {table}
WHERE {status_field} NOT IN ('cancelled', 'refunded')
  AND create_time >= '{start_date}'
GROUP BY DATE(create_time)
```

---

## 数据字典对照

### 状态枚举统一

| 状态值 | 显示名 | 业务含义 | 适用场景 |
|--------|--------|----------|----------|
| {value1} | {label1} | {含义} | {场景} |
| {value2} | {label2} | {含义} | {场景} |

### 类型枚举统一

| 类型值 | 显示名 | 说明 |
|--------|--------|------|
| {type1} | {label1} | {说明} |
| {type2} | {label2} | {说明} |

---

## 新成员速查

**最常见的3个查询场景**:

1. **查某用户的订单**:
   ```sql
   SELECT * FROM {order_table}
   WHERE {user_id_field} = ?
   ```

2. **按天统计{metric_name}**:
   ```sql
   SELECT DATE({time_field}), SUM({amount_field})
   FROM {table}
   GROUP BY DATE({time_field})
   ```

3. **关联{entity_a}和{entity_b}**:
   ```sql
   SELECT a.*, b.*
   FROM {table_a} a
   JOIN {table_b} b ON a.{fk} = b.{pk}
   ```

**已知数据陷阱**:
- {field_a} 可能为NULL，查询时需加`COALESCE`
- {table_b} 包含测试数据，过滤条件需加`is_test = 0`
- {field_c} 的取值在{version}版本后有变化
