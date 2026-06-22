# creekmoon-claude-skill

面向 Claude / Cursor 的技能集合，用来约束 AI 在写文档、写代码、分析项目时的输出风格、信息密度和交付颗粒度。

## 这个仓库解决什么问题

不同场景下，AI 很容易出现这些问题：

- 写 PRD 太技术化，业务方看不懂
- 一句话需求难以展开成完整功能方案，交互和边界要靠人反复补
- 写 TRD 只罗列模块，没有真正讲清接口和边界
- 写代码时风格不稳定，方法拆分和命名忽左忽右
- 接手老项目时只会读代码，不会沉淀可复用的项目记忆
- 周报、接口文档这类重复性文档，每次都要重新组织格式
- vibe coding 生成的页面“能用但不好用”，元素堆砌、信息层级混乱、数据指标无关联
- 长线编程任务多轮迭代后容易偏离产品方向，AI 不断抛选择题，决策负担回到人身上

这个仓库把这些场景拆成独立 skill，按需接入即可。

## 包含的技能

| 目录 | 作用                                                  | 典型场景                 |
|------|-----------------------------------------------------|----------------------|
| `creekmoon-prd-spec` | PRD 写作规范，强调大白话、图表优先、面向业务沟通                          | 写需求文档、方案说明、业务评审材料    |
| `creekmoon-topaz-pm` | 战术 PRD 与交互方案技能，基于 JTBD、Persona、场景补全和交互模式，把一句话需求展开为可落地的功能 PRD | 写功能 PRD、设计登录/看板/引导模块、补充用户故事、原型或交互方案 |
| `creekmoon-trd-spec` | TRD 写作规范，聚焦架构、模块、接口契约，不展开代码细节                       | 写技术方案、接口边界、模块设计      |
| `creekmoon-code-style` | 代码风格规范，统一方法设计、入参组织、命名和流程表达                          | 写代码、重构、补实现           |
| `riper5` | 严格执行协议，约束 AI 先研究后实施，避免未授权直接改代码                          | 用户明确要求“执行 riper5”、需要高约束协作 |
| `creekmoon-fuxuan-testcase` | 测试用例设计规范，覆盖冒烟测试、分支测试与接口测试模式，强调数据驱动与可维护性         | 编写测试用例、评审覆盖率、设计冒烟测试集 |
| `creekmoon-lightcone-memory` | 项目记忆系统，用高信息密度文档沉淀业务图谱和关键代码上下文                       | 接手项目、分析项目、建立长期记忆     |
| `creekmoon-herta-deepresearch` | 面向复杂业务场景做高强度深度研究，交叉整合代码逻辑、静态结构、配置规则与业务关系，输出证据化结论 | 复杂链路梳理、系统行为追因、业务与技术口径对齐、疑难场景深挖 |
| `creekmoon-weekly-report` | 从 Git 提交中提炼开发活动，生成结构化《项目周报-开发维度》                    | 周报、阶段汇报、研发活动归纳       |
| `creekmoon-cerydra-codex` | 从现有代码中提炼开发规则，生成可复用规则文件（xxx_rule.md）                  | 整理模块规范、抽取通用规则、沉淀团队约定 |
| `creekmoon-trailblazer-readme` | 生成或重构根目录 README，业务链路优先，让新人快速建立项目心智模型               | 新项目 README、重构 README、补充业务流程说明 |
| `creekmoon-apidoc-spec` | 标准化接口文档规范，统一概述、版本、环境、请求/响应、示例结构                     | 对外接口文档、开放平台文档、资源接口说明 |
| `creekmoon-aglaea-design` | 产品页面体验与信息架构评审，以资深产品经理 + UX 设计师视角输出诊断报告和改进方案，不承担代码实现 | 审查 vibe coding 页面、评估看板/控制台/详情页、页面重构评审、交接后续改造 |
| `creekmoon-himeko-auto-decision` | 长线任务的自动决策引擎，按激进/均衡/保守模式扫描产品文档、量化漂移并全权裁决下一步，不抛问题给人 | 多轮迭代开发、指定决策模式、需要 AI 自主排优先级与控范围蔓延 |

## 快速安装

运行以下一键命令，会启动交互式安装程序，引导你选择安装位置和要安装的 skill。

安装器会自动发现仓库顶层所有包含 `SKILL.md` 的 skill 目录，因此新增 skill（包括 `riper5`）无需单独修改安装脚本。

### Windows（CMD / PowerShell）

```cmd
curl -fsSL https://gitee.com/creekmoon/creekmoon-claude-skill/raw/master/autoUpdateSkill.cmd -o install.cmd && install.cmd && del install.cmd
```

> 需要系统已安装 `curl`（Windows 10 1803+ 内置）。

### macOS / Linux（bash / zsh）

```bash
curl -fsSL https://gitee.com/creekmoon/creekmoon-claude-skill/raw/master/autoUpdateSkill.sh -o /tmp/install.sh && bash /tmp/install.sh && rm -f /tmp/install.sh
```

> 需要系统已安装 `curl` 和 `git`（macOS 自带；Linux 按需 `brew/apt/yum install git curl`）。

## 使用方式

1. 把目标目录下的 `SKILL.md` 配置到 Claude 或 Cursor 的 skill 能力中。
2. 在对应场景触发 skill，例如写 PRD、补 TRD、接手项目、生成周报、整理 API 文档、审查页面体验；如果要启用 `riper5`，请明确说明“执行 riper5”；长线任务可指定“激进模式”“均衡模式”或“保守模式”启用 `creekmoon-himeko-auto-decision`。
3. 如果是从一句话需求展开完整功能方案，建议先用 `creekmoon-topaz-pm` 产出战术 PRD 与交互决策；若还需要统一业务向文档风格，再叠加 `creekmoon-prd-spec` 做格式约束。
4. 如果是代码相关任务，通常建议组合使用：

- 先用 `creekmoon-lightcone-memory` 建立项目上下文
- 再用 `creekmoon-code-style` 约束具体实现风格

5. 如果是页面体验问题，建议先用 `creekmoon-aglaea-design` 产出评估报告（含信息架构、数据链路、认知负荷、可执行清单），再交给后续实现 skill 或开发按报告改造。

6. 如果是多轮迭代的编程任务，建议：

- 在 README 或 `项目规划.md` / `ROADMAP.md` 中写明产品方向锚点（核心目标、红线、完成标准）
- 启用 `creekmoon-himeko-auto-decision`，事先指定决策模式；AI 会按漂移分自主裁决优先级，每次输出决策摘要

## 目录变化说明

项目记忆能力已从旧版 `creekmoon-project-memory` 升级为 `creekmoon-lightcone-memory`。

- 旧版强调分层索引和渐进式沉淀
- 新版强调高信息密度文档、业务图谱、跨模块约束和隐式依赖
- 新版默认使用 `.light-cone/` 作为项目记忆目录

如果你之前已经基于旧目录结构使用过项目记忆能力，建议逐步迁移到 `creekmoon-lightcone-memory`。

业务场景深度研究能力已从 `creekmoon-scenario-research` 更名为 `creekmoon-herta-deepresearch`。

- 目录名与触发名统一切换为 `creekmoon-herta-deepresearch`
- 能力定位不变，仍然用于复杂业务场景的高强度深度研究
- 如果你之前引用过旧名字，建议同步改为新名字

## 适合谁用

- 需要让 AI 稳定输出文档和代码的团队
- 希望从一句话需求快速展开功能 PRD、交互方案和原型说明的产品/设计同学
- 希望把“AI 怎么写”沉淀成可复用规则的人
- 经常接手存量项目、需要快速建立上下文的人
- 需要固定格式周报、接口文档、方案文档的项目团队
- 用 AI 生成后台页面、看板、详情页，但希望先诊断“为什么不好用”再动手改的团队
- 长线 vibe coding 或 agent 协作中，希望 AI 围绕产品方向自主决策、减少反复确认的团队

## 当前状态

持续迭代中。后续会继续围绕“文档规范化、战术 PRD 与交互方案、代码风格统一、项目长期记忆、页面体验评审、长线任务自主决策”补充更多 skill。
