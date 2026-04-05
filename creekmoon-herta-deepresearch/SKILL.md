---
name: creekmoon-herta-deepresearch
version: 3.0.0
description: 用于复杂场景级问题的标准深度研究规范。遇到需要跨代码、配置、文档、接口、上下游做系统性取证，并要求子代理参与、研究过程落盘、事实可追溯、结果可量化校验、最终由主 agent 统一出具研究报告的任务时，必须使用本 skill。用户显式调用时必须触发；即使未点名，只要任务明显要求深度研究而不是快速回答，也应主动使用。不适用于普通问答、单文件解释、简单修 bug、快速结论。
---

# Herta 深度研究规范

> 本 skill 只定义一套标准深度研究作业法。进入后不再切换姿态，不再做主类型判断，不再做读者模式判断，不再切换并行策略。

## 固定原则

- 深度研究必须有子代理参与
- 研究阶段的正式产物必须落盘到 `.herta-deepresearch-temp/`
- 研究阶段只交事实、证据、冲突和未确认，不交最终报告
- 主 agent 负责归并、量化校验和最终报告
- 没有通过量化校验，不算完成
- 最终报告必须是读者可读的成稿，不是研究台账
- 最终报告默认采用对象中心、渐进展开、图示辅助的写法

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
  50-report/final-report.md
  60-validation/scorecard.md
```

规则：
- 以上文件缺失，视为研究未完成
- 子代理的正式交付以落盘文件为准，不以消息摘要替代
- 主 agent 只能基于这些落盘产物做整合，不要直接拿零散上下文硬拼报告

## 固定事实标准

研究阶段必须读取并遵守：
- `contracts/evidence-pack.md`
- `contracts/conclusion-pack.md`
- `contracts/report-contract.md`
- `contracts/research-scorecard.md`
- `references/search-playbook.md`

其中：
- `evidence-pack.md` 是研究事实标准
- `conclusion-pack.md` 是主 agent 归并标准
- `report-contract.md` 是最终报告标准
- `research-scorecard.md` 是量化校验标准

## 固定提示词

研究阶段固定使用以下提示词，不临场发明流程：
- `agents/exploration-scout.md`
- `agents/logic-tracer.md`
- `agents/structure-mapper.md`
- `agents/relation-analyst.md`
- `agents/gap-auditor.md`

职责固定：
- `exploration-scout` 负责铺证据地图、识别研究对象、建立读者入口和图示热点
- `logic-tracer` 负责主流程、关键判断、默认与回退，并供给链路/状态图线索
- `structure-mapper` 负责结构、配置、字段、约束，并供给对象层级/结构图线索
- `relation-analyst` 负责参与方、边界、依赖、责任，并供给关系图/责任边界图线索
- `gap-auditor` 负责反向审查、降级结论、保留未确认，并阻止对象叙事和图示过度表达

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

6. `Report`
   - 主 agent 按 `contracts/report-contract.md` 写 `50-report/final-report.md`
   - 最终报告必须由主 agent 完成，不交给子代理代写
   - 报告默认从宏观到微观推进：先让读者看懂对象与全景，再进入链路、规则、例外和风险
   - 报告必须至少包含一张能帮助读者建立全景的图；图型按场景选择，不得为了装饰凑图

7. `Validation`
   - 主 agent 按 `contracts/research-scorecard.md` 生成 `60-validation/scorecard.md`
   - 若未通过，返回前面阶段修正，直到通过为止

## 强约束

- 不要让一个子代理包办整条研究链
- 不要跳过 `scout` 直接进入结论写作
- 不要让研究子代理直接写最终报告
- 不要把消息里的临时分析当成正式研究产物
- 不要把命名相似、注释暗示、局部片段直接抬升为主结论
- 不要把未确认内容伪装成结论
- 不要在未完成 `scorecard` 前宣布研究结束
- 不要把最终报告写成“我查了哪些文件”的台账
- 不要把图示当成装饰，而不让它服务主判断

## 完成标准

只有同时满足以下条件，才算完成一次深度研究：
- 固定工作区中的必备文件全部存在
- `40-synthesis/conclusion-pack.md` 已稳定写出主线和决定性规则
- `50-report/final-report.md` 已由主 agent 完成
- `60-validation/scorecard.md` 全部通过
- 报告中的每个主判断都能回溯到证据锚点
- 报告已经围绕研究对象形成可读的渐进式成稿，而不是只剩技术台账

## 结果自检清单

- [ ] `00-scene.md` 已明确场景问题、起点、终点、输入、输出、范围外事项
- [ ] `10-exploration/scout.md` 已给出覆盖面、热点和后续重点
- [ ] `20-evidence/` 下三份研究件已分别落盘
- [ ] `30-verification/gap-audit.md` 已写出冲突、缺口或降级意见
- [ ] `40-synthesis/conclusion-pack.md` 已写出 `3-5` 条决定性规则
- [ ] `40-synthesis/conclusion-pack.md` 已稳定出对象主角、阅读推进和图示计划
- [ ] `50-report/final-report.md` 已先拉住读者，再给全景图，再给对象主线与规则展开
- [ ] `60-validation/scorecard.md` 已记录量化指标并全部通过
- [ ] 最终报告中的主判断都能在 `conclusion-pack` 与证据锚点中回溯

## 一句话原则

**深度研究不是“多查一点”，而是固定用子代理取证、固定把研究落盘、固定按事实标准归并、固定做量化校验，最后由主 agent 把复杂事实写成有人愿意读的正式报告。**