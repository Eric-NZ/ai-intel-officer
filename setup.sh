#!/bin/bash

#===============================================================================
# AI 情报员 - 一键部署脚本
# 项目地址：https://github.com/Eric-NZ/wechat-posts/tree/master/ai-intel-officer
#===============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的信息
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# 打印 Banner
print_banner() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║           AI 情报员 - 一键部署脚本 v1.0                   ║"
    echo "║         DeepSeek + Dify + n8n 私人情报系统                ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
}

# 检查 Docker 是否安装
check_docker() {
    info "检查 Docker 环境..."

    if ! command -v docker &> /dev/null; then
        error "Docker 未安装！请先安装 Docker：https://docs.docker.com/get-docker/"
    fi

    if ! command -v docker compose &> /dev/null; then
        # 尝试旧版命令
        if ! command -v docker-compose &> /dev/null; then
            error "Docker Compose 未安装！请确保 Docker 版本 >= 20.10"
        fi
    fi

    # 检查 Docker 是否运行
    if ! docker info &> /dev/null; then
        error "Docker 未运行！请启动 Docker Desktop 或 Docker 服务"
    fi

    success "Docker 环境检查通过"
}

# 创建工作目录
setup_directories() {
    info "创建工作目录..."

    WORK_DIR="$HOME/ai-intel-officer"
    mkdir -p "$WORK_DIR"
    cd "$WORK_DIR"

    # 创建数据目录
    mkdir -p n8n_data
    mkdir -p dify_data

    success "工作目录创建完成：$WORK_DIR"
}

# 下载配置文件
download_configs() {
    info "下载配置文件..."

    BASE_URL="https://raw.githubusercontent.com/Eric-NZ/wechat-posts/master/ai-intel-officer"

    # 下载 docker-compose.yml
    curl -fsSL "$BASE_URL/docker-compose.yml" -o docker-compose.yml

    # 下载 .env.example
    curl -fsSL "$BASE_URL/.env.example" -o .env.example

    # 如果 .env 不存在，从模板创建
    if [ ! -f .env ]; then
        cp .env.example .env
        warn "已创建 .env 文件，请根据需要修改配置"
    fi

    success "配置文件下载完成"
}

# 克隆 Dify
setup_dify() {
    info "设置 Dify..."

    if [ -d "dify" ]; then
        warn "Dify 目录已存在，跳过克隆"
    else
        info "克隆 Dify 仓库（这可能需要几分钟）..."
        git clone --depth 1 https://github.com/langgenius/dify.git
    fi

    # 复制 Dify 环境变量
    cd dify/docker
    if [ ! -f .env ]; then
        cp .env.example .env
        info "已创建 Dify 的 .env 文件"
    fi
    cd "$WORK_DIR"

    success "Dify 设置完成"
}

# 启动服务
start_services() {
    info "启动服务..."

    # 启动 n8n
    info "启动 n8n..."
    docker compose up -d

    # 启动 Dify
    info "启动 Dify（首次启动需要拉取镜像，请耐心等待）..."
    cd dify/docker
    docker compose up -d
    cd "$WORK_DIR"

    success "所有服务启动完成"
}

# 打印访问信息
print_access_info() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                    部署完成！                             ║"
    echo "╠═══════════════════════════════════════════════════════════╣"
    echo "║  n8n 访问地址：  http://localhost:5678                    ║"
    echo "║  Dify 访问地址： http://localhost                         ║"
    echo "╠═══════════════════════════════════════════════════════════╣"
    echo "║  工作目录：$HOME/ai-intel-officer                         "
    echo "║                                                           ║"
    echo "║  常用命令：                                               ║"
    echo "║  - 查看状态：docker ps                                    ║"
    echo "║  - 停止服务：docker compose down                          ║"
    echo "║  - 查看日志：docker logs -f n8n                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    echo "下一步：访问 Dify 创建管理员账号，然后接入 DeepSeek API"
    echo "教程地址：https://github.com/Eric-NZ/wechat-posts"
    echo ""
}

# 主函数
main() {
    print_banner
    check_docker
    setup_directories
    download_configs
    setup_dify
    start_services
    print_access_info
}

# 执行
main
