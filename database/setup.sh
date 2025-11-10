#!/bin/bash

# ============================================================================
# AriStay Database Setup Script
# Description: Automate database setup for development
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DB_CONTAINER="aristay-postgres-1"
DB_USER="postgres"
DB_NAME="aristay"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Functions
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker first."
        exit 1
    fi
    print_success "Docker is running"
}

# Check if PostgreSQL container is running
check_postgres() {
    if ! docker ps | grep -q "$DB_CONTAINER"; then
        print_warning "PostgreSQL container is not running. Starting it now..."
        cd "$SCRIPT_DIR/.."
        docker compose up -d postgres
        print_info "Waiting for PostgreSQL to be ready..."
        sleep 10
    fi
    print_success "PostgreSQL container is running"
}

# Wait for PostgreSQL to be ready
wait_for_postgres() {
    print_info "Waiting for PostgreSQL to accept connections..."

    for i in {1..30}; do
        if docker exec "$DB_CONTAINER" pg_isready -U "$DB_USER" > /dev/null 2>&1; then
            print_success "PostgreSQL is ready"
            return 0
        fi
        echo -n "."
        sleep 1
    done

    print_error "PostgreSQL did not become ready in time"
    exit 1
}

# Create database if not exists
create_database() {
    print_info "Checking if database '$DB_NAME' exists..."

    if docker exec "$DB_CONTAINER" psql -U "$DB_USER" -lqt | cut -d \| -f 1 | grep -qw "$DB_NAME"; then
        print_warning "Database '$DB_NAME' already exists"

        # Ask user if they want to recreate
        read -p "Do you want to drop and recreate the database? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "Dropping database..."
            docker exec "$DB_CONTAINER" psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS $DB_NAME;"
            print_info "Creating database..."
            docker exec "$DB_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE $DB_NAME;"
            print_success "Database recreated"
        else
            print_info "Keeping existing database"
        fi
    else
        print_info "Creating database..."
        docker exec "$DB_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE $DB_NAME;"
        print_success "Database created"
    fi
}

# Import schema
import_schema() {
    print_info "Importing schema..."

    if [ ! -f "$SCRIPT_DIR/schema.sql" ]; then
        print_error "Schema file not found: $SCRIPT_DIR/schema.sql"
        exit 1
    fi

    docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" < "$SCRIPT_DIR/schema.sql"
    print_success "Schema imported successfully"
}

# Import seed data
import_seed() {
    if [ "$1" != "--with-seed" ]; then
        read -p "Do you want to import seed data? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Skipping seed data"
            return 0
        fi
    fi

    print_info "Importing seed data..."

    if [ ! -f "$SCRIPT_DIR/seed.sql" ]; then
        print_warning "Seed file not found: $SCRIPT_DIR/seed.sql"
        return 0
    fi

    docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" < "$SCRIPT_DIR/seed.sql"
    print_success "Seed data imported successfully"
}

# Verify installation
verify_installation() {
    print_info "Verifying installation..."

    # Count tables
    TABLE_COUNT=$(docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';")
    print_success "Found $TABLE_COUNT tables"

    # Count users (if seed data was imported)
    USER_COUNT=$(docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT COUNT(*) FROM users;" 2>/dev/null || echo "0")
    if [ "$USER_COUNT" -gt 0 ]; then
        print_success "Found $USER_COUNT users in database"
    fi
}

# Show connection info
show_connection_info() {
    echo ""
    print_success "Database setup complete!"
    echo ""
    echo "Connection Details:"
    echo "  Host:     localhost"
    echo "  Port:     5432"
    echo "  Database: $DB_NAME"
    echo "  User:     $DB_USER"
    echo "  Password: postgres"
    echo ""
    echo "Connection String:"
    echo "  postgresql://$DB_USER:postgres@localhost:5432/$DB_NAME"
    echo ""
    echo "Quick Commands:"
    echo "  # Connect to database"
    echo "  docker exec -it $DB_CONTAINER psql -U $DB_USER -d $DB_NAME"
    echo ""
    echo "  # List tables"
    echo "  docker exec -it $DB_CONTAINER psql -U $DB_USER -d $DB_NAME -c '\dt'"
    echo ""
    echo "  # Count records"
    echo "  docker exec -it $DB_CONTAINER psql -U $DB_USER -d $DB_NAME -c 'SELECT COUNT(*) FROM users;'"
    echo ""
}

# Main function
main() {
    echo ""
    echo "╔════════════════════════════════════════╗"
    echo "║   AriStay Database Setup Script       ║"
    echo "╚════════════════════════════════════════╝"
    echo ""

    check_docker
    check_postgres
    wait_for_postgres
    create_database
    import_schema
    import_seed "$1"
    verify_installation
    show_connection_info
}

# Run main function
main "$@"
