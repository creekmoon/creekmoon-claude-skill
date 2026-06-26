---
name: creekmoon-herta-deepresearch
version: 5.1.0
description: 用于复杂场景级问题的标准深度研究规范。遇到需要跨代码、配置、文档、接口、上下游做系统性取证，并要求子代理参与、研究过程落盘、事实可追溯、结果可量化校验、最终由专门撰稿角色出具贴合诉求报告的任务时，必须使用本 skill。用户显式调用时必须触发；即使未点名，只要任务明显要求深度研究而不是快速回答，也应主动使用。不适用于普通问答、单文件解释、简单修 bug、快速结论。
---

# Herta 深度研究规范

> 本 skill 定义一套标准深度研究作业法。取证阶段多角度、尽量全；报告阶段由专门的撰稿官先判定意图、再从用户真实问题推导目录，写成贴合诉求、不套模板的报告。

## 固定原则

- 深度研究必须有子代理参与
- 研究阶段的正式产物必须落盘到 `.herta-deepresearch-temp/`
- 研究阶段只交事实、证据、冲突和未确认；未确认只属于准出审查，不进入最终报告
- 主 agent 负责归并、量化校验与把关；报告由专门的 `report-composer`（撰稿官）角色产出
- 没有通过量化校验，不算完成
- 报告结构由用户这次的诉求意图决定，不套固定模板：先判意图，再从用户问题推导目录
- 最终报告的首要目标是把用户的每个显式问题正面答到，且读起来不像 AI 套模板
- 审查层的职责是踩刹车：拦住证据不足的判断，不给最终报告留 `To Verify` 兜底栏目

## 何时触发

以下情况应进入本 skill：
- 需要解释一个复杂场景从输入到结果是如何运转的
- 需要同时查看代码、配置、文档、接口、上下游关系中的两类或以上证据
- 需要把事实、规则、例外、风险和未确认分层审查，并把未确认拦在最终报告之外
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
  45-report-blueprint/report-blueprint.md   ← 固定必经，报告蓝图层产物
  50-report/final-report.md
  60-validation/scorecard.md
```

规则：
- 以上文件缺失，视为研究未完成
- 子代理的正式交付以落盘文件为准，不以消息摘要替代
- 归并只能基于这些落盘产物，不要直接拿零散上下文硬拼报告
- `00-scene.md` 必须记录用户原始诉求原话与显式问题清单，供报告层判意图、答问题
- `45-report-blueprint/report-blueprint.md` 是报告蓝图层的固定输出，是写 `final-report` 的唯一输入底稿

## 固定事实标准

研究阶段必须读取并遵守：
- `contracts/evidence-pack.md`
- `contracts/conclusion-pack.md`
- `contracts/report-blueprint.md`
- `contracts/report-contract.md`
- `contracts/research-scorecard.md`
- `references/search-playbook.md`
- `references/report-archetypes.md`
- `references/report-craft.md`

其中：
- `evidence-pack.md` 是研究事实标准
- `conclusion-pack.md` 是主 agent 归并标准
- `report-blueprint.md` 是报告蓝图标准（先判意图、再从用户问题推导目录）
- `report-contract.md` 是最终报告标准（意图自适应 + 去 AI 腔）
- `research-scorecard.md` 是量化校验标准
- `report-archetypes.md` 是报告范式库（撰稿官判意图、推目录的参考）
- `report-craft.md` 是报告审美与文风标准（标题安静、加粗克制、散文牵线、循序渐进）

## 固定提示词

研究与报告阶段固定使用以下提示词，不临场发明流程：
- `agents/exploration-scout.md`
- `agents/logic-tracer.md`
- `agents/structure-mapper.md`
- `agents/relation-analyst.md`
- `agents/gap-auditor.md`
- `agents/report-composer.md`

职责固定：
- `exploration-scout` 负责铺证据地图、识别研究对象、建立读者入口和图示热点
- `logic-tracer` 负责主流程、关键判断、默认与回退，并供给链路/状态图线索
- `structure-mapper` 负责结构、配置、字段、约束，并供给对象层级/结构图线索
- `relation-analyst` 负责参与方、边界、依赖、责任，并供给关系图/责任边界图线索
- `gap-auditor` 负责反向审查、降级结论、保留未确认并给出准出意见，阻止对象叙事和图示过度表达
- `report-composer`（撰稿官）负责报告层全程：读用户原始诉求 → 判定报告意图 → 从用户问题推导目录 → 输出 `report-blueprint` → 据此写成贴合诉求、不套模板的 `final-report`

## 唯一工作流

1. `Scene`
   - 主 agent 把任务收敛成一个场景，写入 `00-scene.md`
   - 至少写清：研究问题、起点、终点、输入、输出、参与方、范围外事项
   - 必须原话记录用户的原始诉求，并逐条拎出用户的显式问题清单（报告层据此判意图、答问题）

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
   - 只保留稳定主线、决定性规则、例外、风险，以及仅供准出审查的未确认
   - 必须填好 `Asks`：逐条列出用户显式问题及当前研究给出的答案，供报告层映射

6. `Report Blueprint`（固定必经，撰稿官第一步）
   - 调用 `agents/report-composer.md`
   - 输入：`00-scene.md`（用户原始诉求）+ `40-synthesis/conclusion-pack.md`，必要时回看 `20-evidence/`
   - 输出：`45-report-blueprint/report-blueprint.md`
   - 目标：先判定报告意图（事实确认/决策支持/机制解释/业务理解/风险/对比/排查/混合），再从用户问题推导出贴合本次诉求的目录，规划按需图示
   - 蓝图层不引入新的研究事实，只做意图判定、问题映射、目录推导、图示规划、阅读引导
   - 蓝图层必须剔除未确认项；研究边界只写覆盖范围与影响，不转抄待验证问题

7. `Report`（撰稿官第二步）
   - 由 `report-composer` 撰稿官按 `contracts/report-contract.md` 写 `50-report/final-report.md`
   - 报告只消费 `45-report-blueprint/report-blueprint.md`，不直接展开 `conclusion-pack`
   - 报告结构用蓝图的 `Derived Outline`，由本次意图决定，不套固定模板
   - 第一屏直接回答用户最核心的问题；用户每个显式问题正文都要正面答到
   - 图按需出现，不为凑数而画；技术说明仅以轻量注记穿插，不发展成独立技术叙事
   - 主 agent 负责把关：发现套模板、答非所问、漏答问题，退回撰稿官重写
   - 最终报告不设 `To Verify` / `未确认` 栏目；证据不足项只留在准出审查层

8. `Validation`
   - 主 agent 按 `contracts/research-scorecard.md` 生成 `60-validation/scorecard.md`
   - 若未通过，返回前面阶段修正，直到通过为止

## 强约束

- 不要让一个子代理包办整条研究链
- 不要跳过 `scout` 直接进入结论写作
- 不要跳过 `report-blueprint` 直接从 `conclusion-pack` 写 `final-report`
- 不要不判意图就默认套业务理解模板目录
- 不要写出"换个项目也能套用"的通用模板报告
- 不要漏答用户的显式问题，也不要让第一屏答非所问
- 不要为模板完整硬加用户没问的章节（全景图、生命周期、模块对接、为什么这样组织都按意图取舍）
- 不要强行凑"最值得先记住的三件事"
- 不要把报告写成"导览腔标题 + 满屏加粗 + 表格列表拼盘"：标题要安静（克制名词短语），每个主要章节要有散文骨架，循序渐进
- 不要把消息里的临时分析当成正式研究产物
- 不要把命名相似、注释暗示、局部片段直接抬升为主结论
- 不要把未确认内容伪装成结论
- 不要把未确认带进 `report-blueprint` 或 `final-report`，也不要改名后混入研究边界
- 不要在未完成 `scorecard` 前宣布研究结束
- 不要把最终报告写成"我查了哪些文件"的台账
- 不要在 `report-blueprint` 里引入任何未经研究阶段证实的新事实
- 不要为凑数而画图，也不要把图示当成装饰

## 完成标准

只有同时满足以下条件，才算完成一次深度研究：
- 固定工作区中的必备文件全部存在（含 `45-report-blueprint/report-blueprint.md`）
- `40-synthesis/conclusion-pack.md` 已稳定写出主线、决定性规则，并在 `Asks` 里逐条答了用户显式问题
- `45-report-blueprint/report-blueprint.md` 已明确判定报告意图、映射用户问题、推导出本次专属目录，并剔除未确认项
- `50-report/final-report.md` 已由 `report-composer` 完成，且只基于 `report-blueprint` 展开
- `60-validation/scorecard.md` 全部通过
- 报告中的每个主判断都能回溯到 `report-blueprint` 与证据锚点
- 报告已贴合用户诉求、正面答到每个显式问题，且不是套模板成稿

## 结果自检清单

- [ ] `00-scene.md` 已记录用户原始诉求原话与显式问题清单，并写清起点、终点、输入、输出、范围外事项
- [ ] `10-exploration/scout.md` 已给出覆盖面、热点和后续重点
- [ ] `20-evidence/` 下三份研究件已分别落盘
- [ ] `30-verification/gap-audit.md` 已写出冲突、缺口或降级意见
- [ ] `40-synthesis/conclusion-pack.md` 已写出 `3-5` 条决定性规则，并在 `Asks` 里答了用户每个显式问题
- [ ] `45-report-blueprint/report-blueprint.md` 已明确判意图、映射问题、推导目录（非套模板）
- [ ] `50-report/final-report.md` 第一屏直接命中用户最核心问题，目录由意图推导
- [ ] 用户每个显式问题都能在报告正文找到正面回答
- [ ] 报告抠掉具体内容后框架不"放任何项目都成立"（非套模板）
- [ ] 报告标题安静（无"先给你/会不会/能不能"导览腔与默认问句），每个主要章节有散文骨架，加粗克制
- [ ] 删掉报告里所有表格与列表后，剩下的散文仍能读成文（非拼盘）
- [ ] `60-validation/scorecard.md` 已记录量化指标并全部通过
- [ ] 最终报告中的主判断都能在 `report-blueprint` 与证据锚点中回溯
- [ ] 最终报告不包含 `To Verify` / `未确认` / `待验证` 栏目

## 一句话原则

**深度研究不是"多查一点"，而是固定用子代理取证、固定把研究落盘、固定按事实标准归并，最后由专门的撰稿官先认准用户这次到底要什么、再从问题推导目录，把研究结果写成"专门为这次问题写"、正面答到每个诉求、不套模板的正式报告。**
