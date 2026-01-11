# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

agent-skills 是一个 AI 助手专家技能管理系统，用于管理 Claude 和 Codex 的专家技能库。项目通过自动化脚本将技能文件部署到目标平台，并提供完整的端到端开发工作流支持。

## 目录结构

```
agent-skills/
├── skills/                    # 核心技能库（主目录）
│   ├── architect-expert/      # 架构设计专家
│   ├── design-expert/         # UI/UX 设计专家
│   ├── development-lead-expert/     # 开发协调专家
│   ├── frontend-developer-expert/   # 前端开发专家
│   ├── multi-platform-developer-expert/  # 跨平台开发专家
│   ├── product-manager-expert/ # 产品经理专家
│   └── prompt-expert/         # 提示词专家
├── update_skills.sh           # 自动化部署脚本
└── README.md                  # 项目文档
```

## 常用命令

### 部署技能到本地

```bash
# 更新所有平台（Claude + Codex）
./update_skills.sh

# 仅更新 Claude
./update_skills.sh claude

# 仅更新 Codex
./update_skills.sh codex

# 查看帮助
./update_skills.sh -h
```

### 网络执行（无需克隆）

```bash
# 更新所有平台
curl -fsSL https://raw.githubusercontent.com/xhl592576605/agent-skills/main/update_skills.sh | bash

# 仅更新 Claude
curl -fsSL https://raw.githubusercontent.com/xhl592576605/agent-skills/main/update_skills.sh | bash -s -- claude
```

## 技能系统架构

### 技能调用链

完整的端到端开发工作流遵循以下技能调用顺序：

```
product-manager-expert (PRD.md)
    ↓
design-expert (DESIGN_SPEC.md)
    ↓
architect-expert (ARCHITECT.md)
    ↓
development-lead-expert (DEVELOPMENT_PLAN.md)
    ↓
    ├─ frontend-developer-expert (前端实现)
    └─ multi-platform-developer-expert (跨平台实现)
```

### 子技能指派机制

**关键原则**：子技能指派来自 `architect-expert` 的 `ARCHITECT.md`，而非由 `development-lead-expert` 自行识别。

- `architect-expert` 在 `ARCHITECT.md` 的「研发分工与里程碑」章节中明确标注每个任务由哪个技能执行
- `development-lead-expert` 读取并解析这些标注：
  - 标注具体子技能（如 `frontend-developer-expert`）→ 使用 Skill tool 调用
  - 标注"主 agent" → 由主 agent 直接执行

### 技能文档结构

每个技能文档包含：
- **YAML Frontmatter**: `name` 和 `description`（description 必须符合 CSO 原则：Clear, Specific, Observable）
- **技能说明**: 技能用途和适用场景
- **核心能力**: 技能提供的主要功能
- **执行流程**: 分步骤的执行指南
- **关键方法速查**: 常用命令和工具
- **注意事项**: 重要约束和提醒
- **技术约束**: 开发约束、胶水开发约束、系统性检查约束
- **红旗清单**: 必须避免的错误模式
- **示例**: 实际使用案例

### 技能调用模式

1. **独立调用**: 用户直接请求专家技能时触发
2. **协调调用**: 由 `development-lead-expert` 协调多个子技能并行执行

### 对话轮次执行模型

`development-lead-expert` 使用**批次同步对话轮次模型**：

```
轮次 N：父技能调用子技能（Skill tool）
   ↓
轮次 N+1：子技能执行并输出结果
   ↓
轮次 N+2：父技能继续处理结果（自动更新 TodoWrite、继续下一批次）
```

**关键特性**：
- **不需要"监听"**：子技能输出在对话历史中自然对父技能可见
- **结果自动可见**：父技能通过读取对话历史获取子技能输出
- **自动继续执行**：任务完成后自动继续下一批次，不要停下来等用户说"继续"
- **只有遇到错误时才停下来**：使用 AskUserQuestion 交互式选择处理方式

### TodoWrite vs Skill tool

| 工具 | 作用 | 不做 |
|------|------|------|
| **TodoWrite** | 任务跟踪、进度管理 | 执行任务、分配任务 |
| **Skill tool** | 调用子技能执行任务 | 跟踪进度 |

- TodoWrite 是任务**跟踪工具**，不是执行分配工具
- 有对应子技能的任务必须使用 Skill tool 调用
- 标注为"主 agent"的任务由主 agent 直接执行

## 技能清单与触发条件

| 技能名称 | 触发条件 (description) |
|---------|----------------------|
| **product-manager-expert** | 用户请求需求分析、市场研究、PRD 生成 |
| **design-expert** | 用户请求 UI/UX 设计专业知识或设计规范 |
| **architect-expert** | 用户基于 PRD/DESIGN_SPEC 请求架构设计、系统/模块/数据流/技术栈设计 |
| **development-lead-expert** | 需要创建开发计划并协调子技能执行 |
| **frontend-developer-expert** | 基于 PRD/DESIGN_SPEC 实现前端页面、组件、路由、状态、交互 |
| **multi-platform-developer-expert** | iOS/Android 跨平台应用开发 |
| **prompt-expert** | 创建或优化 AI 提示词 |

## 技术约束体系

每个开发技能都包含完整的技术约束体系：

- **通用开发约束** (34 条): 不得局部补丁、不得隐式依赖、不得吞异常等
- **胶水开发约束** (23 条): 必须复用成熟库、不得裁剪依赖、不得重新实现等
- **系统性代码检查约束** (17 条): 完整性检查、生产级实现验证等

## 部署机制

`update_skills.sh` 脚本工作流程：

1. **依赖检查**: 验证 Git 已安装
2. **仓库克隆**: 克隆到 `/tmp/agent-skills` 临时目录
3. **技能复制**: 复制 `skills/*` 到目标目录
4. **配置更新**: 更新 `~/.claude/CLAUDE.md` 或 `~/.codex/AGENTS.md`
5. **清理**: 删除临时目录

### 目标目录

- **Claude**: `~/.claude/skills/` (配置: `~/.claude/CLAUDE.md`)
- **Codex**: `~/.codex/skills/` (配置: `~/.codex/AGENTS.md`)

## 开发注意事项

### 修改技能文档

1. 技能文档必须位于 `skills/<skill-name>/SKILL.md`
2. 必须包含 YAML frontmatter (`name` 和 `description`)
3. description 必须符合 CSO 原则
4. 遵循统一的文档结构

### 子技能优化要点

基于最近的优化，子技能（`frontend-developer-expert`、`multi-platform-developer-expert`）已添加：

- **自动返回机制**：子技能完成后自动返回父技能，不要停下来等用户说"继续"
- **不要问"是否继续？"**：执行完成后不要输出总结并停下来
- **只有遇到错误时才停下来**：使用 AskUserQuestion 选择处理方式

### 测试部署

修改技能后，运行 `./update_skills.sh` 验证：
- 技能文件正确复制到目标目录
- 配置文件正确更新
- Claude/Codex 能正确加载技能

### 角色与技能指派

在 `architect-expert` 中划分角色时：
1. 使用 `Glob` 工具搜索 `skills/**/SKILL.md`
2. 阅读 description 确认匹配
3. 找到匹配则指派对应技能
4. 未找到则标注"使用主 agent"
5. 不得凭空捏造不存在的技能名称

## 关键原则

- **YAGNI**: 技能设计遵循"你不需要它"原则，去除不必要功能
- **增量验证**: 技能执行时持续追问直到需求清晰
- **约束传递**: 上游文档的约束必须传递给下游技能
- **并行执行**: development-lead-expert 支持调度多个子技能并行工作
- **自动继续**: 任务完成后自动继续执行，不要停下来等用户确认
