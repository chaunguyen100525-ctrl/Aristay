#!/bin/bash

# ============================================================================
# AriStay Database Restore Script
# Description: Restore database from backup
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
DB_CONTAINER="aristay-postgres-1"
DB_USER="postgres"
DB_NAME="aristay"
BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/backups"

# Check if backup file provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Backup file not specified${NC}"
    echo ""
    echo "Usage: $0 <backup_file>"
    echo ""
    echo "Available backups:"
    ls -1t "$BACKUP_DIR"
    exit 1
fi

BACKUP_FILE="$1"

# If file is in backups directory, use full path
if [ ! -f "$BACKUP_FILE" ] && [ -f "$BACKUP_DIR/$BACKUP_FILE" ]; then
    BACKUP_FILE="$BACKUP_DIR/$BACKUP_FILE"
fi

# Check if file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo -e "${RED}Error: Backup file not found: $BACKUP_FILE${NC}"
    exit 1
fi

echo -e "${YELLOW}⚠ WARNING: This will drop and recreate the database!${NC}"
read -p "Are you sure you want to continue? (yes/no) " -r
echo

if [ "$REPLY" != "yes" ]; then
    echo "Restore cancelled"
    exit 0
fi

echo -e "${BLUE}Restoring database from: $BACKUP_FILE${NC}"

# Check if file is gzipped
if [[ "$BACKUP_FILE" == *.gz ]]; then
    echo -e "${BLUE}Decompressing backup...${NC}"
    gunzip -c "$BACKUP_FILE" | docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME"
else
    docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" < "$BACKUP_FILE"
fi

echo -e "${GREEN}✓${NC} Database restored successfully"
