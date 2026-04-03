# Temp Workspace

本文件定义 `creekmoon-herta-deepresearch` 的临时工作区机制。

目的不是长期沉淀，而是给多子代理研究提供一个可落盘的中间态，减轻最终合并时的上下文压力。

## 目录

默认临时目录：

```text
.herta-deepresearch-temp/
└── {task-id-or-scene-slug}/
    ├── 00-scene-framing.md
    ├── exploration/
    │   ├── scout-{facet}.md
    │   └── hotspots.md
    ├── evidence/
    │   ├── logic-evidence.md
    │   ├── structure-evidence.md
    │   ├── relation-evidence.md
    │   └── gap-audit.md
    ├── merge/
    │   ├── dedup-notes.md
    │   ├── conflict-matrix.md
    │   └── merge-brief.md
    ├── synthesis/
    │   └── conclusion-pack.md
    └── final/
        └── report-draft.md
```

## 什么时候应该使用

以下情况默认应该启用临时工作区：
- 使用 3 个及以上子代理
- 研究对象横跨多个证据面
- 预计会产生高密度 `evidence-pack`
- 主代理判断“最后直接拼上下文”会导致整合效果下降

问题非常小、证据面极少时，可以不启用。

## 使用原则

- 子代理把自己的中间结果写到对应目录
- 主代理优先读取这些中间文件做归并，而不是完全依赖消息上下文
- 中间文件要服务于“压缩和合并”，不要重新写成长报告
- 每个文件都尽量短、硬、可合并

## 文件职责

### `00-scene-framing.md`

由主代理创建，写清：
- 场景名称
- 主问题
- 主类型 / 次类型
- 读者模式
- 本轮不研究什么

### `exploration/*.md`

由探索子代理创建，重点写：
- 覆盖了什么
- 找到了什么热点
- 哪些区域值得继续深挖

### `evidence/*.md`

由研究子代理创建，重点写：
- 证据包
- 关键规则候选
- 冲突与缺口

### `merge/*.md`

由主代理创建，重点写：
- 去重结果
- 冲突矩阵
- 合并后的短摘要

### `synthesis/conclusion-pack.md`

由 `synthesizer` 创建或更新，作为进入写作前的稳定底稿。

### `final/report-draft.md`

可选。仅在需要多轮改写时使用。

## 写作要求

- 文件名要表达职责，不要乱命名
- 同类文件尽量固定结构，便于主代理批量归并
- 不要把原始搜索日志整段塞进临时目录
- 优先保存压缩后的中间产物，而不是所有过程噪音

## 清理策略

- 这些文件是临时工作区，不属于正式产物
- 可以保留到本次研究结束，之后按需清理或覆盖
- 目录已在仓库 `.gitignore` 中忽略

## 一句话原则

**当多子代理带来信息过载时，用临时文件把中间态落盘，再做二次合并。**
