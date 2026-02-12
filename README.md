# AI 情报员 - 配套代码

> DeepSeek + Dify + n8n 打造你的私人情报系统

本目录包含「AI 情报员」系列教程的配套代码。

## 快速开始

### Linux / macOS

```bash
curl -fsSL https://github.com/Eric-NZ/ai-intel-officer/blob/master/setup.sh | bash
```

### Windows (PowerShell)

```powershell
git clone https://github.com/Eric-NZ/ai-intel-officer.git
cd wechat-posts/ai-intel-officer
docker compose up -d
```

## 文件说明

| 文件 | 说明 |
|------|------|
| `setup.sh` | 一键部署脚本 |
| `docker-compose.yml` | n8n 服务配置 |
| `.env.example` | 环境变量模板 |
| `workflows/n8n-workflow-rss.json` | RSS 采集工作流（第 4 篇配套） |
| `workflows/n8n-workflow-multi-source.json` | 多源采集 + 智能去重工作流（第 5 篇配套） |

## 访问地址

| 服务 | 地址 |
|------|------|
| n8n | http://localhost:5678 |
| Dify | http://localhost |

## 系列教程

详见：[AI 情报员系列文章](https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzAwNzAxNDY0MA==&action=getalbum&album_id=4344831897529696260#wechat_redirect)

## 关注作者

![微信搜一搜：程序员义拉冠](assets/wechat-search-qrcode.jpg)

微信搜一搜「**程序员义拉冠**」，获取最新教程推送。
