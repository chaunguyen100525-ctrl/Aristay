#!/bin/bash

# ============================================================================
# AriStay Database Backup Script
# Description: Create backups of the database
# ============================================================================

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
DB_CONTAINER="aristay-postgres-1"
DB_USER="postgres"
DB_NAME="aristay"
BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo -e "${BLUE}Creating database backup...${NC}"

# Full backup (schema + data)
BACKUP_FILE="$BACKUP_DIR/aristay_${TIMESTAMP}.sql"
docker exec "$DB_CONTAINER" pg_dump -U "$DB_USER" "$DB_NAME" > "$BACKUP_FILE"
echo -e "${GREEN}✓${NC} Full backup created: $BACKUP_FILE"

# Compress backup
gzip "$BACKUP_FILE"
echo -e "${GREEN}✓${NC} Backup compressed: ${BACKUP_FILE}.gz"

# Show backup info
BACKUP_SIZE=$(du -h "${BACKUP_FILE}.gz" | cut -f1)
echo -e "${GREEN}✓${NC} Backup size: $BACKUP_SIZE"

# List recent backups
echo ""
echo "Recent backups:"
ls -lht "$BACKUP_DIR" | head -n 6
