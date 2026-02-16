"""
AI情报员 - 每日简报生成脚本
配套文章：造一个AI情报员⑥

用法：
    python generate_report.py
    python generate_report.py --date 2026-02-16
    python generate_report.py --categories "大模型,开源工具"
"""

import argparse
import requests
from datetime import date


API_BASE = "https://your-dify-domain/v1"  # 替换为你的 Dify 地址
API_KEY = "YOUR_API_KEY"                   # 替换为你的 Dify API Key


def generate_daily_report(
    report_date: str,
    categories: str = "大模型,开源工具,行业动态,技术教程",
    max_items: int = 20,
) -> str:
    """调用 Dify 工作流 API 生成每日情报简报"""
    resp = requests.post(
        f"{API_BASE}/workflows/run",
        headers={
            "Authorization": f"Bearer {API_KEY}",
            "Content-Type": "application/json",
        },
        json={
            "inputs": {
                "date": report_date,
                "categories": categories,
                "max_items": max_items,
            },
            "response_mode": "blocking",
            "user": "intel-officer",
        },
        timeout=120,  # 知识库检索 + LLM 分析可能需要较长时间
    )
    resp.raise_for_status()
    result = resp.json()
    return result["data"]["outputs"]["report"]


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="生成 AI 情报日报")
    parser.add_argument(
        "--date",
        default=date.today().isoformat(),
        help="简报日期，默认今天 (YYYY-MM-DD)",
    )
    parser.add_argument(
        "--categories",
        default="大模型,开源工具,行业动态,技术教程",
        help="关注领域，逗号分隔",
    )
    parser.add_argument(
        "--max-items",
        type=int,
        default=20,
        help="最多处理条数，默认 20",
    )
    args = parser.parse_args()

    report = generate_daily_report(args.date, args.categories, args.max_items)
    print(report)
