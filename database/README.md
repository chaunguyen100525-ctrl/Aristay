# AriStay Database

Thư mục này chứa các file database cho dự án AriStay.

## Cấu trúc

```
database/
├── README.md           # Tài liệu này
├── schema.sql          # Database schema đầy đủ
├── seed.sql            # Dữ liệu mẫu cho testing
└── migrations/         # TypeORM migrations (nếu có)
```

## Yêu cầu

- PostgreSQL 16+
- Extension: uuid-ossp

## Cách sử dụng

### 1. Sử dụng Docker Compose (Khuyến nghị)

Nếu bạn sử dụng Docker Compose từ project skeleton:

```bash
# Khởi động database
docker compose up -d postgres

# Chờ PostgreSQL khởi động (khoảng 5-10 giây)
sleep 10

# Import schema
docker exec -i aristay-postgres-1 psql -U postgres -d aristay < database/schema.sql

# Import seed data (optional - cho testing)
docker exec -i aristay-postgres-1 psql -U postgres -d aristay < database/seed.sql
```

### 2. Sử dụng PostgreSQL local

Nếu bạn có PostgreSQL đã cài đặt trên máy:

```bash
# Tạo database
createdb aristay

# Import schema
psql -d aristay -f database/schema.sql

# Import seed data (optional)
psql -d aristay -f database/seed.sql
```

### 3. Sử dụng TypeORM synchronize (Development only)

Trong môi trường development, TypeORM có thể tự động tạo schema:

```typescript
// src/database/typeorm.config.ts
export const typeOrmConfig: TypeOrmModuleOptions = {
  // ...
  synchronize: true, // DEV ONLY - tự động sync schema
};
```

**⚠️ CẢNH BÁO**: KHÔNG bật `synchronize: true` trong production!

### 4. Verify installation

```bash
# Kiểm tra số lượng tables
docker exec -i aristay-postgres-1 psql -U postgres -d aristay -c "\dt"

# Kiểm tra dữ liệu seed
docker exec -i aristay-postgres-1 psql -U postgres -d aristay -c "SELECT COUNT(*) FROM users;"
```

## Database Schema Overview

### Core Tables (22 tables)

#### Authentication & Users
- `users` - System users with roles
- `refresh_tokens` - JWT refresh tokens

#### Properties & Units
- `properties` - Properties/buildings
- `units` - Individual units/rooms

#### Schedules & Tasks
- `schedules` - Task schedules
- `tasks` - Individual tasks
- `task_checklist_templates` - Reusable templates
- `task_checklist_template_items` - Template items
- `task_checklists` - Task checklist instances
- `task_checklist_items` - Checklist items
- `task_media` - Photos/media for tasks

#### Incidents
- `incidents` - Damage/issue reports
- `lost_found` - Lost & found items

#### Inventory
- `inventory_items` - Master item list
- `inventory_levels` - Stock levels per property
- `inventory_txns` - Stock transactions

#### Laundry
- `laundry_orders` - Laundry orders
- `laundry_steps` - Workflow steps

#### Lawn/Pool
- `yard_pool_profiles` - Property profiles

#### Chat
- `chat_threads` - Conversation threads
- `chat_participants` - Thread participants
- `chat_messages` - Messages

## Seed Data

File `seed.sql` bao gồm dữ liệu mẫu:

- **6 users** (1 admin, 2 cleaning, 1 maintenance, 1 laundry, 1 lawn/pool)
- **3 properties** với 13 units
- **4 tasks** trong các trạng thái khác nhau
- **4 checklist templates**
- **2 incidents**
- **3 lost & found items**
- **15 inventory items** với stock levels
- **3 laundry orders**
- **3 yard/pool profiles**
- **3 chat threads** với 17 messages

### Test Users

Tất cả test users có password: `password123`

| Email | Role | Full Name |
|-------|------|-----------|
| admin@aristay.com | Admin | Admin User |
| cleaning1@aristay.com | Cleaning | Maria Garcia |
| cleaning2@aristay.com | Cleaning | John Smith |
| maintenance@aristay.com | Maintenance | Robert Johnson |
| laundry@aristay.com | Laundry | Linda Chen |
| lawnpool@aristay.com | LawnPool | David Martinez |

**⚠️ LÀM MỚI PASSWORD HASH**: File seed.sql chứa placeholder cho password hash. Bạn cần generate hash thực tế:

```javascript
const bcrypt = require('bcryptjs');
const hash = await bcrypt.hash('password123', 10);
console.log(hash);
// Sau đó replace '$2a$10$YourHashedPasswordHere1234567890ABC' trong seed.sql
```

## Database Maintenance

### Backup

```bash
# Backup toàn bộ database
docker exec aristay-postgres-1 pg_dump -U postgres aristay > backup.sql

# Backup chỉ schema (không có data)
docker exec aristay-postgres-1 pg_dump -U postgres -s aristay > schema_backup.sql

# Backup chỉ data
docker exec aristay-postgres-1 pg_dump -U postgres -a aristay > data_backup.sql
```

### Restore

```bash
# Restore từ backup
docker exec -i aristay-postgres-1 psql -U postgres aristay < backup.sql
```

### Reset Database

```bash
# Drop và tạo lại database
docker exec -i aristay-postgres-1 psql -U postgres -c "DROP DATABASE IF EXISTS aristay;"
docker exec -i aristay-postgres-1 psql -U postgres -c "CREATE DATABASE aristay;"

# Import lại schema và seed
docker exec -i aristay-postgres-1 psql -U postgres -d aristay < database/schema.sql
docker exec -i aristay-postgres-1 psql -U postgres -d aristay < database/seed.sql
```

## Indexes

Schema đã bao gồm các indexes quan trọng cho performance:

- **Unique indexes**: email, property+unit code
- **Foreign key indexes**: Tất cả foreign keys
- **Query optimization indexes**: status, type, dates, timestamps

## Triggers

- `update_updated_at_column`: Tự động cập nhật `updated_at` timestamp cho tables: users, tasks, incidents

## Production Considerations

### 1. Migrations

Trong production, sử dụng TypeORM migrations thay vì `synchronize`:

```bash
# Generate migration
npm run migration:generate -- -n CreateInitialSchema

# Run migrations
npm run migration:run

# Revert migration
npm run migration:revert
```

### 2. Security

- ✅ Thay đổi default passwords
- ✅ Sử dụng strong passwords cho database user
- ✅ Restrict network access (firewall rules)
- ✅ Enable SSL/TLS cho database connections
- ✅ Regular backups

### 3. Performance

- ✅ Monitor slow queries
- ✅ Add indexes dựa trên query patterns
- ✅ Sử dụng connection pooling
- ✅ Configure PostgreSQL parameters (shared_buffers, work_mem, etc.)

### 4. Monitoring

```sql
-- Check database size
SELECT pg_size_pretty(pg_database_size('aristay'));

-- Check table sizes
SELECT
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Check active connections
SELECT count(*) FROM pg_stat_activity WHERE datname = 'aristay';
```

## Troubleshooting

### Connection refused

```bash
# Check if PostgreSQL is running
docker ps | grep postgres

# Check logs
docker logs aristay-postgres-1
```

### Permission denied

```bash
# Ensure correct user
docker exec -i aristay-postgres-1 psql -U postgres -d aristay
```

### Schema already exists

```bash
# Drop existing tables first
docker exec -i aristay-postgres-1 psql -U postgres -d aristay -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
```

## Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [TypeORM Documentation](https://typeorm.io/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## Support

Nếu có vấn đề, vui lòng tạo issue trên GitHub hoặc liên hệ team.
