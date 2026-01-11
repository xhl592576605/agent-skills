---
name: development-lead-expert
description: Use when ARCHITECT.md exists and development execution needs to be coordinated. **CRITICAL: This skill MUST actively execute Skill tool calls to sub-skills (frontend-developer-expert, multi-platform-developer-expert) for parallel implementation. NOT just planning - must actually invoke and execute sub-skills.** Creates DEVELOPMENT_PLAN.md with progress tracking and interactive error handling.
---

# 开发负责人：基于 ARCHITECT 的开发计划与执行协调

## 【技能说明】

在架构设计完成后介入，将 ARCHITECT 文档中的「研发分工与里程碑」转化为可执行的开发计划，协调并调度子开发专家技能并行执行，跟踪任务进度并处理异常情况。

**开始前必须向用户提问并等待回答：功能/模块名称是什么？(可根据前文的上下文确定)**
**执行前必须确认：PRD.md、DESIGN_SPEC.md、ARCHITECT.md 路径存在且内容完整。**
**执行技能时可以使用"superpowers:brainstorming"进行追问更多相关点，直到完全理解架构设计与开发需求。**

## 【执行模式声明】

<EXTREMELY_IMPORTANT>
**本技能是"执行型"技能，不是"对话型"技能！**

**核心要求：**
- 本技能的输出**必须**包含实际的 Skill tool 调用
- 不是"建议"或"规划"，而是**必须立即执行**
- 只输出"我将调用..."而没有实际调用 = **执行失败**

**执行验证：**
完成本技能后，检查输出中是否包含：
```
Skill(skill="子技能名称", args="...")
```
如果没有包含实际的 Skill tool 调用，则本技能执行未完成。
</EXTREMELY_IMPORTANT>

## 【核心能力】

- **开发计划生成**：从 ARCHITECT 文档提取任务清单、依赖关系与技能指派，输出 DEVELOPMENT_PLAN.md
- **任务编排调度**：根据依赖关系识别可并行任务组，使用 Skill tool 并行调用子技能
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

<EXTREMELY_IMPORTANT>
**重要：TodoWrite 是任务跟踪工具，不是执行分配工具！**
</EXTREMELY_IMPORTANT>

- 使用 TodoWrite 创建任务列表，每个任务包含：content, activeForm, status
- 标注任务依赖关系和优先级（P0/P1/P2）
- 初始状态：所有任务为 pending

**任务执行方式**（从 ARCHITECT.md 读取）：
- **子技能指派来自 ARCHITECT.md 的「研发分工与里程碑」章节**
- **architect-expert 已明确标注每个任务由哪个技能或主 agent 执行**
- 读取 ARCHITECT.md 中每个任务的"负责技能"字段：
  - **标注具体子技能**（如 frontend-developer-expert）：使用 Skill tool 调用
  - **标注"主 agent"或"使用主 agent"**：由主 agent 直接执行
- **TodoWrite 只用于跟踪进度，不代表主 agent 要执行所有任务**

**第四步：并行任务执行**

<EXTREMELY_IMPORTANT>
**警告：规划 ≠ 执行！必须立即调用 Skill tool 启动子技能！**

**核心原则**：
- 不得只输出任务规划而不执行调用
- 每个批次必须在下一条消息中立即使用 Skill tool 调用子技能
- 调用格式：使用 Skill tool，指定 skill 参数为子技能名称
- 禁止使用"稍后执行"、"下一步执行"等延迟执行的措辞
- 本步骤的输出必须包含 Skill tool 的实际调用，而非仅仅是描述

**执行方式**（根据 ARCHITECT.md 指派）：
- **标注具体子技能的任务**：必须使用 Skill tool 调用该子技能
- **标注"主 agent"的任务**：由主 agent 直接执行

**禁止行为**：
- **禁止主 agent 执行 ARCHITECT.md 中标注为具体子技能的任务**
- **禁止跳过 Skill tool 调用而自己编码实现有子技能的任务**
- **禁止将标注为子技能的任务改为由主 agent 执行**
</EXTREMELY_IMPORTANT>

- 识别可并行执行的任务组（无依赖关系）
- 根据任务分组执行：
  - **标注为子技能的任务**：使用 Skill tool 单消息多调用方式并行执行
  - **标注为主 agent 的任务**：由主 agent 直接执行
- 每个子技能调用时传递：
  - 任务目标与验收标准
  - 允许修改的文件路径清单（使用 Glob 验证存在性）
  - 允许修改的模块名称清单
  - 上下文限制（从 ARCHITECT.md 提取相关章节内容）
  - 输入文档引用

**第五步：进度跟踪与错误处理**

<EXTREMELY_IMPORTANT>
**重要：任务完成后自动继续，不要停下来等用户说"继续"！**
</EXTREMELY_IMPORTANT>

- 每完成一个任务，立即更新 TodoWrite 状态为 completed
- **每完成一个任务，立即更新 DEVELOPMENT_PLAN.md 中的任务状态**
- **任务成功完成后，自动判断并执行下一个任务，不要输出总结后停下来**
- **不要输出"任务X已完成，是否继续？"之类的提示**
- **只有遇到错误或需要用户决策时才停下来**

**错误处理**（仅遇到失败时）：
- 使用 AskUserQuestion 交互式选择处理方式：

| 选项 | 说明 | 后续动作 |
|------|------|----------|
| **停止** | 中止整个开发流程 | 保存当前进度，等待用户指示 |
| **跳过** | 跳过当前任务，继续执行其他不依赖的任务 | 标记任务为 skipped，继续执行 |
| **重试** | 重新执行当前任务 | 调用子技能重试，可配置重试次数 |
| **用户输入** | 让用户提供额外的上下文或指导 | 等待用户输入后，根据输入决定后续动作 |

**自动继续条件**：
- 当前批次所有任务完成
- 没有遇到需要停止的红旗情况
- 存在下一批次的待执行任务 → **自动继续执行下一批次**

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
- 使用 Skill tool 的单消息多调用方式实现并行

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

## 6. 任务跟踪（Task Tracking）

### 任务状态图例
- [ ] pending - 待执行
- [⚙️] in_progress - 执行中
- [✓] completed - 已完成
- [⊘] skipped - 已跳过
- [✗] failed - 失败

### 任务进度清单

#### 批次1（可并行）
- [ ] 任务3.1: 登录页面 (frontend-developer-expert)
- [ ] 任务3.2: 首页导航 (multi-platform-developer-expert)

#### 批次2（依赖批次1）
- [ ] 任务3.3: 登录后跳转逻辑 (frontend-developer-expert)

### 执行记录
| 时间 | 任务 | 状态 | 说明 |
|------|------|------|------|
| YYYY-MM-DD HH:mm | 任务3.1 | in_progress | 开始执行 |
| YYYY-MM-DD HH:mm | 任务3.1 | completed | 执行完成 |
```

## 【并行执行策略】

### 批次并行执行模型

```
批次1（并行）：
┌─────────────────────────────────────────────┐
│ Task("frontend-developer-expert", 任务3.1)   │
│ Task("multi-platform-developer-expert", 任务3.2) │
└─────────────────────────────────────────────┘
         ↓ 等待所有任务完成
         ↓ 更新 PLAN.md 中的 todo 状态
批次2（并行）：
┌─────────────────────────────────────────────┐
│ Task("frontend-developer-expert", 任务3.3)   │
└─────────────────────────────────────────────┘
         ↓ 等待完成
         ↓ 继续下一批次或完成
```

### 批次识别规则

**无依赖关系 → 同批次并行**
```
任务 A: 登录页面
任务 B: 首页导航
→ 批次1 并行执行
```

**有依赖关系 → 跨批次串行**
```
任务 A: 登录页面
任务 B: 登录后跳转（依赖 A）
→ 批次1: 任务 A
→ 批次2: 任务 B（依赖 A 完成）
```

### Skill tool 并行调用方式

**单消息多调用实现并行：**
```
在一个 Claude 消息中：
- Skill(skill="frontend-developer-expert", args="...")
- Skill(skill="multi-platform-developer-expert", args="...")
- Skill(skill="other-skill", args="...")
→ Claude 会并行执行这些 Skill 调用
```

### 批次等待机制

<EXTREMELY_IMPORTANT>
**重要：批次等待是自动的，不需要显式调用！**
</EXTREMELY_IMPORTANT>

当父技能调用一批子技能后：

1. **启动当前批次所有任务**
   - 在一个消息中调用多个 Skill tool
   - 每个 Skill tool 加载对应的子技能内容
   - 输出消息，完成调用

2. **等待所有任务完成**（自动）
   - AI 在下一轮对话中执行所有子技能
   - 不需要使用 TaskOutput 或其他等待工具
   - 对话自然流转，子技能结果会出现在对话历史中

3. **父技能自动继续**
   - 当所有子技能输出完成后，AI 自动继续父技能的执行
   - 父技能读取对话历史中的子技能结果
   - 更新 TodoWrite 状态为 completed

4. **检查是否有下一个批次**
   - 查看是否有依赖当前批次的任务
   - 检查 TodoWrite 中是否有待执行的 pending 任务

5. **有 → 继续执行下一批次**
   - 重复步骤1-4
   - 调用下一批次的子技能

6. **无 → 所有任务完成，输出总结**
   - 生成开发总结报告
   - 列出所有完成的交付物
   - 记录到 DEVELOPMENT_PLAN.md

### 错误处理与批次继续

当批次中某个任务失败时：
- 使用 AskUserQuestion 交互式选择处理方式
- **停止**：中止整个开发流程
- **跳过**：标记任务为 skipped，继续执行同批次其他任务
- **重试**：重新执行当前任务
- **用户输入**：等待用户提供额外指导

批次内其他任务不受影响，继续执行。

## 【关键方法速查】

| 目的 | 方法/工具 | 输出 |
|------|-----------|------|
| 输入校验 | Read + Glob | 确认文档存在且完整 |
| 计划生成 | 解析 ARCHITECT + Write | DEVELOPMENT_PLAN.md |
| 任务跟踪 | TodoWrite | 任务状态列表 |
| 并行调用 | Skill tool（单消息多调用） | 多子技能并行执行 |
| 约束传递 | Read（提取相关章节） | 限定范围的上下文 |
| 错误处理 | AskUserQuestion | 用户选择处理方式 |

## 【对话轮次执行机制】

<EXTREMELY_IMPORTANT>
**重要：Skill tool 基于对话轮次执行，不需要特殊的"监听"机制！**
</EXTREMELY_IMPORTANT>

### 执行模型

本技能使用**批次同步对话轮次模型**：

```
┌─────────────────────────────────────────────────────────┐
│ 轮次 N：父技能调用子技能                                  │
│ development-lead-expert 输出：                            │
│   "现在开始执行批次1的并行任务："                          │
│   Skill(skill="frontend-developer-expert", args="...")   │
│   Skill(skill="multi-platform-developer-expert", args="...")│
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│ 轮次 N+1：子技能执行并输出结果                             │
│ AI 按照 frontend-developer-expert 指令执行任务            │
│ AI 按照 multi-platform-developer-expert 指令执行任务      │
│ 输出：子技能的执行结果、代码、报告等                        │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│ 轮次 N+2：父技能继续处理结果                               │
│ development-lead-expert 自动继续执行：                     │
│   1. 读取对话历史中的子技能输出                            │
│   2. 更新 TodoWrite 状态为 completed                      │
│   3. 判断是否有下一批次                                   │
│   4. 如果有，继续调用下一批次的子技能                      │
└─────────────────────────────────────────────────────────┘
```

### 关键要点

1. **不需要"监听"**
   - Skill tool 在当前对话上下文中执行
   - 子技能的输出在下一轮对话中自然对父技能可见
   - 对话自然流转，不需要特殊的监听或轮询机制

2. **结果自动可见**
   - 子技能的执行结果会出现在对话历史中
   - 父技能通过读取对话历史来获取子技能的输出
   - 不需要额外的"返回"或"通知"机制

3. **继续执行触发**
   - 当所有子技能输出完成后，AI 会自动继续父技能的执行
   - 父技能通过检查对话历史和 TodoWrite 状态来决定下一步
   - 不需要用户手动触发"继续"

4. **批次等待机制**
   - 调用一批子技能后，等待所有子技能完成
   - 在下一轮对话中统一处理所有结果
   - 然后判断是否需要启动下一批次

## 【子技能调用强制规则】

<EXTREMELY_IMPORTANT>
**核心原则：规划 ≠ 执行！**
</EXTREMELY_IMPORTANT>

### 必须执行的调用

1. **禁止只规划不执行**
   - 不得只输出"我将调用 XXX 技能"、"下一步调用 XXX"
   - 必须在实际的下一条消息中使用 Skill tool 真正调用子技能

2. **立即执行原则**
   - 每个批次任务规划完成后，必须在下一条消息中立即调用
   - 不得使用"稍后"、"接下来"、"下一步"等延迟措辞
   - 不得要求用户确认后再执行（除非遇到红旗情况）

3. **调用格式要求**
   ```
   使用 Skill tool：
   - skill: "frontend-developer-expert"
   - args: "任务目标、约束范围、验收标准..."
   ```

### 正确示例

```
❌ 错误：
"接下来我将调用 frontend-developer-expert 来实现登录页面。"
"下一步：调用 multi-platform-developer-expert 处理首页导航。"

✅ 正确：
[立即在下一条消息中调用 Skill tool]
Skill(skill="frontend-developer-expert", args="...")
```

### 执行验证

完成任务后，检查：
- [ ] 是否在消息中包含 Skill tool 的实际调用
- [ ] 调用的 skill 参数是否正确
- [ ] 传递的 args 是否包含任务目标和约束范围
- [ ] 是否使用了单消息多调用实现并行

### 强制性输出模板

<EXTREMELY_IMPORTANT>
**本步骤的输出格式要求：**

当执行到"并行任务执行"步骤时，输出必须遵循以下格式：

```
# 批次X：并行执行

**任务清单：**
- 任务1：XXX（frontend-developer-expert）
- 任务2：YYY（multi-platform-developer-expert）

**立即执行：**
[此处必须包含实际的 Skill tool 调用，不得省略]
```

**禁止输出：**
```
# 批次X：规划

"我将在下一步调用..."
"接下来将执行..."
```

**必须输出：**
```
Skill(skill="frontend-developer-expert", args="任务：实现登录页面
约束范围：src/pages/Login.vue
验收标准：表单验证、提交接口")
Skill(skill="multi-platform-developer-expert", args="...")
```

</EXTREMELY_IMPORTANT>

### 子技能结果接收与处理

<EXTREMELY_IMPORTANT>
**子技能执行完成后，父技能必须继续处理结果！**
</EXTREMELY_IMPORTANT>

#### 接收机制

当子技能执行完成后，其结果会自然出现在对话历史中。父技能通过以下方式接收：

1. **读取对话历史**
   - 检查对话中子技能的输出内容
   - 查找子技能生成的文件、代码、报告等
   - 确认子技能是否完成任务

2. **验证完成状态**
   - 检查子技能是否输出了预期的交付物
   - 验证交付物是否符合验收标准
   - 确认是否有错误或异常

3. **更新任务状态**
   - 使用 TodoWrite 将对应任务标记为 completed
   - 记录任务的输出结果
   - 更新 DEVELOPMENT_PLAN.md 中的执行记录

#### 处理流程

<EXTREMELY_IMPORTANT>
**重要：处理完成后自动继续下一批次，不要停下来等用户确认！**
</EXTREMELY_IMPORTANT>

```
轮次 N+2：父技能处理子技能结果
├── 步骤1：读取对话历史，获取所有子技能的输出
├── 步骤2：验证每个子技能的完成状态
│   ├── 成功：标记为 completed，记录输出
│   ├── 失败：使用 AskUserQuestion 选择处理方式
│   └── 部分：询问用户是否接受或重试
├── 步骤3：更新 TodoWrite 状态
├── 步骤4：更新 DEVELOPMENT_PLAN.md 执行记录
├── 步骤5：判断是否需要下一批次
│   ├── 有：**自动继续执行下一批次**（不要停下来等用户说"继续"）
│   └── 无：生成开发总结报告
└── 步骤6：仅在所有任务完成后输出总结
```

**禁止行为**：
- **不要在每批次完成后输出总结并停下来**
- **不要问"是否继续下一批次？"**
- **只有遇到错误时才停下来**

#### 继续执行条件

父技能在以下情况下继续执行下一批次：

1. **当前批次所有任务都已完成**（completed 或 skipped）
2. **没有遇到需要停止的红旗情况**
3. **存在下一批次的待执行任务**

#### 错误处理

当子技能执行失败时：

1. **分析失败原因**
   - 读取子技能的错误信息
   - 判断是约束问题、依赖问题还是其他问题

2. **交互式处理**
   - 使用 AskUserQuestion 提供选项：
     - **停止**：中止整个开发流程
     - **跳过**：跳过当前任务，继续其他不依赖的任务
     - **重试**：调整参数后重新执行
     - **用户输入**：等待用户提供额外指导

3. **更新状态**
   - 根据用户选择更新任务状态
   - 记录到执行记录中

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
- **只输出任务规划而不使用 Skill tool 调用子技能**（规划 ≠ 执行！）
- **使用"稍后执行"、"下一步执行"等延迟措辞而不立即调用**
- **主 agent 执行 ARCHITECT.md 中标注为具体子技能的任务**
- **跳过 Skill tool 调用而由主 agent 执行有子技能的任务**
- **任务完成后输出总结并停下来等用户说"继续"**
- **每批次完成后问"是否继续下一批次？"**

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
