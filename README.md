# Agent Skills Management

用于管理 Claude 和 Codex 技能的自动化脚本。

## 功能特性

- 自动克隆/更新 agent-skills 仓库到指定目录
- 支持增量更新，避免重复下载
- 自动配置技能列表到 Claude 和 Codex
- 支持单独更新 Claude 或 Codex
- 完善的错误处理和日志记录

## 系统要求

- Git 已安装
- Bash shell
- 对应的目录权限

## 安装

1. 克隆项目：
```bash
git clone git@github.com:xhl592576605/agent-skills.git
cd agent-skills
```

2. 赋予脚本执行权限：
```bash
chmod +x update_skills.sh
```

## 网络执行

如果您不想克隆整个项目，可以直接通过网络执行脚本：

### 方式一：直接下载并执行

```bash
# 更新 Claude 和 Codex（默认）
curl -fsSL https://raw.githubusercontent.com/xhl592576605/agent-skills/main/update_skills.sh | bash

# 仅更新 Claude
curl -fsSL https://raw.githubusercontent.com/xhl592576605/agent-skills/main/update_skills.sh | bash -s -- claude

# 仅更新 Codex
curl -fsSL https://raw.githubusercontent.com/xhl592576605/agent-skills/main/update_skills.sh | bash -s -- codex
```

### 方式二：下载后执行

```bash
# 下载脚本
curl -O https://raw.githubusercontent.com/xhl592576605/agent-skills/main/update_skills.sh

# 赋予执行权限
chmod +x update_skills.sh

# 执行脚本
./update_skills.sh
```

### 网络执行要求

- Git 已安装
- 网络连接正常
- 对 `~/.claude` 和 `~/.codex` 目录有写权限
- 如果使用 HTTPS 地址，可能需要 GitHub 访问权限

## 使用方法

### 基本用法

```bash
# 更新 Claude 和 Codex（默认）
./update_skills.sh

# 或显式指定
./update_skills.sh all
```

### 单独更新

```bash
# 仅更新 Claude 技能
./update_skills.sh claude

# 仅更新 Codex 技能
./update_skills.sh codex
```

### 查看帮助

```bash
./update_skills.sh -h
./update_skills.sh --help
```

## 目录结构

执行脚本后，会在以下目录创建/更新技能：

- **Claude**: `~/.claude/agent-skills/skills/`
- **Codex**: `~/.codex/agent-skills/skills/`

配置文件：
- **Claude**: `~/.claude/CLAUDE.md`
- **Codex**: `~/.codex/AGENTS.md`

## 技能列表

当前包含以下技能：

- `architect-expert` - 架构师专家：基于 PRD + DESIGN_SPEC 的 ARCHITECT 文档
- `design-expert` - 资深UI/UX设计师：设计规范生成
- `frontend-developer-expert` - 资深前端开发：基于 PRD/DESIGN_SPEC 的功能实现
- `multi-platform-developer-expert` - 资深跨平台开发：iOS/Android 多端能力整合
- `product-manager-expert` - 专业产品经理：需求分析与 PRD 生成

## 工作流程

1. **依赖检查**：验证 Git 是否已安装
2. **目录导航**：切换到项目根目录
3. **仓库克隆/更新**：
   - 如果目录不存在，克隆仓库
   - 如果目录已存在且是 Git 仓库，执行 `git pull` 更新
4. **配置文件更新**：在配置文件中添加技能加载说明
5. **验证**：确认文件修改成功

## 错误处理

脚本包含完善的错误处理机制：

- Git 未安装时会提示并退出
- 目录创建失败时会显示错误信息
- 克隆/更新失败时会中断执行
- 文件操作失败时会提供明确的错误提示

## 日志输出

脚本使用三种日志级别：

- `[INFO]` - 一般信息
- `[SUCCESS]` - 成功操作
- `[ERROR]` - 错误信息（输出到 stderr）

所有日志都包含时间戳，便于追踪问题。

## 注意事项

1. 脚本会自动检测并跳过已包含 agent-skills 内容的配置文件
2. 如果配置文件不存在，会自动创建
3. 更新操作是增量式的，不会重复下载
4. 建议定期运行脚本以保持技能库最新

## 故障排除

### Git 权限问题

如果遇到 Git 权限错误，请确保：
- SSH 密钥已配置
- 对仓库有访问权限

### 目录权限问题

如果遇到目录创建失败，请检查：
- 目标目录的父目录是否有写权限
- 磁盘空间是否充足

### 配置文件未更新

如果配置文件未更新，请检查：
- 文件是否已包含 agent-skills 内容（脚本会跳过）
- 文件是否可写

## 维护者

- xhl592576605

## 许可证

请参考项目根目录的 LICENSE 文件。
