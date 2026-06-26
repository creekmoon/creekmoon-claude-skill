# Research Scorecard Contract

`scorecard` 是本次深度研究的量化验收单，必须由主 agent 生成。

## 强约束

- 必须写入 `.herta-deepresearch-temp/{task}/60-validation/scorecard.md`
- `scorecard` 在 `final-report.md` 写完后生成
- 任一必备项未通过，都不能宣布研究完成

## 设计原则

研究层指标保持稳定（这是本 skill 取证质量的护栏）。

报告层指标**不再卡固定模板**：不要求恰好三条判断、不要求必须有业务全景图、不要求必须有生命周期/模块对接/为什么这样组织节。报告层只卡一件事——**这份报告有没有贴合用户的真实诉求、把每个问题正面答到、且不像套模板。**

## 必备文件检查

以下文件必须全部存在：

| 文件 | 通过条件 |
|------|----------|
| `00-scene.md` | 存在，且记录了用户原始诉求与问题清单 |
| `10-exploration/scout.md` | 存在 |
| `20-evidence/logic-tracer.md` | 存在 |
| `20-evidence/structure-mapper.md` | 存在 |
| `20-evidence/relation-analyst.md` | 存在 |
| `30-verification/gap-audit.md` | 存在 |
| `40-synthesis/conclusion-pack.md` | 存在 |
| `45-report-blueprint/report-blueprint.md` | 存在 |
| `50-report/final-report.md` | 存在 |

## 研究阶段量化指标

主 agent 必须在 `scorecard` 中逐项记录：

| 指标 | 统计方式 | 通过条件 |
|------|----------|----------|
| `research_subagent_outputs` | 已落盘研究子代理输出文件数：`scout + logic + structure + relation + gap-audit` | `= 5` |
| `facts_total` | `scout.md` 与 `20-evidence/*.md` 中 `Facts` 表总条目数 | `>= 12` |
| `candidate_rules_total` | `scout.md` 与 `20-evidence/*.md` 中 `Candidate Rules` 表总条目数 | `>= 6` |
| `challenge_items_total` | `gap-audit.md` 中 `Conflicts` 与 `Open Questions` 总条目数 | `>= 3` |
| `decisive_rules_total` | `conclusion-pack.md` 中 `Decisive Rules` 条目数 | `>= 3` 且 `<= 5` |
| `min_anchor_per_decisive_rule` | 每条决定性规则的最少证据锚点数取最小值 | `>= 2` |

## 蓝图层量化指标

| 指标 | 统计方式 | 通过条件 |
|------|----------|----------|
| `blueprint_intent_declared` | `report-blueprint.md` 的 `Intent Read` 是否明确写出报告范式（不含糊） | `= yes` |
| `blueprint_ask_map_exists` | 是否存在 `Ask Map`，且覆盖用户每个显式问题 | `= yes` |
| `blueprint_outline_exists` | 是否存在 `Derived Outline`，且每节标注了存在理由 | `= yes` |
| `blueprint_first_screen_exists` | 是否存在 `First Screen` 底稿，且最核心结论直接命中用户诉求 | `= yes` |
| `blueprint_trace_map_exists` | 是否存在 `Trace Map` 表，含至少 2 行数据 | `= yes` |

## 最终报告量化指标（意图无关）

| 指标 | 统计方式 | 通过条件 |
|------|----------|----------|
| `asks_total` | 蓝图 `Ask Map` 中用户显式问题数 | `>= 1` |
| `asks_answered_directly` | 这些问题中，能在报告正文找到正面明确回答的数量 | `= asks_total` |
| `main_conclusion_upfront` | 第一屏是否直接给出针对用户最核心问题的结论（而非先写"这件事是什么"的背景） | `= yes` |
| `outline_is_intent_driven` | 报告目录是否对应蓝图 `Derived Outline`，由本次问题推导，而非套固定业务模板 | `= yes` |
| `no_template_tics` | 报告是否避免了无意义的套模板栏目（在非业务理解范式里出现"先看懂这件事/一张图先看整体/最值得先记住的三件事"等固定栏目即判失败） | `= yes` |
| `not_generic_template` | 抠掉具体内容后，报告框架是否仍"放任何项目都成立"（是则失败） | `= no` |
| `diagrams_serve_understanding` | 报告里出现的每张图是否都服务理解（无装饰图、无凑数图）；一张图都没有但意图本就不需要图，也算通过 | `= yes` |
| `first_screen_no_code_identifiers` | 第一屏是否出现类名/方法名/枚举值/接口路径（产品名如 Kafka/MongoDB 不计入） | `= no` |
| `report_has_no_unconfirmed_section` | 报告是否不存在 `未确认`/`待验证`/`To Verify`/`Open Questions` 栏目或同义表达 | `= yes` |
| `trace_rows_total` | 报告 `证据回溯表` 数据行数 | `>= 4` |
| `trace_rows_with_anchor` | `证据回溯表` 中锚点不为空的行数 | `= trace_rows_total` |

## 报告文风与审美指标

这组指标卡"读起来像不像人写的"，对照 `references/report-craft.md`：

| 指标 | 统计方式 | 通过条件 |
|------|----------|----------|
| `headings_calm` | 把所有章节标题列出来看：是否以克制名词短语为主，无导览腔（"先给你/会不会/能不能/各自是什么/能做什么不能指望什么"）、无默认问句标题 | `= yes` |
| `prose_backbone` | 是否每个主要章节都有真正的散文骨架，而不是只有表格/列表/代码块 | `= yes` |
| `bold_restraint` | 是否没有满屏加粗（抽查段落，每段加粗 `<= 2` 处） | `= yes` |
| `not_table_wall` | 删掉全部表格与列表后，剩下的散文是否仍能基本读成文（不是拼盘） | `= yes` |
| `no_assistant_voice` | 是否避免助手腔（"我们可以看到""值得注意的是""综上所述"）与 ✅❌ 当正文主力 | `= yes` |

说明：
- `diagram_blocks_total` 不再设硬下限。是否需要图、需要几张，由意图决定；评分只看"出现的图是否都服务理解"。
- 不再检查 `panorama_diagram_exists` / `lifecycle_or_module_section_exists` / `why_section_exists` / `first_screen_judgment_count = 3`。这些是业务理解范式的特征，不应强加给所有报告。

## 推荐输出格式

```markdown
## File Checklist
| 文件 | Exists | Pass |
|------|--------|------|

## Research Metrics
| 指标 | 值 | 通过条件 | Pass |
|------|----|----------|------|

## Blueprint Metrics
| 指标 | 值 | 通过条件 | Pass |
|------|----|----------|------|

## Report Quality Metrics
| 指标 | 值 | 通过条件 | Pass |
|------|----|----------|------|

## Report Craft Metrics
| 指标 | 值 | 通过条件 | Pass |
|------|----|----------|------|

## Result
- PASS / FAIL

## Fix List
- 如果 FAIL，列出需要回改的文件和原因
```

## 一句话原则

**取证质量按固定护栏卡；报告质量只卡一件事——是否贴合用户真实诉求、每个问题正面答到、且不是套模板，而不是卡有没有按业务叙事模板填满章节。**
