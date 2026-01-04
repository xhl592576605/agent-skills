#!/bin/bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CODEX_DIR="$HOME/.codex"
REPO_URL="git@github.com:xhl592576605/agent-skills.git"
TMP_DIR="/tmp/agent-skills"

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

# 克隆到临时目录并复制技能
clone_and_copy() {
    local target_skills_dir="$1"
    local platform_name="$2"

    log_info "开始下载 $platform_name 技能..."

    # 清理并创建临时目录
    rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"
    cd "$TMP_DIR"

    # 克隆仓库
    if git clone "$REPO_URL" .; then
        log_success "仓库克隆成功"
    else
        log_error "仓库克隆失败"
        rm -rf "$TMP_DIR"
        exit 1
    fi

    # 创建目标技能目录
    if [ ! -d "$target_skills_dir" ]; then
        log_info "创建 $platform_name 技能目录: $target_skills_dir"
        mkdir -p "$target_skills_dir"
    fi

    # 复制 skills 目录内容
    if cp -r skills/* "$target_skills_dir"/ 2>/dev/null || cp -r . "$target_skills_dir"/ 2>/dev/null; then
        log_success "技能复制成功"
    else
        log_error "技能复制失败"
        rm -rf "$TMP_DIR"
        exit 1
    fi

    # 清理临时目录
    rm -rf "$TMP_DIR"
    log_info "临时目录已清理"
}

update_config_file() {
    local config_file="$1"
    local platform_name="$2"
    local skills_dir="$3"

    log_info "更新 $platform_name 配置文件: $config_file"

    if [ ! -f "$config_file" ]; then
        log_info "文件不存在，创建新文件: $config_file"
        touch "$config_file"
    fi

    if grep -q "agent-skills" "$config_file" 2>/dev/null; then
        log_info "文件中已包含 agent-skills 内容块，跳过添加"
        return 0
    fi

    local content_block="
## agent-skills

<EXTREMELY_IMPORTANT>
agent-skills library is installed. Please load skills from the following directory:
- $platform_name: $skills_dir
</EXTREMELY_IMPORTANT>
"

    echo -e "$content_block" >> "$config_file"

    if [ $? -eq 0 ]; then
        log_success "$platform_name 配置文件更新成功"
    else
        log_error "$platform_name 配置文件更新失败"
        exit 1
    fi
}

show_usage() {
    echo "使用方法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  claude    仅安装 Claude 技能"
    echo "  codex     仅安装 Codex 技能"
    echo "  all       安装所有技能（默认）"
    echo "  -h, --help 显示帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 claude   # 仅安装 Claude"
    echo "  $0 codex    # 仅安装 Codex"
    echo "  $0 all      # 安装所有"
}

process_platform() {
    local platform="$1"

    local target_skills_dir
    local config_file
    local skills_dir
    local platform_name

    case "$platform" in
        claude|Claude|CLAUDE)
            target_skills_dir="$PROJECT_ROOT/.claude/skills"
            config_file="$CLAUDE_DIR/CLAUDE.md"
            skills_dir="$PROJECT_ROOT/.claude/skills"
            platform_name="Claude"
            ;;
        codex|Codex|CODEX)
            target_skills_dir="$PROJECT_ROOT/.codex/skills"
            config_file="$CODEX_DIR/AGENTS.md"
            skills_dir="$PROJECT_ROOT/.codex/skills"
            platform_name="Codex"
            ;;
        *)
            log_error "不支持的平台: $platform"
            exit 1
            ;;
    esac

    log_info "========================================="
    log_info "开始安装 $platform_name 技能"
    log_info "========================================="

    clone_and_copy "$target_skills_dir" "$platform_name"
    update_config_file "$config_file" "$platform_name" "$skills_dir"

    log_info "========================================="
    log_success "$platform_name 技能安装完成"
    log_info "========================================="
}

main() {
    local platform="${1:-all}"

    case "$platform" in
        -h|--help)
            show_usage
            exit 0
            ;;
        claude|Claude|CLAUDE)
            check_dependencies
            process_platform "claude"
            ;;
        codex|Codex|CODEX)
            check_dependencies
            process_platform "codex"
            ;;
        all|ALL)
            check_dependencies
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
            log_info "Claude 技能目录: $CLAUDE_DIR/agent-skills/skills"
            ;;
        codex|Codex|CODEX)
            log_info "Codex 技能目录: $CODEX_DIR/agent-skills/skills"
            ;;
        all|ALL)
            log_info "Claude 技能目录: $CLAUDE_DIR/agent-skills/skills"
            log_info "Codex 技能目录: $CODEX_DIR/agent-skills/skills"
            ;;
    esac
}

trap 'log_error "脚本执行失败，请检查错误信息"; exit 1' ERR

main "$@"
