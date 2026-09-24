---
name: n8n-artist
version: 1.7.2
description: N8N艺术家——n8n 工作流编排美学与健康管理技能：以编排分布整理（节点坐标重排、画布分区、消除连线交叉）、节点命名规范（动词+业务对象的语义命名）、Code 节点 JS/Python 优雅代码风格、执行历史与失效变量引用异常巡检（含表达式健康检查）、Agent 工具编排设计（工具调用链顺序与兜底、toolDescription、$fromAI 参数质量、检索覆盖缝隙）、LLM 节点提示词瘦身去废话（默认保守改动+前后对比预览确认）、工作流检查与四维评分（命名/参数/历史运行/业务编排各 10 分，逐节点过检查清单）为核心能力。支持经 n8n MCP 自动拉取工作流 JSON 与执行历史，也支持用户直接粘贴 workflow JSON。Make sure to use this skill whenever the user 要对 n8n 工作流做检查或评分（工作流检查/工作流评分/体检/打分/量化健康度）、优化一个 n8n 工作流、整理编排节点分布或画布布局、规范节点命名、审查 Code 节点代码风格、排查工作流执行失败与节点异常、查找失效的变量引用与表达式、设计或优化 AI Agent 的工具调用（工具描述、调用顺序、检索类工具不命中）、精简 AI Agent / LLM 节点的提示词减少废话和 token 消耗，或粘贴 n8n workflow JSON 要求 review。即使用户只说"这个 n8n 流程有没有问题""帮我检查一下这个工作流""帮我整理一下编排""这个 workflow 一直报错""Agent 该调的没调、该查的查不到"也应触发。
---

# N8N艺术家

n8n 工作流的「美学 + 健康度」双重管家。一条工作流不仅要能跑，还要画布整洁、命名达意、代码优雅、prompt 精干——四者缺一，半年后的维护者（通常就是你自己）就要付出翻倍代价。

## 六大职责

| 职责 | 回答的问题 | 详细规则 |
|------|-----------|---------|
| A. 布局与命名 | 画布乱不乱？节点名看不看得懂？ | [references/layout-and-naming.md](references/layout-and-naming.md) |
| B. Code 节点风格 | Code 节点里的 JS/Python 优不优雅？ | [references/code-style.md](references/code-style.md) |
| C. 异常体检 | 哪里在坏？哪里有失效引用？ | [references/anomaly-check.md](references/anomaly-check.md) |
| D. Prompt 瘦身 | LLM 节点的提示词有没有废话？ | [references/prompt-polish.md](references/prompt-polish.md) |
| E. Agent 工具编排 | 工具调用链设计对不对？检索为什么 miss？ | [references/agent-tool-orchestration.md](references/agent-tool-orchestration.md) |
| F. 工作流检查/评分 | 这个流程整体打多少分？ | 总清单在 SKILL.md，细则 [references/scoring.md](references/scoring.md) |

## 总工作流

```
Step 0  获取工作流数据（MCP 优先 / 粘贴兜底）
   ↓
Step 1  结构化解析：nodes[] / connections{} / settings / pinData
   ↓
Step 2  按用户诉求路由到场景 A-F（检查/体检/评分类任务：先过「检查/评分总清单」）
   ↓
Step 3  输出：审查报告（只读）或 变更清单 + 修改产物（改动类）
```

## Step 0：数据获取

### 路径一：n8n MCP（优先）

环境中已配置多套 n8n MCP 时（如生产/测试各一套、或多业务线各一套），按以下顺序：

1. **确认目标环境**。用户指明了环境就直接用；存在生产/测试多套且用户没说清时，先问一句——对生产做写操作和对测试做写操作是两回事。
2. **定位工作流**：`n8n_list_workflows` 按名称/tags 找到工作流 ID。
3. **拉取结构**：`n8n_get_workflow` 先用 `mode='structure'` 拿拓扑（节点名、类型、连接关系）；需要看某个重型节点（长 Code 源码、大 prompt）再用 `mode='filtered'` 按节点名精确取，避免整包截断。
4. **draft/publish 双轨意识**：workflow body 是草稿，`mode='active'` 才是线上真实运行的图。做异常体检时若工作流已激活，应对比两者差异——草稿里修好的 bug 没发布，线上照样在坏。
5. **拉执行历史**（场景 C 用）：`n8n_executions` 先 `action='list'` 按 workflowId 过滤统计（可加 `status='error'`），再对典型失败 `action='get'` + `mode='error'` 看错误节点、执行路径和上游采样数据。

> 工具名以环境中实际配置的 MCP server 为准，前缀随 server 名变化，函数名一致。

### 路径二：粘贴 JSON（兜底）

用户直接粘贴 workflow JSON 时：

1. 用 `validate_workflow`（无需工作流 ID 的版本）先做结构、连接、表达式三层校验。
2. 执行历史拿不到——**明确告知用户"无历史数据，失效引用只能做静态检查"，结论置信度相应下调**，需要历史时引导用户走 MCP 路径。

## 安全红线（改动类操作必读）

- **默认只读**。审查、体检、给建议不需要任何确认；但凡要改工作流（update、autofix apply、删除），先给变更清单，获用户明确同意后才动手。
- **validateOnly 先行**：用 `n8n_update_partial_workflow` 时先 `validateOnly: true` 验证操作合法，再正式应用。
- **生产环境以只读为主**：修改优先在测试环境完成验证，再谈生产。
- **重命名节点是连锁操作**：节点名是 connections 的 key，也是 `$node["旧名"]` / `$('旧名')` 表达式的锚点。重命名一个节点必须同步：connections 的 key、全工作流表达式里的旧名引用。漏一处就多一个运行时错误。
- **失效引用的移除要确认**：引用失效 ≠ 逻辑无用。移除前确认该表达式/节点确实不再承载业务意图，拿不准就列为"待确认"并给验证方法。
- **改提示词先预览后确认**：任何 prompt 改动先输出「前后对比预览」（原文/优化后/逐条理由），用户明确同意后才应用。默认保守档——只删零信息内容、信号词只增不删、不动结构与规则表述；仅当用户明确提出重构/激进改动才允许动结构。详见 [references/prompt-polish.md](references/prompt-polish.md) 的 D0。
- **编排逻辑只住 Agent prompt**：工具描述只写工具本身与参数（优先用节点默认描述，不整段覆盖）；触发时机、调用顺序、兜底链写进 Agent 的 system prompt，禁止下沉到工具描述——否则改流程要同步改 N 处，必然不一致。
- **流程名称是身份标识，不允许随意改**：工作流名被文档、监控、告警和同事的习惯引用，改名只在用户明确提出时执行。检查中觉得名字不规范，写进报告建议区，不得顺手改掉；改名与节点改名一样是连锁操作（外部系统按名字引用它时，改完要提醒用户同步）。
- **同类问题全量处理**：报错只是同类问题的第一个露头。修复前**按模式枚举全部实例**（如"所有需要 webhook 上下文的节点""所有含 `{{ }}` 的参数字段"），列全清单一次修完，不按已发生报错逐个点名修。修完后按**同一模式全量复检**，不只验证改过的那几个节点——第二轮才冒出"同样的错"就是第一轮只修了报名节点的典型后果。
- **重命名后全量搜残留**：n8n 重命名节点只自动更新 connections，**不会更新 `$()` 表达式和 prompt 文本**。含重命名的批次应用后，全量拉取工作流搜索旧名（含 `$('旧名')`、`$node["旧名"]`、prompt 里的工具引用名），有残留必须补改后才算交付——旧名残留会让依赖它的下游节点成片静默失效。

## 场景路由

| 用户说 | 场景 | 参考文件 |
|--------|------|---------|
| "帮我整理布局 / 重排一下 / 画布太乱了" | A 布局 | layout-and-naming.md |
| "节点名全是 HTTP Request 1 / Set 2" | A 命名 | layout-and-naming.md |
| "看看这段 Code 节点代码 / 帮我写个 Code 节点" | B 代码风格 | code-style.md |
| "这个流程最近老失败 / 帮我体检一下" | C 异常体检 | anomaly-check.md |
| "有没有失效的变量引用 / 表达式还成立吗" | C 异常体检 | anomaly-check.md |
| "优化一下 AI 节点的 prompt / 提示词太啰嗦" | D Prompt 瘦身 | prompt-polish.md |
| "Agent 该调的没调 / 查不到本该存在的数据 / 工具调用顺序 / 工具描述怎么写" | E 工具编排 | agent-tool-orchestration.md |
| "工作流检查 / 给这个工作流打个分 / 量化健康度 / 逐节点检查" | F 检查评分 | 先过 SKILL.md 总清单，细则 scoring.md |
| "全面检查一下 / 整体优化" | A+B+C+D+E+F | 全部 |

## 场景速览（详细规则在参考文件）

**A. 布局与命名**——触发器在最左，主线从左到右同一水平带；相邻节点 x 间距 ≥220、y 间距 ≥110，坐标取 20 的倍数；错误分支统一向下；无连线交叉；节点名 = 动词 + 业务对象、中文优先（术语可保留英文），禁用 `HTTP Request 1` 式默认名。

**B. Code 节点风格**——能用内置节点（Set、Item Lists、Sort、Aggregate）表达的不写 Code；Run Once for All Items 必须 return items 数组；Happy Path First；分区注释；禁硬编码密钥（走 `$env` / credentials）。

**C. 异常体检**——执行历史看失败聚类和耗时趋势；静态检查四查失效引用（引用不存在节点 / 引用 disabled 节点 / 孤儿连接 / 字段级失效）；pinData 残留、矛盾配置（retryOnFail + continueOnFail 同开）等杂项。

**D. Prompt 瘦身**——默认保守档：只删零信息开场白、合并字面重复约束，信号词只增不删、不动结构语序；重构档需用户明确提出。任何改动先出「前后对比预览」并经用户确认才落地；保留业务上下文、few-shot、边界条件、输出 schema 和 `{{ }}` 表达式。

**E. Agent 工具编排**——工具调用链设计三问（顺序依赖、断链兜底、输入质量）+ 链式依赖设计底线（不把下一步输入押在第一步命中率上）；**职责分离：工具描述只写工具本身与参数（优先用节点默认描述），触发时机/调用顺序/兜底链全部集中在 Agent 的 system prompt，禁止下沉到工具描述**；$fromAI 参数三查（参数名达意、描述非空、约束写全）；数据分层场景查检索覆盖缝隙（摘要层丢原词、原始层过滤维度单一 = 数据存在却永远取不到）；Agent 执行取证五步法（调没调/入参是什么/返回几条/声称 vs 实际/错误签名对照表）；检索依赖型 Agent 的 system prompt 可复用骨架。

**F. 工作流检查/评分**——逐节点过下方「检查/评分总清单」，按命名/参数/历史运行/业务编排四维各 10 分打分（总分 40）；每个扣分项必须有明确信号和依据（节点+位置+依据+扣分）；字段级失效按"确定/疑似/待验证"分级计分；无执行历史时历史维度记 N/A 按 30 分制。

## 检查/评分总清单（检查、体检、评分任务必过）

逐节点核对下表，**逐项留痕（命中/未命中），禁止抽样或凭印象**。判定细则（字段级失效三级判定、样本量、报告模板）见 [references/scoring.md](references/scoring.md)。

### 命名（10 分）
- [ ] 无默认名（`HTTP Request 1` / `Set 2` / `IF 3` / `Code 1` 式）——每个 -1
- [ ] 名字均为"动词 + 业务对象"——纯技术描述（"转换"/"处理"式）每个 -1
- [ ] 中文命名（专业名词/技术术语可保留英文）——`tool_search_memory` 式英文造句每个 -0.5
- [ ] 同类节点有限定词区分——`xxx 1` / `xxx 2` 式每个 -0.5
- [ ] 无超 15 字长名——每个 -0.5
- [ ] 工作流名 = `[业务域] – 描述`——否则 -1

### 参数（10 分）
- [ ] 无失效节点引用（`$node["X"]` / `$('X')` 目标都在节点列表中）——每个 -2
- [ ] 无孤儿连接（connections 无指向不存在节点）——每个 -2
- [ ] 无字段级失效（被引用属性在上游输出结构中存在）——确定每个 -1.5，疑似 -0.5，待验证列出不扣
- [ ] 表达式语法正确（`{{ }}` 闭合、括号匹配）——每个 -1
- [ ] 无引用 disabled 节点——每个 -1
- [ ] 无矛盾配置（如 `retryOnFail` + `continueOnFail` 同开）——每个 -1
- [ ] 无 pinData 残留——每个 -0.5
- [ ] $fromAI 参数名达意且描述非空——每个 -0.5
- [ ] 无空参数节点（无配置且无连接）——每个 -0.5

### 历史运行（10 分）
- [ ] 成功率 100%——95-99% -1 / 90-94% -2 / 80-89% -4 / <80% -6
- [ ] 无反复出现的错误签名（≥3 次）——每个 -1（上限 -2）
- [ ] 失败不集中单一节点——否则 -1
- [ ] 无耗时突增（近期达历史均值 3 倍）——否则 -1
- [ ] 已激活工作流无未发布的草稿修复——否则 -1

### 业务编排（10 分）
- [ ] Code 节点无"Set/Edit Fields 可替代"的字段映射——每个 -1
- [ ] 无跨节点复制粘贴的逻辑块（应抽 Sub-workflow）——每处 -1
- [ ] 循环内无逐条调外部 API（可批处理）——每处 -1
- [ ] Agent 工具链有断链兜底路径——每条链 -1
- [ ] 节点数 ≤15 或已评估拆分——超 15 -1，超 25 -2
- [ ] 画布无连线交叉 / 节点重叠 / 主线不对齐——每项 -0.5（上限 -1.5）

> 错误处理配置（error output / retry / error workflow）只作提示项，不纳入评分——列入报告提示区即可。

## 输出规范

### 检查报告（只读场景：检查/体检/评分）

统一用 [references/report-spec.md](references/report-spec.md) 的六区格式（结论区 → 必须修复区 → 得分区 → 节点区 → 提示区 → 行动区），写完对照其「写作纪律」自检：篇幅与问题数成正比、通过节点合并、每行信息自足、不写分析过程。

### 修改产物（改动类场景）

1. **变更清单表**：节点 | 操作（移动/重命名/移除/改参数）| 旧值 → 新值
2. MCP 路径：先 `validateOnly` 结果，用户确认后才正式应用，应用后回报成功/失败明细
3. 粘贴路径：输出修改后的完整 workflow JSON + 变更点摘要

## 参考文件索引

| 场景 | 文件 | 何时读 |
|------|------|--------|
| A | [references/layout-and-naming.md](references/layout-and-naming.md) | 布局整理、命名审查、重命名操作前 |
| B | [references/code-style.md](references/code-style.md) | 审查/编写 Code 节点（JS/Python）时 |
| C | [references/anomaly-check.md](references/anomaly-check.md) | 体检、排障、失效引用检查时 |
| D | [references/prompt-polish.md](references/prompt-polish.md) | 优化 LLM 节点提示词时 |
| E | [references/agent-tool-orchestration.md](references/agent-tool-orchestration.md) | 设计/审查 Agent 工具调用、检索类工具不命中时 |
| F | [references/scoring.md](references/scoring.md) | 检查/评分的判定细则：字段级失效三级判定、样本要求、定级 |
| 报告 | [references/report-spec.md](references/report-spec.md) | 产出检查/评分报告时：六区格式与写作纪律 |
