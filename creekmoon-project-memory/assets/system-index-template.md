---
description: 根层入口索引 - 项目整体概览和完整知识树导航
---

# {项目名称} - 系统总览

> 一句话定位: {项目是什么，解决什么问题}

---

## 快速导航

| 文档 | 内容 | 阅读顺序 |
|------|------|----------|
| [01-context.md](01-context.md) | 项目背景、目标、边界 | **1st** |
| [02-architecture.md](02-architecture.md) | 系统架构、组件关系 | **2nd** |
| [03-tech-stack.md](03-tech-stack.md) | 技术栈、依赖版本 | **3rd** |
| [04-data-model.md](04-data-model.md) | 核心数据实体 | 按需 |
| [05-conventions.md](05-conventions.md) | 全局约定、规范 | 编码前 |

---

## 完整知识树

> 两级索引：模块（子层）→ 每模块的链路文档（链路层）。无需打开子文档即可判断导航路径。

### {模块A} — {一句话职责}

→ [mod-{A}.md](../02-modules/mod-{A}.md)

- flow: [flow-{流程1}](../03-chains/{A}/flow-{流程1}.md) · {一句话说明}
- lifecycle: [lifecycle-{实体}](../03-chains/{A}/lifecycle-{实体}.md) · {一句话说明}
- interaction: [interaction-{协作}](../03-chains/{A}/interaction-{协作}.md) · {一句话说明}

### {模块B} — {一句话职责}

→ [mod-{B}.md](../02-modules/mod-{B}.md)

- flow: [flow-{流程2}](../03-chains/{B}/flow-{流程2}.md) · {一句话说明}
- （暂无链路文档）

---

## 项目元信息

| 属性 | 值 |
|------|-----|
| 项目名 | {name} |
| 技术栈 | {Java SpringBoot / Node.js / Python ...} |
| 主要语言 | {Java / TypeScript / Python} |
| 创建时间 | {YYYY-MM} |
| 最后更新 | {YYYY-MM-DD} |

---

## 关键入口

```
src/
├── main/
│   ├── java/com/{company}/{project}/
│   │   ├── Application.java          # 启动类
│   │   ├── config/                   # 全局配置
│   │   ├── common/                   # 公共组件
│   │   └── {domain}/                 # 业务模块
└── test/                             # 测试
```

---

## 外部系统

| 系统 | 类型 | 用途 |
|------|------|------|
| {MySQL} | 数据库 | 主数据存储 |
| {Redis} | 缓存 | 会话/热点数据 |
| {Kafka} | 消息队列 | 事件驱动 |
| {第三方} | API | {用途} |
