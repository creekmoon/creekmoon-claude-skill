---
type: schema-table
name: {table-name}
title: {表中文名}
table_type: {config|transaction|snapshot|aggregate|relational|core}
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
primary_artifact: {artifact-name}
logical_entity: {entity-name}
---

# {表名} ({表中文名})

## 表基础信息

| 属性 | 值 |
|------|-----|
| 表名 | `{table_name}` |
| 表类型 | {config/transaction/snapshot/aggregate/relational/core} — {类型说明} |
| 引擎 | {InnoDB/MyISAM/etc} |
| 字符集 | {utf8mb4/etc} |
| 主要业务产物 | [{artifact}](business/artifacts/{artifact}.md) |
| 逻辑实体 | [{entity}](../atlas/entities.md#{entity}) |
| 数据规模 | {预估行数/增长趋势} |

### 表类型说明

| 类型 | 特征 | 典型命名 | 使用场景 |
|------|------|----------|----------|
| **config** | 配置表 | `_config`, `_dict`, `_dim` | 业务配置、字典数据，通常<1000行 |
| **transaction** | 流水表 | `_log`, `_event`, `_detail` | 不可更新的历史记录，量大 |
| **snapshot** | 快照表 | `_snapshot`, `_status` | 含日期分区，全量或增量快照 |
| **aggregate** | 汇总表 | `_agg`, `_stat`, `_sum` | 预计算结果，可能丢失原子粒度 |
| **relational** | 关系表 | `_rel`, `_map`, `_link` | 多对多映射，无业务含义主键 |
| **core** | 核心表 | 核心业务名词 | 业务核心实体主表 |

## DDL / ORM 定义

### 来源

- **DDL 文件**: `{path/to/ddl.sql}`
- **ORM 实体类**: `{package/EntityClass.java}`
- **迁移脚本**: `{migration/V001__create_table.sql}`

### 原始 DDL

```sql
CREATE TABLE `{table_name}` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `status` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### ORM 注解（如果是 JPA/MyBatis）

```java
@Entity
@Table(name = "{table_name}")
public class {EntityClass} {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, columnDefinition = "int default 0")
    private Integer status;
}
```

## 字段详解

| 字段名 | 类型 | 可空 | 默认 | 业务含义 | 示例值 | 备注 |
|--------|------|------|------|----------|--------|------|
| `id` | bigint | NO | AUTO_INCREMENT | 主键 ID | 12345 | 自增 |
| `status` | int | NO | 0 | 状态码 | 1=CREATED, 2=PAID | 见状态枚举定义 |
| `created_at` | timestamp | NO | CURRENT_TIMESTAMP | 创建时间 | 2024-03-14 10:30:00 | 自动填充 |

### 字段业务规则

| 字段 | 业务规则 | 证据位置 |
|------|----------|----------|
| `{field}` | {规则描述，如"必须是已存在的用户ID"} | `{ClassName}#method(ParamType)` |

## 索引

| 索引名 | 类型 | 字段 | 用途 | 备注 |
|--------|------|------|------|------|
| `PRIMARY` | 主键 | `id` | 唯一标识 | - |
| `idx_status` | 普通 | `status` | 状态查询 | 常用于 WHERE status=? |
| `uk_{field}` | 唯一 | `{field}` | 业务唯一约束 | - |

## 关联表

### 外键关系（本表引用其他表）

| 本表字段 | 关联表 | 关联字段 | 关系类型 | 级联规则 | 业务含义 |
|----------|--------|----------|----------|----------|----------|
| `{fk_column}` | [{table_b}]({table_b}.md) | `id` | {N:1} | {RESTRICT} | {含义} |

### 被引用关系（其他表引用本表）

| 引用表 | 引用字段 | 本表字段 | 关系类型 | 业务影响 |
|--------|----------|----------|----------|----------|
| [{table_c}]({table_c}.md) | `{table_a_id}` | `id` | {1:N} | {删除时需检查} |

### JOIN 查询模式

```java
// 典型的关联查询模式
SELECT a.*, b.name
FROM {table_a} a
JOIN {table_b} b ON a.{fk_col} = b.id
WHERE a.status = ?
```

## 逻辑实体归属

> 说明：本表在业务实体模型中的位置和作用

### 所属实体

| 逻辑实体 | 实体作用 | 相关表 | 本表角色 |
|----------|----------|--------|----------|
| [{entity}](../atlas/entities.md#{entity}) | {实体定义} | {table_a}, {table_b}, {table_c} | {主表/扩展表/关系表} |

### 实体在物理表中的分布

```
实体: {entity}
├── 主表: [{main_table}]({main_table}.md) — 存储{核心字段}
├── 扩展表: [{ext_table}]({ext_table}.md) — 存储{扩展字段}
└── 关系表: [{rel_table}]({rel_table}.md) — 关联{other_entity}
```

## 字段血缘

> 字段来源分析：原生字段 vs 计算字段 vs 冗余字段

### 字段来源矩阵

| 字段名 | 来源类型 | 来源说明 | 计算公式/推导规则 | 证据位置 |
|--------|----------|----------|-------------------|----------|
| `{native_field}` | 原生 | 直接存储 | - | 用户输入/外部系统 |
| `{calculated_field}` | 计算 | 代码生成 | `{formula}` | `{Class}#{method}()` |
| `{derived_field}` | 冗余 | 可从其他字段推导 | 由`{source_field}`{推导规则} | `{Class}#{method}()` |

### 计算字段详情

| 字段 | 计算公式 | 计算时机 | 业务含义 |
|------|----------|----------|----------|
| `{field_a}` | `{field_b} + {field_c}` | 写入时计算 | {说明} |
| `{field_d}` | `CASE WHEN {condition} THEN {value1} ELSE {value2} END` | 查询时计算 | {说明} |

### 冗余字段一致性

| 冗余字段 | 源字段 | 推导规则 | 一致性检查 |
|----------|--------|----------|------------|
| `{redundant_field}` | `{source_field}` | {规则} | `{Checker}#checkConsistency()` |

## 数据质量验证

> 用于验证文档准确性和数据一致性的检查清单

### 主键与唯一性

```sql
-- 主键唯一性检查
SELECT `{pk_field}`, COUNT(*) as cnt
FROM `{table_name}`
GROUP BY `{pk_field}`
HAVING cnt > 1;

-- 业务唯一键检查
SELECT `{uk_field}`, COUNT(*) as cnt
FROM `{table_name}`
WHERE `del_flag` = 0
GROUP BY `{uk_field}`
HAVING cnt > 1;
```

### 空值率检查

```sql
-- 关键字段空值率
SELECT
    COUNT(*) as total_rows,
    COUNT(`{field_a}`) as non_null_a,
    COUNT(`{field_b}`) as non_null_b,
    (COUNT(*) - COUNT(`{field_a}`)) / COUNT(*) * 100 as null_rate_a
FROM `{table_name}`;
```

### 外键一致性

```sql
-- 孤儿记录检查（本表外键在关联表中是否存在）
SELECT a.*
FROM `{table_name}` a
LEFT JOIN `{ref_table}` b ON a.`{fk_field}` = b.`{pk_field}`
WHERE a.`{fk_field}` IS NOT NULL
  AND b.`{pk_field}` IS NULL;
```

### 时间连续性

```sql
-- 时间字段范围检查
SELECT
    MIN(`{time_field}`) as earliest,
    MAX(`{time_field}`) as latest,
    COUNT(DISTINCT DATE(`{time_field}`)) as distinct_days
FROM `{table_name}`;
```

### 状态值有效性

```sql
-- 状态值分布（检查是否有未定义的状态）
SELECT `{status_field}`, COUNT(*) as cnt
FROM `{table_name}`
GROUP BY `{status_field}`
ORDER BY cnt DESC;
```

### 数据质量报告

| 检查项 | 期望结果 | 实际结果 | 状态 | 备注 |
|--------|----------|----------|------|------|
| 主键唯一性 | 无重复 | {结果} | {✅/❌} | {备注} |
| {field_a}空值率 | <5% | {结果} | {✅/❌} | {备注} |
| 外键一致性 | 无孤儿记录 | {结果} | {✅/❌} | {备注} |
| 时间连续性 | 无断档 | {结果} | {✅/❌} | {备注} |

## 业务规则推断

### 从表结构推断的约束

| 规则 | 推断依据 | 业务含义 |
|------|----------|----------|
| `{规则名}` | `{字段}+非空约束` | {业务含义} |

### 状态字段说明（如果有）

| 状态值 | 含义 | 允许转换到 | 触发条件 |
|--------|------|------------|----------|
| 0 | INIT | 1, 2 | 初始化 |
| 1 | CREATED | 2 | 创建完成 |
| 2 | COMPLETED | - | 处理完成 |

## 证据锚点

- **DDL 文件**: `{path/to/ddl.sql}`
- **ORM 实体**: `{package/EntityClass.java}`
- **Mapper 接口**: `{package/MapperClass.java}`
- **核心业务查询**: `{ServiceClass}#{queryMethod}({ParamType})` — {用途}
- **关联业务产物**: [business/artifacts/{artifact}.md](business/artifacts/{artifact}.md)
- **逻辑实体**: [atlas/entities.md#{entity}](../atlas/entities.md#{entity})
- **业务术语**: [atlas/glossary.md](../atlas/glossary.md)
