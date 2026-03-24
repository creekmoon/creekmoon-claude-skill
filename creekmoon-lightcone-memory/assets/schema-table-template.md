---
type: schema-table
name: {table-name}
title: {表中文名}
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
primary_artifact: {artifact-name}
---

# {表名} ({表中文名})

## 表基础信息

| 属性 | 值 |
|------|-----|
| 表名 | `{table_name}` |
| 引擎 | {InnoDB/MyISAM/etc} |
| 字符集 | {utf8mb4/etc} |
| 主要业务产物 | [{artifact}](business/artifacts/{artifact}.md) |
| 数据规模 | {预估行数/增长趋势} |

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
