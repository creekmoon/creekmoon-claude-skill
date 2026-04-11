---
name: creekmoon-herta-deepresearch
version: 4.0.0
description: 用于复杂场景级问题的标准深度研究规范。遇到需要跨代码、配置、文档、接口、上下游做系统性取证，并要求子代理参与、研究过程落盘、事实可追溯、结果可量化校验、最终由主 agent 统一出具研究报告的任务时，必须使用本 skill。用户显式调用时必须触发；即使未点名，只要任务明显要求深度研究而不是快速回答，也应主动使用。不适用于普通问答、单文件解释、简单修 bug、快速结论。
---

# Herta 深度研究规范

> 本 skill 定义一套标准深度研究作业法。取证阶段多角度、尽量全；报告阶段以业务理解为优先，帮技术人员看懂业务，而不是输出技术台账。

## 固定原则

- 深度研究必须有子代理参与
- 研究阶段的正式产物必须落盘到 `.herta-deepresearch-temp/`
- 研究阶段只交事实、证据、冲突和未确认，不交最终报告
- 主 agent 负责归并、报告整形、量化校验和最终报告
- 没有通过量化校验，不算完成
- 最终报告的目标是帮助技术人员理解业务，而不是输出规则清单或技术台账
- 最终报告以业务全景图、数据流转、生命周期和模块对接为主线，技术说明点到即止

## 何时触发

以下情况应进入本 skill：
- 需要解释一个复杂场景从输入到结果是如何运转的
- 需要同时查看代码、配置、文档、接口、上下游关系中的两类或以上证据
- 需要把事实、规则、例外、风险、未确认拆开讲清
- 需要输出可追溯、可复核的研究报告，而不是口头判断
- 用户显式要求使用深度研究 skill

以下情况不要触发：
- 普通问答
- 单个类、函数、字段、表的局部解释
- 简单报错排查或小范围修 bug
- 不要求证据归档和系统性整合的快速结论

## 固定工作区

进入研究后，主 agent 必须先创建并维护：

```text
.herta-deepresearch-temp/{task}/
  00-scene.md
  10-exploration/scout.md
  20-evidence/logic-tracer.md
  20-evidence/structure-mapper.md
  20-evidence/relation-analyst.md
  30-verification/gap-audit.md
  40-synthesis/conclusion-pack.md
  45-report-shaping/shaping-pack.md   ← 固定必经，报告整形层产物
  50-report/final-report.md
  60-validation/scorecard.md
```

规则：
- 以上文件缺失，视为研究未完成
- 子代理的正式交付以落盘文件为准，不以消息摘要替代
- 主 agent 只能基于这些落盘产物做整合，不要直接拿零散上下文硬拼报告
- `45-report-shaping/shaping-pack.md` 是报告整形层的固定输出，是写 `final-report` 的唯一输入底稿

## 固定事实标准

研究阶段必须读取并遵守：
- `contracts/evidence-pack.md`
- `contracts/conclusion-pack.md`
- `contracts/report-shaping-pack.md`
- `contracts/report-contract.md`
- `contracts/research-scorecard.md`
- `references/search-playbook.md`

其中：
- `evidence-pack.md` 是研究事实标准
- `conclusion-pack.md` 是主 agent 归并标准
- `report-shaping-pack.md` 是报告整形标准（将研究结论转换为业务理解底稿）
- `report-contract.md` 是最终报告标准
- `research-scorecard.md` 是量化校验标准

## 固定提示词

研究阶段固定使用以下提示词，不临场发明流程：
- `agents/exploration-scout.md`
- `agents/logic-tracer.md`
- `agents/structure-mapper.md`
- `agents/relation-analyst.md`
- `agents/gap-auditor.md`
- `agents/business-architecture-shaper.md`

职责固定：
- `exploration-scout` 负责铺证据地图、识别研究对象、建立读者入口和图示热点
- `logic-tracer` 负责主流程、关键判断、默认与回退，并供给链路/状态图线索
- `structure-mapper` 负责结构、配置、字段、约束，并供给对象层级/结构图线索
- `relation-analyst` 负责参与方、边界、依赖、责任，并供给关系图/责任边界图线索
- `gap-auditor` 负责反向审查、降级结论、保留未确认，并阻止对象叙事和图示过度表达
- `business-architecture-shaper` 负责把归并后的研究结论重组为业务理解底稿，输出 `shaping-pack`，供 writer 直接展开成稿

## 唯一工作流

1. `Scene`
   - 主 agent 把任务收敛成一个场景，写入 `00-scene.md`
   - 至少写清：研究问题、起点、终点、输入、输出、参与方、范围外事项

2. `Scout`
   - 调用 `exploration-scout`
   - 把第一轮广搜结果写入 `10-exploration/scout.md`
   - 目标是给出覆盖面、热点、研究对象、读者第一批问题和可视化热点，不是直接下总论

3. `Parallel Research`
   - 同时调用 `logic-tracer`、`structure-mapper`、`relation-analyst`
   - 研究结果分别写入 `20-evidence/logic-tracer.md`、`20-evidence/structure-mapper.md`、`20-evidence/relation-analyst.md`
   - 这一步必须并行执行，不做策略分支，不做数量分支
   - 三路研究除了查事实，还要分别给出能支撑最终成稿的对象视角、读者问题和图示线索

4. `Gap Audit`
   - 调用 `gap-auditor`
   - 把反向审查结果写入 `30-verification/gap-audit.md`
   - 目标是找证据缺口、冲突点、应降级结论，以及哪些对象叙事或图示会误导读者，而不是补写新报告

5. `Synthesis`
   - 主 agent 读取全部落盘研究件
   - 按 `contracts/conclusion-pack.md` 归并为 `40-synthesis/conclusion-pack.md`
   - 只保留稳定主线、决定性规则、例外、风险、未确认
   - 同时稳定出：报告主角是谁、读者第一屏该看见什么、应该用哪类图帮助理解

6. `Report Shaping`（固定必经）
   - 调用 `agents/business-architecture-shaper.md`
   - 输入：`40-synthesis/conclusion-pack.md` 与必要时回看 `20-evidence/`
   - 输出：`45-report-shaping/shaping-pack.md`
   - 目标：把研究结论重组为业务理解顺序，规划图示，提供业务化写作底稿
   - 整形层不引入新的研究事实，只做重排、归纳、图示规划、阅读引导

7. `Report`
   - 主 agent 按 `contracts/report-contract.md` 写 `50-report/final-report.md`
   - 最终报告必须由主 agent 完成，不交给子代理代写
   - 报告只消费 `45-report-shaping/shaping-pack.md`，不直接展开 `conclusion-pack`
   - 报告按业务理解顺序推进：是什么 → 整体业务形态 → 数据与业务流转 → 生命周期 → 模块对接 → 为什么这样组织
   - 技术说明仅以轻量注记形式穿插，不发展成独立技术叙事
   - 报告必须至少包含一张总览图，图型按业务理解需要选择

8. `Validation`
   - 主 agent 按 `contracts/research-scorecard.md` 生成 `60-validation/scorecard.md`
   - 若未通过，返回前面阶段修正，直到通过为止

## 强约束

- 不要让一个子代理包办整条研究链
- 不要跳过 `scout` 直接进入结论写作
- 不要跳过 `report-shaping` 直接从 `conclusion-pack` 写 `final-report`
- 不要让研究子代理直接写最终报告
- 不要把消息里的临时分析当成正式研究产物
- 不要把命名相似、注释暗示、局部片段直接抬升为主结论
- 不要把未确认内容伪装成结论
- 不要在未完成 `scorecard` 前宣布研究结束
- 不要把最终报告写成"我查了哪些文件"的台账
- 不要把最终报告写成以规则清单或技术边界为主线的技术分析报告
- 不要在 `shaping-pack` 里引入任何未经研究阶段证实的新事实
- 不要把图示当成装饰，而不让它服务业务理解

## 完成标准

只有同时满足以下条件，才算完成一次深度研究：
- 固定工作区中的必备文件全部存在（含 `45-report-shaping/shaping-pack.md`）
- `40-synthesis/conclusion-pack.md` 已稳定写出主线和决定性规则
- `45-report-shaping/shaping-pack.md` 已完成业务理解整形
- `50-report/final-report.md` 已由主 agent 完成，且只基于 `shaping-pack` 展开
- `60-validation/scorecard.md` 全部通过
- 报告中的每个主判断都能回溯到 `shaping-pack` 与证据锚点
- 报告已形成帮助技术人员理解业务的可读成稿，而不是技术台账

## 结果自检清单

- [ ] `00-scene.md` 已明确场景问题、起点、终点、输入、输出、范围外事项
- [ ] `10-exploration/scout.md` 已给出覆盖面、热点和后续重点
- [ ] `20-evidence/` 下三份研究件已分别落盘
- [ ] `30-verification/gap-audit.md` 已写出冲突、缺口或降级意见
- [ ] `40-synthesis/conclusion-pack.md` 已写出 `3-5` 条决定性规则
- [ ] `40-synthesis/conclusion-pack.md` 已稳定出对象主角、阅读推进和图示计划
- [ ] `45-report-shaping/shaping-pack.md` 已完成全景、流转、生命周期、模块对接、设计原因的规划
- [ ] `50-report/final-report.md` 已先建立全景，再展开流转与生命周期，再讲模块对接和设计原因
- [ ] `60-validation/scorecard.md` 已记录量化指标并全部通过
- [ ] 最终报告中的主判断都能在 `shaping-pack` 与证据锚点中回溯

## 一句话原则

**深度研究不是"多查一点"，而是固定用子代理取证、固定把研究落盘、固定按事实标准归并、固定经过报告整形，最后由主 agent 把复杂业务写成技术人员能看懂、能复述、能建立业务心智模型的正式报告。**
