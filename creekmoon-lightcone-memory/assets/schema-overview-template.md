---
type: schema-overview
name: schema-overview
title: 数据 Schema 总览
coverage: stub
last_verified: YYYY-MM-DD
confidence: low
db_type: MySQL
version: "8.0"
---

# {数据存储名称} Schema 总览

## 数据存储信息

| 属性 | 值 |
|------|-----|
| 存储类型 | {MySQL/PostgreSQL/MongoDB/DynamoDB/etc} |
| 版本 | {版本号} |
| 字符集/编码 | {utf8mb4/etc} |
| 表/集合数量 | {N} |

## 核心表清单

| 表/集合名 | 主要业务产物 | 数据规模估计 | 核心字段 | Schema 文档 |
|------------|-------------|--------------|----------|-------------|
| `{table/collection_name}` | [{artifact}](business/artifacts/{artifact}.md) | {规模} | {id, status, user_id} | [tables/{table_name}.md](tables/{table_name}.md) |

## ER 图

```mermaid
erDiagram
    {TABLE_A} ||--o{ TABLE_B : "外键关系"
    {TABLE_A} {
        bigint id PK
        varchar name
        int status
    }
    {TABLE_B} {
        bigint id PK
        bigint table_a_id FK
        timestamp created_at
    }
```

> **说明**：ER 图只显示核心表和关键关系。详细的字段信息请查看各表的独立文档。

## 关键关系说明

| 关系 | 类型 | 业务含义 | 级联规则 |
|------|------|----------|----------|
| `{table_a}.{fk_col}` → `{table_b}.{pk_col}` | {1:1/1:N/N:M} | {业务含义} | {CASCADE/SET NULL/RESTRICT} |

## Schema 变更历史

| 日期 | 变更类型 | 表/字段 | 变更内容 | 相关需求 |
|------|----------|---------|----------|----------|
| YYYY-MM-DD | ADD | {table}.{column} | {新增字段} | {需求背景} |

## 数据流概览

```
[用户操作] → [表 A] → [表 B] → [下游系统]
                ↓
            [关联表 C]
```

> 详细的业务数据流请查看 [business/flows/](business/flows/) 目录。
