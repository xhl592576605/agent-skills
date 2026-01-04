#!/bin/bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CODEX_DIR="$HOME/.codex"
REPO_URL="git@github.com:xhl592576605/agent-skills.git"
CONTENT_BLOCK="\n## agent-skills\n\n<EXTREMELY_IMPORTANT>\n已安装 agent-skills 技能库。请从以下目录加载技能：\n- Claude: ~/.claude/agent-skills/skills\n- Codex: ~/.codex/agent-skills/skills\n</EXTREMELY_IMPORTANT>\n"

log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1" >&2
}

log_success() {
    echo "[SUCCESS] $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

check_dependencies() {
    log_info "检查系统依赖..."

    if ! command -v git &> /dev/null; then
        log_error "Git 未安装，请先安装 Git"
        exit 1
    fi

    log_success "系统依赖检查通过"
}

clone_repository() {
    local target_dir="$1"
    local platform_name="$2"

    log_info "开始克隆仓库到 $platform_name 目录..."

    if [ ! -d "$target_dir" ]; then
        log_info "创建 $platform_name 目录: $target_dir"
        mkdir -p "$target_dir"
    fi

    cd "$target_dir"

    if [ -d "agent-skills" ]; then
        log_info "检测到 $platform_name/agent-skills 已存在，执行拉取更新..."
        cd "agent-skills"
        if git pull origin main 2>/dev/null || git pull origin master 2>/dev/null; then
            log_success "$platform_name/agent-skills 更新成功"
        else
            log_error "$platform_name/agent-skills 更新失败"
            exit 1
        fi
    else
        log_info "克隆仓库到 $target_dir/agent-skills..."
        if git clone "$REPO_URL" agent-skills; then
            log_success "$platform_name/agent-skills 克隆成功"
        else
            log_error "$platform_name/agent-skills 克隆失败"
            exit 1
        fi
    fi

    cd "$PROJECT_ROOT"
}

add_content_to_file() {
    local file_path="$1"
    local platform_name="$2"
    local content_block

    case "$platform_name" in
        Claude)
            content_block="\n## agent-skills\n\n<EXTREMELY_IMPORTANT>\nagent-skills library is installed. Please load skills from the following directory:\n- Claude: ~/.claude/agent-skills/skills\n</EXTREMELY_IMPORTANT>\n"
            ;;
        Codex)
            content_block="\n## agent-skills\n\n<EXTREMELY_IMPORTANT>\nagent-skills library is installed. Please load skills from the following directory:\n- Codex: ~/.codex/agent-skills/skills\n</EXTREMELY_IMPORTANT>\n"
            ;;
    esac

    log_info "编辑 $platform_name 配置文件: $file_path"

    if [ ! -f "$file_path" ]; then
        log_info "文件不存在，创建新文件: $file_path"
        touch "$file_path"
    fi

    if grep -q "agent-skills" "$file_path"; then
        log_info "文件中已包含 agent-skills 内容块，跳过添加"
        return
    fi

    log_info "添加内容块到 $file_path"
    echo -e "$content_block" >> "$file_path"

    if [ $? -eq 0 ]; then
        log_success "$platform_name 配置文件更新成功"
    else
        log_error "$platform_name 配置文件更新失败"
        exit 1
    fi
}

verify_file_modification() {
    local file_path="$1"
    local platform_name="$2"

    log_info "验证 $platform_name 配置文件..."

    if [ ! -f "$file_path" ]; then
        log_error "$platform_name 配置文件不存在: $file_path"
        exit 1
    fi

    if grep -q "agent-skills" "$file_path"; then
        log_success "$platform_name 配置文件验证通过，包含 agent-skills 内容块"
    else
        log_error "$platform_name 配置文件验证失败，未找到 agent-skills 内容块"
        exit 1
    fi
}

show_usage() {
    echo "使用方法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  claude    仅更新 Claude 技能"
    echo "  codex     仅更新 Codex 技能"
    echo "  all       更新 Claude 和 Codex 技能（默认）"
    echo "  -h, --help 显示帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 claude   # 仅更新 Claude"
    echo "  $0 codex    # 仅更新 Codex"
    echo "  $0 all      # 更新两者"
    echo "  $0          # 更新两者（默认）"
}

process_platform() {
    local platform="$1"
    local target_dir
    local config_file

    case "$platform" in
        claude|Claude|CLAUDE)
            target_dir="$CLAUDE_DIR"
            config_file="$CLAUDE_DIR/CLAUDE.md"
            platform_name="Claude"
            ;;
        codex|Codex|CODEX)
            target_dir="$CODEX_DIR"
            config_file="$CODEX_DIR/AGENTS.md"
            platform_name="Codex"
            ;;
        *)
            log_error "不支持的平台: $platform"
            exit 1
            ;;
    esac

    clone_repository "$target_dir" "$platform_name"
    add_content_to_file "$config_file" "$platform_name"
    verify_file_modification "$config_file" "$platform_name"
}

main() {
    local platform="${1:-all}"

    case "$platform" in
        -h|--help)
            show_usage
            exit 0
            ;;
        claude|Claude|CLAUDE)
            log_info "========================================="
            log_info "开始更新 Claude 技能"
            log_info "========================================="
            check_dependencies
            log_info "导航到项目目录: $PROJECT_ROOT"
            cd "$PROJECT_ROOT"
            process_platform "claude"
            ;;
        codex|Codex|CODEX)
            log_info "========================================="
            log_info "开始更新 Codex 技能"
            log_info "========================================="
            check_dependencies
            log_info "导航到项目目录: $PROJECT_ROOT"
            cd "$PROJECT_ROOT"
            process_platform "codex"
            ;;
        all|ALL)
            log_info "========================================="
            log_info "开始更新 Claude 和 Codex 技能"
            log_info "========================================="
            check_dependencies
            log_info "导航到项目目录: $PROJECT_ROOT"
            cd "$PROJECT_ROOT"
            process_platform "claude"
            process_platform "codex"
            ;;
        *)
            log_error "无效的参数: $platform"
            echo ""
            show_usage
            exit 1
            ;;
    esac

    log_info "========================================="
    log_success "所有操作完成！"
    log_info "========================================="

    case "$platform" in
        claude|Claude|CLAUDE)
            log_info "Claude 技能目录: $CLAUDE_DIR/agent-skills"
            log_info "Claude 配置文件: $CLAUDE_DIR/CLAUDE.md"
            ;;
        codex|Codex|CODEX)
            log_info "Codex 技能目录: $CODEX_DIR/agent-skills"
            log_info "Codex 配置文件: $CODEX_DIR/AGENTS.md"
            ;;
        all|ALL)
            log_info "Claude 技能目录: $CLAUDE_DIR/agent-skills"
            log_info "Codex 技能目录: $CODEX_DIR/agent-skills"
            log_info "Claude 配置文件: $CLAUDE_DIR/CLAUDE.md"
            log_info "Codex 配置文件: $CODEX_DIR/AGENTS.md"
            ;;
    esac
}

trap 'log_error "脚本执行失败，请检查错误信息"; exit 1' ERR

main "$@"
