#!/bin/bash
# backup.sh - AI情报员系统备份脚本
# 配套文章：造一个AI情报员⑨
#
# 用法：
#   chmod +x backup.sh
#   ./backup.sh
#
# 定时执行（每天凌晨3点）：
#   crontab -e
#   0 3 * * * /path/to/backup.sh >> /var/log/backup.log 2>&1

set -euo pipefail

DATE=$(date +%Y%m%d)
BACKUP_DIR="/data/backups/$DATE"
mkdir -p "$BACKUP_DIR"

echo "[$(date)] 开始备份..."

# 备份 Dify 数据库
echo "  备份 Dify 数据库..."
docker exec postgres pg_dump -U postgres dify > "$BACKUP_DIR/dify_db.sql"

# 备份 n8n 数据库（如果使用 PostgreSQL）
echo "  备份 n8n 数据库..."
docker exec postgres pg_dump -U postgres n8n > "$BACKUP_DIR/n8n_db.sql" 2>/dev/null || echo "  n8n 数据库跳过（可能使用 SQLite）"

# 备份 n8n SQLite（如果存在）
if [ -f "/home/node/.n8n/database.sqlite" ]; then
    echo "  备份 n8n SQLite..."
    cp /home/node/.n8n/database.sqlite "$BACKUP_DIR/n8n_database.sqlite"
fi

# 备份去重数据库
if [ -f "/home/node/.n8n/dedup_db.json" ]; then
    echo "  备份去重数据库..."
    cp /home/node/.n8n/dedup_db.json "$BACKUP_DIR/dedup_db.json"
fi

# 打包压缩
echo "  打包..."
tar czf "/data/backups/backup_$DATE.tar.gz" -C /data/backups "$DATE"
rm -rf "$BACKUP_DIR"

# 清理 7 天前的备份
echo "  清理旧备份..."
find /data/backups -name "backup_*.tar.gz" -mtime +7 -delete

echo "[$(date)] 备份完成: backup_$DATE.tar.gz"
