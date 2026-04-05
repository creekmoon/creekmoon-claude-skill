# Research Scorecard Contract

`scorecard` 是本次深度研究的量化验收单，必须由主 agent 生成。

## 强约束

- 必须写入 `.herta-deepresearch-temp/{task}/60-validation/scorecard.md`
- `scorecard` 在 `final-report.md` 写完后生成
- 任一必备项未通过，都不能宣布研究完成

## 必备文件检查

以下文件必须全部存在：

| 文件 | 通过条件 |
|------|----------|
| `00-scene.md` | 存在 |
| `10-exploration/scout.md` | 存在 |
| `20-evidence/logic-tracer.md` | 存在 |
| `20-evidence/structure-mapper.md` | 存在 |
| `20-evidence/relation-analyst.md` | 存在 |
| `30-verification/gap-audit.md` | 存在 |
| `40-synthesis/conclusion-pack.md` | 存在 |
| `50-report/final-report.md` | 存在 |

## 量化指标

主 agent 必须在 `scorecard` 中逐项记录以下指标：

| 指标 | 统计方式 | 通过条件 |
|------|----------|----------|
| `research_subagent_outputs` | 统计已落盘的研究子代理输出文件数：`scout + logic + structure + relation + gap-audit` | `= 5` |
| `facts_total` | 统计 `scout.md` 与 `20-evidence/*.md` 中 `Facts` 表的总条目数 | `>= 12` |
| `candidate_rules_total` | 统计 `scout.md` 与 `20-evidence/*.md` 中 `Candidate Rules` 表的总条目数 | `>= 6` |
| `visual_clues_total` | 统计 `scout.md` 与 `20-evidence/*.md` 中 `Visual Clues` 表的总条目数 | `>= 3` |
| `challenge_items_total` | 统计 `gap-audit.md` 中 `Conflicts` 与 `Open Questions` 的总条目数 | `>= 3` |
| `decisive_rules_total` | 统计 `conclusion-pack.md` 中 `Decisive Rules` 的条目数 | `>= 3` 且 `<= 5` |
| `min_anchor_per_decisive_rule` | 统计每条决定性规则的最少证据锚点数，取最小值 | `>= 2` |
| `visual_plan_items_total` | 统计 `conclusion-pack.md` 中 `Visual Plan` 的条目数 | `>= 1` |
| `first_screen_rule_count` | 统计 `final-report.md` 中 `最值得先记住的三件事` 的条目数 | `= 3` |
| `diagram_blocks_total` | 统计 `final-report.md` 中的图示代码块数量，优先按 `mermaid` 代码块统计 | `>= 1` |
| `object_section_exists` | 检查 `final-report.md` 是否存在 `## 对象入场：` 章节 | `= yes` |
| `trace_rows_total` | 统计 `final-report.md` 中 `证据回溯表` 的数据行数 | `>= 4` |
| `trace_rows_with_anchor` | 统计 `证据回溯表` 中锚点不为空的数据行数 | `= trace_rows_total` |

## 推荐输出格式

```markdown
## File Checklist
| 文件 | Exists | Pass |
|------|--------|------|

## Metrics
| 指标 | 值 | 通过条件 | Pass |
|------|----|----------|------|

## Result
- PASS / FAIL

## Fix List
- 如果 FAIL，列出需要回改的文件和原因
```

## 一句话原则

**没有量化验收单，就不能把这次工作称为深度研究完成；没有图示、对象中心和首屏阅读牵引，也不应算合格成稿。**
