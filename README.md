# AI 情报员 - 配套代码

> DeepSeek + Dify + n8n 打造你的私人情报系统

本目录包含「AI 情报员」系列教程的配套代码。

## 快速开始

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/Eric-NZ/wechat-posts/master/ai-intel-officer/setup.sh | bash
```

### Windows (PowerShell)

```powershell
git clone https://github.com/Eric-NZ/wechat-posts.git
cd wechat-posts/ai-intel-officer
docker compose up -d
```

## 文件说明

| 文件 | 说明 |
|------|------|
| `setup.sh` | 一键部署脚本 |
| `docker-compose.yml` | n8n 服务配置 |
| `.env.example` | 环境变量模板 |

## 访问地址

| 服务 | 地址 |
|------|------|
| n8n | http://localhost:5678 |
| Dify | http://localhost |

## 系列教程

详见：[AI 情报员系列文章](../AI情报员系列教程规划.md)
