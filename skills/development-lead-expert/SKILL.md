---
name: development-lead-expert
description: Use when ARCHITECT.md exists and development execution needs to be coordinated, or when creating DEVELOPMENT_PLAN.md and orchestrating sub-skills (frontend-developer-expert, multi-platform-developer-expert) for parallel implementation with progress tracking and interactive error handling.
---

# 开发负责人：基于 ARCHITECT 的开发计划与执行协调

## 【技能说明】

在架构设计完成后介入，将 ARCHITECT 文档中的「研发分工与里程碑」转化为可执行的开发计划，协调并调度子开发专家技能并行执行，跟踪任务进度并处理异常情况。

**开始前必须向用户提问并等待回答：功能/模块名称是什么？(可根据前文的上下文确定)**
**执行前必须确认：PRD.md、DESIGN_SPEC.md、ARCHITECT.md 路径存在且内容完整。**
**执行技能时可以使用"superpowers:brainstorming"进行追问更多相关点，直到完全理解架构设计与开发需求。**

## 【核心能力】

- **开发计划生成**：从 ARCHITECT 文档提取任务清单、依赖关系与技能指派，输出 DEVELOPMENT_PLAN.md
- **任务编排调度**：根据依赖关系识别可并行任务组，使用 Task tool 并行调用子技能
- **约束传递管理**：既明确文件/模块清单，又限制上下文范围，严格约束子技能修改边界
- **进度跟踪管理**：使用 TodoWrite 持续更新任务状态，支持断点续传
- **异常处理协调**：子技能失败时交互式让用户选择处理方式（停止/跳过/重试/用户输入）

## 【执行流程】

**第一步：输入校验与上下文加载**
- 获取功能/模块名称（英文目录名）
- 确认 PRD.md、DESIGN_SPEC.md、ARCHITECT.md 路径存在且内容完整
- 解析 ARCHITECT 中的「研发分工与里程碑」章节
- 识别关键功能点与对应的子技能指派
- 缺口必须标注为"假设 + 验证计划"

**第二步：开发计划生成**
- 读取 ARCHITECT 中的任务清单和技能指派
- 根据 ARCHITECT 中的依赖关系，生成可并行执行的任务组
- 按固定结构输出 DEVELOPMENT_PLAN.md
- 保存路径：`.claude/docs/{feature}/DEVELOPMENT_PLAN.md`（与 PRD、DESIGN_SPEC、ARCHITECT 同目录）

**第三步：任务跟踪初始化**
- 使用 TodoWrite 创建任务列表，每个任务包含：content, activeForm, status
- 标注任务依赖关系和优先级（P0/P1/P2）
- 初始状态：所有任务为 pending

**第四步：并行任务执行**
- 识别可并行执行的任务组（无依赖关系）
- 使用 Task tool 单消息多调用方式并行执行子技能
- 每个子技能调用时传递：
  - 任务目标与验收标准
  - 允许修改的文件路径清单（使用 Glob 验证存在性）
  - 允许修改的模块名称清单
  - 上下文限制（从 ARCHITECT.md 提取相关章节内容）
  - 输入文档引用

**第五步：进度跟踪与错误处理**
- 每完成一个任务，立即更新 TodoWrite 状态为 completed
- 遇到失败时，使用 AskUserQuestion 交互式选择处理方式：

| 选项 | 说明 | 后续动作 |
|------|------|----------|
| **停止** | 中止整个开发流程 | 保存当前进度，等待用户指示 |
| **跳过** | 跳过当前任务，继续执行其他不依赖的任务 | 标记任务为 skipped，继续执行 |
| **重试** | 重新执行当前任务 | 调用子技能重试，可配置重试次数 |
| **用户输入** | 让用户提供额外的上下文或指导 | 等待用户输入后，根据输入决定后续动作 |

**第六步：完成总结**
- 所有任务完成后，生成开发总结报告
- 标注已完成的交付物和未解决的问题
- 输出执行记录到 DEVELOPMENT_PLAN.md

## 【子技能约束方式】

### 约束原则：两者结合

**1. 文件/模块清单约束**
- 明确列出允许修改的文件路径和模块名称
- 使用 Glob 工具验证文件存在性
- 禁止子技能修改约束范围外的文件

**2. 上下文范围限制**
- 从 ARCHITECT.md 中提取当前任务相关的章节内容
- 只传递必要的上下文信息给子技能
- 避免传递全量文档导致子技能"越界"

### 示例调用方式

```markdown
调用 frontend-developer-expert：
- 任务目标：实现用户登录页面
- 允许修改的文件：src/pages/LoginPage.vue, src/components/LoginForm.vue
- 允许修改的模块：HomePage, UserProfile
- 约束范围：仅处理登录表单相关逻辑，不涉及权限验证
- 输入文档：ARCHITECT.md 第 6.1 节内容
- 验收标准：表单验证、提交接口、错误处理
```

## 【并行执行策略】

### 任务依赖识别
- 从 ARCHITECT.md 的「研发分工与里程碑」中提取依赖关系
- 构建任务依赖图

### 并行执行规则
- 无依赖关系的任务放入同一批次，并行执行
- 有依赖关系的任务串行执行
- 使用 Task tool 的单消息多调用方式实现并行

### 示例

```
批次1（并行）：
- frontend-developer-expert：登录页面
- multi-platform-developer-expert：首页导航

批次2（依赖批次1）：
- frontend-developer-expert：登录后的跳转逻辑
```

## 【DEVELOPMENT_PLAN.md 文档结构】

```markdown
# 开发计划（DEVELOPMENT PLAN）

> 功能/模块名称：{功能名称}
> 保存路径：.claude/docs/{feature}/DEVELOPMENT_PLAN.md
> 关联文档：.claude/docs/{feature}/PRD.md
> 关联文档：.claude/docs/{feature}/DESIGN_SPEC.md
> 关联文档：.claude/docs/{feature}/ARCHITECT.md

## 1. 开发概述
- 功能/模块名称
- 开发目标
- 成功标准
- 约束条件（时间/资源/技术）

## 2. 任务分组与依赖关系
- 任务组 A（可并行）
- 任务组 B（依赖 A）
- 任务组 C（依赖 A/B）

## 3. 详细任务清单
### 3.1 {任务名称}
- **负责技能**：frontend-developer-expert / multi-platform-developer-expert / 其他
- **优先级**：P0 / P1 / P2
- **前置依赖**：无 / 依赖任务 X
- **输入文档**：ARCHITECT.md 第 X 节
- **输出产物**：具体文件/模块清单
- **约束范围**：
  - 允许修改的文件路径：`src/pages/...`
  - 允许修改的模块：`HomePage`, `UserProfile`
  - 上下文限制：仅处理登录相关功能
- **验收标准**：
- **状态**：pending / in_progress / completed / skipped / failed

## 4. 子技能调度映射
| ARCHITECT 章节 | 负责技能 | 任务编号 |
|---|---|---|
| 6.1 用户登录 | frontend-developer-expert | 3.1 |
| 6.2 跨平台首页 | multi-platform-developer-expert | 3.2 |

## 5. 风险与应对
- 风险项
- 应对措施
- 备选方案

## 6. 执行记录
- 开始时间
- 完成时间
- 遇到的问题与解决
- 未完成的任务
```

## 【关键方法速查】

| 目的 | 方法/工具 | 输出 |
|------|-----------|------|
| 输入校验 | Read + Glob | 确认文档存在且完整 |
| 计划生成 | 解析 ARCHITECT + Write | DEVELOPMENT_PLAN.md |
| 任务跟踪 | TodoWrite | 任务状态列表 |
| 并行调用 | Task（单消息多调用） | 多子技能并行执行 |
| 约束传递 | Read（提取相关章节） | 限定范围的上下文 |
| 错误处理 | AskUserQuestion | 用户选择处理方式 |

## 【注意事项】

- **必须**确认 ARCHITECT.md 存在且包含「研发分工与里程碑」章节
- **必须**使用 TodoWrite 跟踪所有任务状态
- **必须**使用 superpowers:brainstorming 追问直到需求完全清晰
- **不得**跳过约束子技能的修改范围
- **不得**在子技能调用时传递全量文档导致"越界"
- **必须**支持交互式错误处理（4个选项：停止/跳过/重试/用户输入）
- **必须**根据依赖关系智能并行执行任务
- **不得**臆测接口行为或业务规则，缺口必须追问或标注假设
- 任何需求不清晰之处必须先向用户确认再执行

## 【常见错误与修正】

| 常见错误 | 修正方式 |
|---------|---------|
| 直接开始编码，未创建 DEVELOPMENT_PLAN.md | 必须先生成开发计划文档 |
| 给子技能传递全量 ARCHITECT.md | 只传递相关章节内容 |
| 所有任务串行执行 | 识别无依赖任务，并行执行 |
| 子技能失败自动跳过 | 交互式让用户选择处理方式 |
| 未跟踪任务状态 | 使用 TodoWrite 持续更新状态 |
| 忽略任务依赖关系强制并行执行 | 分析依赖图，正确分组执行 |

## 【合理化对照表】

| 常见合理化 | 现实纠正 |
|------------|----------|
| "ARCHITECT 已经够详细了，不需要开发计划" | 开发计划是执行依据，必须明确约束和进度 |
| "子技能会自己判断该做什么" | 必须传递明确的约束范围和上下文 |
| "失败了就重试，不用问用户" | 用户需要了解情况并决定处理方式 |
| "串行执行更稳妥" | 无依赖任务并行执行可提升效率 |
| "约束太严格，影响子技能发挥" | 严格约束是保证开发不偏离设计的必要条件 |

## 【红旗清单】

**出现以下情况必须停止并回到澄清：**

- ARCHITECT.md 不存在或「研发分工与里程碑」章节缺失
- 子技能调用时未传递任何约束参数
- 跳过 TodoWrite 进度跟踪
- 子技能失败时自动重试而不询问用户
- 忽略任务依赖关系强制并行执行
- 需求不清晰时未追问就开始执行

## 【与其他技能的关系】

```
product-manager-expert
       ↓ (PRD.md)
design-expert
       ↓ (DESIGN_SPEC.md)
architect-expert
       ↓ (ARCHITECT.md)
development-lead-expert  ← 当前技能
       ↓ (DEVELOPMENT_PLAN.md)
  ┌────┴────┐
  ↓         ↓
frontend-  multi-platform-
developer  developer
expert    expert
```

**调用时机：** 在 architect-expert 完成 ARCHITECT.md 后调用

**调度的子技能：**
- frontend-developer-expert：处理 Web 前端相关任务
- multi-platform-developer-expert：处理 iOS/Android 跨平台任务
- 根据 ARCHITECT.md 内部指定的其他技能
