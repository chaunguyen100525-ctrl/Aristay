# AriStay - Tài Liệu Kiến Trúc Hệ Thống

## 📋 Mục Lục

1. [Tổng Quan Hệ Thống](#tổng-quan-hệ-thống)
2. [Công Nghệ Sử Dụng](#công-nghệ-sử-dụng)
3. [Kiến Trúc Tổng Thể](#kiến-trúc-tổng-thể)
4. [Cấu Trúc Thư Mục](#cấu-trúc-thư-mục)
5. [Cơ Sở Dữ Liệu](#cơ-sở-dữ-liệu)
6. [Modules và Chức Năng](#modules-và-chức-năng)
7. [Luồng Nghiệp Vụ](#luồng-nghiệp-vụ)
8. [API Endpoints](#api-endpoints)
9. [Bảo Mật và Xác Thực](#bảo-mật-và-xác-thực)
10. [Deployment và DevOps](#deployment-và-devops)

---

## Tổng Quan Hệ Thống

### Giới Thiệu

**AriStay** là hệ thống quản lý vận hành bất động sản toàn diện, được thiết kế để tối ưu hóa quy trình quản lý nhiều property (khách sạn, căn hộ cho thuê, resort) với các dịch vụ:
- 🧹 Dọn dẹp vệ sinh
- 🔧 Bảo trì sửa chữa
- 🧺 Giặt là
- 🌳 Chăm sóc sân vườn và hồ bơi
- 📦 Quản lý kho vật tư
- 💬 Giao tiếp nội bộ
- 📊 Báo cáo và phân tích

### Mục Tiêu

- **Tự động hóa**: Lên lịch và phân công công việc tự động
- **Truy xuất**: Theo dõi tiến độ công việc real-time
- **Kiểm soát chất lượng**: Xác thực bằng ảnh chụp với metadata (GPS, thời gian)
- **Tối ưu nguồn lực**: Quản lý nhân sự, vật tư hiệu quả
- **Báo cáo**: Phân tích hiệu suất và chi phí

### Đối Tượng Người Dùng

| Vai Trò | Mô Tả | Quyền Hạn |
|---------|-------|-----------|
| **Admin** | Quản trị viên hệ thống | Full quyền: quản lý user, property, cấu hình, báo cáo |
| **Cleaning** | Nhân viên dọn dẹp | Nhận task dọn phòng, checklist, upload ảnh |
| **Maintenance** | Nhân viên bảo trì | Nhận task sửa chữa, báo cáo incident |
| **Laundry** | Nhân viên giặt là | Quản lý orders giặt là, theo dõi workflow |
| **LawnPool** | Nhân viên sân vườn/hồ bơi | Quản lý bảo dưỡng sân vườn, hồ bơi |

---

## Công Nghệ Sử Dụng

### Backend Stack

```
┌─────────────────────────────────────────┐
│         NestJS 10.x (TypeScript)        │
│   Modern, Modular Node.js Framework     │
└─────────────────────────────────────────┘
                    │
        ┌───────────┴───────────┐
        │                       │
┌───────▼────────┐    ┌────────▼────────┐
│  PostgreSQL 16 │    │    Redis 7      │
│  + uuid-ossp   │    │  (BullMQ/Cache) │
└────────────────┘    └─────────────────┘
```

#### Core Technologies

| Thành Phần | Công Nghệ | Phiên Bản | Mục Đích |
|------------|-----------|-----------|----------|
| **Framework** | NestJS | 10.x | Backend API framework |
| **Language** | TypeScript | 5.x | Type-safe development |
| **Database** | PostgreSQL | 16+ | Relational data storage |
| **ORM** | TypeORM | 0.3.20 | Database abstraction |
| **Cache/Queue** | Redis + BullMQ | 7.x / 5.x | Caching, job processing |
| **Authentication** | JWT + Passport | - | Token-based auth |
| **Storage** | AWS S3 / MinIO | - | File storage |
| **Notifications** | Firebase FCM | - | Push notifications |
| **Logging** | Pino | - | Structured logging |
| **Validation** | class-validator | - | DTO validation |
| **Documentation** | Swagger/OpenAPI | - | API docs |

#### Infrastructure

```yaml
Docker Compose Stack:
  - PostgreSQL 16 (Port 5432)
  - Redis 7 (Port 6379)
  - MinIO (Port 9000/9001) # S3-compatible storage
  - NestJS API (Port 3000)
```

---

## Kiến Trúc Tổng Thể

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENT LAYER                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Mobile App  │  │  Mobile App  │  │ Web Dashboard│      │
│  │  (iOS)       │  │  (Android)   │  │  (Admin)     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└────────────────────────┬────────────────────────────────────┘
                         │ HTTPS / REST API
                         │ JWT Authentication
┌────────────────────────▼────────────────────────────────────┐
│                    API GATEWAY                              │
│              (NestJS Application)                           │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              MIDDLEWARE LAYER                       │   │
│  │  [Logger] [Auth Guard] [Validation] [Transform]    │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              BUSINESS LAYER                         │   │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌──────────┐ │   │
│  │  │  Auth   │ │  Users  │ │ Property│ │  Tasks   │ │   │
│  │  │ Module  │ │ Module  │ │ Module  │ │  Module  │ │   │
│  │  └─────────┘ └─────────┘ └─────────┘ └──────────┘ │   │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌──────────┐ │   │
│  │  │Incident │ │Inventory│ │ Laundry │ │ LawnPool │ │   │
│  │  │ Module  │ │ Module  │ │ Module  │ │  Module  │ │   │
│  │  └─────────┘ └─────────┘ └─────────┘ └──────────┘ │   │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐              │   │
│  │  │  Chat   │ │  Files  │ │ Reports │              │   │
│  │  │ Module  │ │ Module  │ │ Module  │              │   │
│  │  └─────────┘ └─────────┘ └─────────┘              │   │
│  └─────────────────────────────────────────────────────┘   │
└────────────────────────┬────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
┌───────▼──────┐  ┌──────▼─────┐  ┌──────▼──────┐
│ PostgreSQL   │  │   Redis    │  │   MinIO/S3  │
│  (Database)  │  │ (Queue/    │  │  (Storage)  │
│              │  │  Cache)    │  │             │
└──────────────┘  └────────────┘  └─────────────┘
```

### Architectural Patterns

#### 1. Module-Based Architecture (NestJS)
```typescript
@Module({
  imports: [...],      // Dependencies
  controllers: [...],  // HTTP endpoints
  providers: [...],    // Services, repositories
  exports: [...]       // Exposed to other modules
})
```

#### 2. Layered Architecture
```
┌──────────────────────────────┐
│   Controllers (HTTP Layer)   │ ← Routes, DTOs, Validation
├──────────────────────────────┤
│   Services (Business Logic)  │ ← Core logic, orchestration
├──────────────────────────────┤
│   Repositories (Data Access) │ ← TypeORM entities, queries
├──────────────────────────────┤
│   Database (PostgreSQL)      │ ← Data persistence
└──────────────────────────────┘
```

#### 3. Design Patterns

- **Repository Pattern**: Abstraction layer cho database operations
- **DTO Pattern**: Data Transfer Objects với validation
- **Guard Pattern**: Authorization và authentication
- **Interceptor Pattern**: Response transformation, logging
- **Strategy Pattern**: Multiple authentication strategies (JWT, Refresh Token)
- **Observer Pattern**: Event-driven notifications

---

## Cấu Trúc Thư Mục

### Current Repository Structure

```
Aristay/
├── database/                     # Database scripts & utilities
│   ├── schema.sql               # Complete PostgreSQL schema (22 tables)
│   ├── seed.sql                 # Sample data for testing
│   ├── setup.sh                 # Database initialization script
│   ├── backup.sh                # Backup utility
│   ├── restore.sh               # Restore utility
│   └── README.md                # Database documentation
│
├── docs/                        # Documentation files
│   ├── aristay_business_flow.md        # Detailed business requirements
│   ├── aristay_flowcharts_*.html       # Interactive flowcharts
│   ├── aristay_permission_matrix.html  # Role-based permissions
│   └── *.pdf, *.docx                   # Additional docs
│
├── ARCHITECTURE.md              # This file
├── index.html                   # Main documentation portal
├── ari_stay_nest_js_postgre_sql_full_mvp_architecture_skeleton.ts
└── docker-compose.yml           # Infrastructure setup
```

### Planned NestJS Application Structure

```
aristay-api/
├── src/
│   ├── main.ts                  # Application entry point
│   ├── app.module.ts            # Root module
│   │
│   ├── common/                  # Shared utilities
│   │   ├── dto/
│   │   │   ├── pagination.dto.ts
│   │   │   └── response.dto.ts
│   │   ├── guards/
│   │   │   ├── jwt-auth.guard.ts
│   │   │   └── roles.guard.ts
│   │   ├── decorators/
│   │   │   └── roles.decorator.ts
│   │   ├── interceptors/
│   │   │   ├── transform.interceptor.ts
│   │   │   └── logging.interceptor.ts
│   │   ├── filters/
│   │   │   └── http-exception.filter.ts
│   │   └── utils/
│   │       └── helpers.ts
│   │
│   ├── config/                  # Configuration modules
│   │   ├── app.config.ts
│   │   ├── database.config.ts
│   │   ├── jwt.config.ts
│   │   ├── s3.config.ts
│   │   ├── redis.config.ts
│   │   └── fcm.config.ts
│   │
│   ├── database/                # Database configuration
│   │   ├── typeorm.config.ts
│   │   └── migrations/
│   │
│   ├── auth/                    # Authentication module
│   │   ├── auth.module.ts
│   │   ├── auth.controller.ts
│   │   ├── auth.service.ts
│   │   ├── strategies/
│   │   │   ├── jwt.strategy.ts
│   │   │   └── refresh-token.strategy.ts
│   │   └── dto/
│   │       ├── login.dto.ts
│   │       └── register.dto.ts
│   │
│   ├── users/                   # User management
│   │   ├── users.module.ts
│   │   ├── users.controller.ts
│   │   ├── users.service.ts
│   │   ├── entities/
│   │   │   └── user.entity.ts
│   │   └── dto/
│   │       ├── create-user.dto.ts
│   │       └── update-user.dto.ts
│   │
│   ├── properties/              # Properties & Units
│   │   ├── properties.module.ts
│   │   ├── properties.controller.ts
│   │   ├── properties.service.ts
│   │   ├── units.controller.ts
│   │   ├── units.service.ts
│   │   ├── entities/
│   │   │   ├── property.entity.ts
│   │   │   └── unit.entity.ts
│   │   └── dto/
│   │
│   ├── tasks/                   # Task management
│   │   ├── tasks.module.ts
│   │   ├── tasks.controller.ts
│   │   ├── tasks.service.ts
│   │   ├── schedules.controller.ts
│   │   ├── schedules.service.ts
│   │   ├── checklists.service.ts
│   │   ├── entities/
│   │   │   ├── task.entity.ts
│   │   │   ├── schedule.entity.ts
│   │   │   ├── task-checklist.entity.ts
│   │   │   └── task-media.entity.ts
│   │   └── dto/
│   │
│   ├── incidents/               # Incident reporting
│   │   ├── incidents.module.ts
│   │   ├── incidents.controller.ts
│   │   ├── incidents.service.ts
│   │   ├── lost-found.controller.ts
│   │   ├── lost-found.service.ts
│   │   └── entities/
│   │
│   ├── inventory/               # Inventory management
│   │   ├── inventory.module.ts
│   │   ├── items.controller.ts
│   │   ├── items.service.ts
│   │   ├── levels.controller.ts
│   │   ├── levels.service.ts
│   │   ├── transactions.controller.ts
│   │   ├── transactions.service.ts
│   │   └── entities/
│   │
│   ├── laundry/                 # Laundry services
│   │   ├── laundry.module.ts
│   │   ├── orders.controller.ts
│   │   ├── orders.service.ts
│   │   └── entities/
│   │
│   ├── lawnpool/                # Lawn & pool maintenance
│   │   ├── lawnpool.module.ts
│   │   ├── lawnpool.controller.ts
│   │   ├── lawnpool.service.ts
│   │   └── entities/
│   │
│   ├── chat/                    # In-app messaging
│   │   ├── chat.module.ts
│   │   ├── chat.gateway.ts      # WebSocket gateway
│   │   ├── chat.controller.ts
│   │   ├── chat.service.ts
│   │   └── entities/
│   │
│   ├── files/                   # File upload/download
│   │   ├── files.module.ts
│   │   ├── files.controller.ts
│   │   ├── files.service.ts
│   │   └── s3.service.ts
│   │
│   ├── notifications/           # Push notifications
│   │   ├── notifications.module.ts
│   │   ├── notifications.service.ts
│   │   ├── fcm.service.ts
│   │   └── queues/
│   │       └── notification.processor.ts
│   │
│   └── reports/                 # Reporting & analytics
│       ├── reports.module.ts
│       ├── reports.controller.ts
│       ├── reports.service.ts
│       └── generators/
│           ├── csv.generator.ts
│           └── pdf.generator.ts
│
├── test/                        # E2E tests
├── .env.example                 # Environment variables template
├── .env                         # Environment variables (gitignored)
├── package.json
├── tsconfig.json
├── nest-cli.json
└── docker-compose.yml
```

---

## Cơ Sở Dữ Liệu

### Schema Overview

**Tổng số tables**: 22 tables

```
┌────────────────────────────────────────────────────┐
│              DATABASE: aristay_db                  │
└────────────────────────────────────────────────────┘

┌───────────────┐     ┌──────────────┐
│    users      │────>│refresh_tokens│
│  (5 roles)    │     └──────────────┘
└───────────────┘

┌───────────────┐     ┌──────────────┐
│  properties   │<────│    units     │
└───────────────┘     └──────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
┌───────▼───────┐    ┌──────▼──────┐    ┌──────▼──────┐
│   schedules   │    │    tasks    │    │  incidents  │
└───────┬───────┘    └──────┬──────┘    └─────────────┘
        │                   │
        │            ┌──────┼──────┐
        │            │      │      │
        │    ┌───────▼──┐ ┌─▼──────────┐
        │    │task_     │ │task_media  │
        │    │checklists│ │(photos/GPS)│
        │    └───────┬──┘ └────────────┘
        │            │
        │    ┌───────▼──────────┐
        │    │task_checklist_   │
        │    │items             │
        │    └──────────────────┘
        │
┌───────▼──────────────┐
│task_checklist_       │
│templates             │
└──────────────────────┘

┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│inventory_    │<────│inventory_    │<────│inventory_    │
│items         │     │levels        │     │txns          │
│(catalog)     │     │(per property)│     │(transactions)│
└──────────────┘     └──────────────┘     └──────────────┘

┌──────────────┐     ┌──────────────┐
│laundry_      │<────│laundry_steps │
│orders        │     │              │
└──────────────┘     └──────────────┘

┌──────────────┐
│yard_pool_    │
│profiles      │
└──────────────┘

┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│chat_threads  │<────│chat_         │────>│chat_messages │
│              │     │participants  │     │              │
└──────────────┘     └──────────────┘     └──────────────┘

┌──────────────┐
│lost_found    │
└──────────────┘
```

### Key Tables

#### 1. Users & Authentication

**users**
- UUID primary key
- Columns: `email`, `password_hash`, `full_name`, `phone`, `role`, `status`
- Roles: `Admin`, `Cleaning`, `Maintenance`, `Laundry`, `LawnPool`
- Status: `Active`, `Inactive`

**refresh_tokens**
- UUID primary key
- JWT refresh token storage với expiration time

#### 2. Properties & Units

**properties**
- UUID primary key
- Columns: `name`, `address`, `city`, `state`, `zip`, `status`

**units**
- UUID primary key
- Foreign key → `properties.id`
- Columns: `unit_number`, `floor`, `bedrooms`, `bathrooms`, `status`
- Status: `Ready`, `Occupied`, `Maintenance`, `Blocked`

#### 3. Schedules & Tasks (7 tables)

**schedules**
- Master schedule với recurrence patterns (JSONB)
- Types: `Cleaning`, `Maintenance`, `Laundry`, `LawnPool`, `ToDo`
- Recurrence: Daily, Weekly, Monthly, OneTime

**tasks**
- Task instances được tạo từ schedules
- Status workflow: `Pending` → `InProgress` → `Completed`/`Cancelled`/`Overdue`
- Foreign keys: `unit_id`, `assignee_id`, `schedule_id`

**task_checklist_templates**
- Reusable checklist templates cho mỗi task type

**task_checklists & task_checklist_items**
- Instance-specific checklists với completion status

**task_media**
- Photos/videos với metadata:
  - GPS coordinates (`latitude`, `longitude`)
  - Device info
  - Timestamp
  - Quality status

#### 4. Incidents

**incidents**
- Damage/malfunction reports
- Severity: `Low`, `Medium`, `High`, `Urgent`
- Status: `Open`, `InProgress`, `Resolved`, `Closed`

**lost_found**
- Lost & found item tracking
- Status: `Reported`, `Found`, `Claimed`, `Donated`

#### 5. Inventory (3 tables)

**inventory_items**
- Master catalog: linens, cleaning supplies, amenities
- Columns: `name`, `sku`, `category`, `unit_of_measure`

**inventory_levels**
- Stock levels per property
- Columns: `current_qty`, `par_level` (minimum stock)
- Auto-alerts when `current_qty < par_level`

**inventory_txns**
- Transaction log: `In`, `Out`, `Adjustment`
- Audit trail cho mọi stock movement

#### 6. Laundry

**laundry_orders**
- Order tracking với status workflow

**laundry_steps**
- Multi-step workflow: `PickUp` → `Wash` → `Dry` → `DropOff`
- Each step có completion timestamp

#### 7. Lawn/Pool

**yard_pool_profiles**
- Property-specific profiles
- JSONB equipment data (mowers, chemicals, etc.)

#### 8. Chat (3 tables)

**chat_threads**
- Conversation threads (property-specific or general)

**chat_participants**
- Many-to-many relationship (threads ↔ users)

**chat_messages**
- Individual messages với read receipts

### Database Features

✅ **UUID Primary Keys**: Distributed-safe, non-sequential IDs
✅ **Foreign Key Constraints**: Referential integrity với CASCADE/SET NULL
✅ **Indexes**: Optimized cho common queries (assignee, unit, status, dates)
✅ **CHECK Constraints**: Enum validation tại database level
✅ **Triggers**: Auto-update `updated_at` timestamps
✅ **JSONB Columns**: Flexible data (recurrence patterns, photos metadata)
✅ **Full Text Search**: Ready for text search indexes
✅ **Audit Fields**: `created_at`, `updated_at` trên mọi table

### Database Optimization

```sql
-- Example: Task query optimization
CREATE INDEX idx_tasks_assignee_status
ON tasks(assignee_id, status)
WHERE status != 'Completed';

-- JSONB indexing for fast queries
CREATE INDEX idx_schedules_recurrence
ON schedules USING GIN (recurrence_pattern);
```

---

## Modules và Chức Năng

### 1. Authentication Module (`/auth`)

**Chức năng chính:**
- User registration
- Login với JWT token generation
- Refresh token rotation
- Password hashing (bcryptjs)

**Authentication Flow:**
```
1. POST /auth/login
   ├─> Validate credentials
   ├─> Generate access_token (15 min expiry)
   ├─> Generate refresh_token (7 days expiry)
   └─> Store refresh_token in database

2. Authenticated Requests
   ├─> Header: Authorization: Bearer <access_token>
   └─> JWT Guard validates token

3. POST /auth/refresh
   ├─> Validate refresh_token
   ├─> Rotate tokens (invalidate old, generate new)
   └─> Return new access_token + refresh_token
```

**Security:**
- Passwords: bcrypt hashed (10 rounds)
- JWT tokens: RS256 signing
- Refresh token rotation: Single-use tokens
- Token blacklisting: For logout/security

### 2. Users Module (`/users`)

**Endpoints:**
```
GET    /users              # List all users (Admin only)
GET    /users/:id          # Get user details
POST   /users              # Create new user (Admin)
PATCH  /users/:id          # Update user
DELETE /users/:id          # Soft delete (set Inactive)
GET    /users/me           # Get current user profile
PATCH  /users/me/password  # Change password
```

**Role-Based Access:**
- Admin: Full CRUD on all users
- Others: Read own profile only

### 3. Properties Module (`/properties`)

**Quản lý properties và units:**

```typescript
// Property structure
Property {
  id: UUID
  name: string
  address: string
  units: Unit[]
  created_at: timestamp
}

// Unit structure
Unit {
  id: UUID
  property_id: UUID
  unit_number: string
  floor: number
  bedrooms: number
  status: 'Ready' | 'Occupied' | 'Maintenance' | 'Blocked'
}
```

**Endpoints:**
```
# Properties
GET    /properties
POST   /properties
GET    /properties/:id
PATCH  /properties/:id
DELETE /properties/:id

# Units
GET    /properties/:propertyId/units
POST   /properties/:propertyId/units
GET    /units/:id
PATCH  /units/:id
PATCH  /units/:id/status
DELETE /units/:id
```

### 4. Tasks Module (`/tasks`)

**Core của hệ thống - quản lý tất cả công việc**

**Task Types:**
- `Cleaning`: Dọn dẹp phòng
- `Maintenance`: Sửa chữa bảo trì
- `Laundry`: Giặt là
- `LawnPool`: Chăm sóc sân vườn/hồ bơi
- `ToDo`: Công việc chung

**Task Lifecycle:**
```
┌──────────┐
│ Schedule │ (Master schedule)
└────┬─────┘
     │ Auto-generate tasks
     ▼
┌─────────┐    ┌────────────┐    ┌───────────┐
│ Pending │───>│ InProgress │───>│ Completed │
└─────────┘    └────────────┘    └───────────┘
     │              │
     └──────────────┴─────────> Overdue (if past due_date)
```

**Features:**
- ✅ Schedule management (one-time & recurring)
- ✅ Task assignment theo role
- ✅ Checklist templates và instances
- ✅ Photo upload với GPS metadata
- ✅ Progress tracking
- ✅ Due date và overdue alerts

**Endpoints:**
```
# Schedules
GET    /schedules
POST   /schedules          # Create master schedule
GET    /schedules/:id
PATCH  /schedules/:id
DELETE /schedules/:id

# Tasks
GET    /tasks              # Filter: status, type, assignee, unit
GET    /tasks/:id
POST   /tasks              # Manual task creation
PATCH  /tasks/:id
PATCH  /tasks/:id/status   # Update status
DELETE /tasks/:id

# Checklists
GET    /tasks/:taskId/checklist
POST   /tasks/:taskId/checklist/items/:itemId/complete

# Media
POST   /tasks/:taskId/media     # Upload photo với GPS
GET    /tasks/:taskId/media
DELETE /media/:mediaId
```

**Checklist Workflow:**
```
1. Admin creates template
   ├─> task_checklist_templates
   └─> task_checklist_template_items

2. Task created → checklist instance
   ├─> Copy template to task_checklists
   └─> Generate task_checklist_items

3. Worker completes items
   ├─> Mark items as completed
   ├─> Upload photos for proof
   └─> Task auto-completes when all items done
```

### 5. Incidents Module (`/incidents`)

**Báo cáo sự cố và mất mát:**

**Incident Types:**
- Damage (hư hỏng)
- Malfunction (lỗi thiết bị)
- Safety issue (vấn đề an toàn)
- Other

**Severity Levels:**
- `Low`: Không ảnh hưởng vận hành
- `Medium`: Cần xử lý trong vài ngày
- `High`: Ảnh hưởng vận hành, cần xử lý nhanh
- `Urgent`: Nguy hiểm, cần xử lý ngay

**Endpoints:**
```
# Incidents
GET    /incidents          # Filter: severity, status, unit
POST   /incidents          # Report new incident
GET    /incidents/:id
PATCH  /incidents/:id      # Update or resolve
DELETE /incidents/:id

# Lost & Found
GET    /lost-found
POST   /lost-found         # Report lost/found item
GET    /lost-found/:id
PATCH  /lost-found/:id     # Update status
DELETE /lost-found/:id
```

**Notification Flow:**
```
Incident reported (High/Urgent)
  └─> Auto-notify Maintenance team
  └─> Create maintenance task
  └─> Admin receives alert
```

### 6. Inventory Module (`/inventory`)

**3-tier inventory system:**

```
inventory_items (Master Catalog)
    │
    ├─> inventory_levels (Per Property)
    │       │
    │       └─> Low stock alerts
    │
    └─> inventory_txns (Transaction Log)
            └─> Audit trail
```

**Features:**
- ✅ Multi-property inventory tracking
- ✅ PAR level management (minimum stock)
- ✅ Automatic low stock alerts
- ✅ Transaction history
- ✅ Audit trail

**Endpoints:**
```
# Items (Catalog)
GET    /inventory/items
POST   /inventory/items      # Add new item to catalog
GET    /inventory/items/:id
PATCH  /inventory/items/:id
DELETE /inventory/items/:id

# Stock Levels
GET    /inventory/levels?propertyId=xxx
GET    /inventory/levels/:itemId/:propertyId
PATCH  /inventory/levels/:itemId/:propertyId  # Update PAR level

# Transactions
GET    /inventory/transactions?propertyId=xxx
POST   /inventory/transactions  # Log In/Out/Adjustment
GET    /inventory/low-stock    # Items below PAR level
```

**Auto-Replenishment:**
```
Inventory level < PAR level
  └─> Generate alert
  └─> Notify Admin
  └─> (Optional) Auto-create purchase order task
```

### 7. Laundry Module (`/laundry`)

**Multi-step laundry workflow:**

```
Order Created
  ├─> Step 1: PickUp
  ├─> Step 2: Wash
  ├─> Step 3: Dry
  └─> Step 4: DropOff → Order Completed
```

**Endpoints:**
```
GET    /laundry/orders
POST   /laundry/orders          # Create new order
GET    /laundry/orders/:id
PATCH  /laundry/orders/:id/steps/:stepType  # Complete step
DELETE /laundry/orders/:id
```

**Status Tracking:**
- Each step có `completed_at` timestamp
- Worker app shows current step
- Auto-notify next step worker

### 8. Lawn/Pool Module (`/lawnpool`)

**Quản lý sân vườn và hồ bơi:**

```typescript
YardPoolProfile {
  property_id: UUID
  service_type: 'Lawn' | 'Pool' | 'Both'
  equipment: JSONB {
    mower: string
    chemicals: string[]
    tools: string[]
  }
  notes: string
}
```

**Endpoints:**
```
GET    /lawnpool/profiles
POST   /lawnpool/profiles
GET    /lawnpool/profiles/:propertyId
PATCH  /lawnpool/profiles/:propertyId
DELETE /lawnpool/profiles/:propertyId
```

**Integration với Tasks:**
- LawnPool tasks reference profiles
- Equipment checklist từ profile data

### 9. Chat Module (`/chat`)

**Real-time messaging system:**

```
Thread (Conversation)
  ├─> Participants (Many-to-many với users)
  └─> Messages
        ├─> Sender
        ├─> Content
        └─> Read receipts
```

**Features:**
- ✅ Property-specific threads
- ✅ Group conversations
- ✅ Read receipts
- ✅ Real-time updates (WebSocket)

**Endpoints:**
```
# Threads
GET    /chat/threads               # User's threads
POST   /chat/threads               # Create new thread
GET    /chat/threads/:id
DELETE /chat/threads/:id

# Participants
POST   /chat/threads/:id/participants   # Add user to thread
DELETE /chat/threads/:threadId/participants/:userId

# Messages
GET    /chat/threads/:threadId/messages
POST   /chat/threads/:threadId/messages
PATCH  /chat/messages/:messageId        # Mark as read
DELETE /chat/messages/:messageId
```

**WebSocket Gateway:**
```typescript
@WebSocketGateway()
export class ChatGateway {
  @SubscribeMessage('send_message')
  handleMessage(@MessageBody() data) {
    // Broadcast to thread participants
  }
}
```

### 10. Files Module (`/files`)

**S3/MinIO integration cho file storage:**

**Upload Flow:**
```
1. Client requests presigned URL
   GET /files/presign?key=task-123/photo.jpg&contentType=image/jpeg

2. Server generates presigned URL (S3)
   └─> Returns URL valid for 15 minutes

3. Client uploads directly to S3
   PUT https://s3.amazonaws.com/bucket/task-123/photo.jpg

4. Client confirms upload
   POST /files/confirm
   └─> Save metadata to database
```

**Endpoints:**
```
GET    /files/presign         # Get presigned upload URL
POST   /files/confirm         # Confirm upload success
GET    /files/:key            # Get presigned download URL
DELETE /files/:key            # Delete file
```

**File Organization:**
```
s3://aristay-bucket/
  ├── tasks/
  │   ├── {task-id}/
  │   │   ├── photo-1.jpg
  │   │   └── photo-2.jpg
  ├── incidents/
  │   └── {incident-id}/
  ├── users/
  │   └── avatars/
  └── properties/
      └── images/
```

### 11. Notifications Module (`/notifications`)

**Firebase Cloud Messaging integration:**

**Notification Types:**
```
- TaskReminder: Daily to-do reminders
- TaskDue: Task due date approaching
- TaskOverdue: Task past due date
- IncidentCreated: New urgent incident
- LowStock: Inventory below PAR level
- ChatMessage: New chat message
- TaskAssigned: New task assigned to user
```

**Architecture:**
```
Event Triggered
  └─> Queue notification job (BullMQ)
      └─> Process job
          ├─> Get user FCM token
          ├─> Build notification payload
          ├─> Send via FCM
          └─> Log delivery status
```

**Endpoints:**
```
POST   /notifications/register-device   # Register FCM token
GET    /notifications/history           # User's notifications
PATCH  /notifications/:id/read          # Mark as read
```

### 12. Reports Module (`/reports`)

**Data export và analytics:**

**Report Types:**
- Task completion reports
- Staff performance
- Property utilization
- Inventory usage
- Incident trends

**Endpoints:**
```
GET    /reports/tasks/completion?startDate=xxx&endDate=xxx
GET    /reports/tasks/by-staff?staffId=xxx
GET    /reports/inventory/usage?propertyId=xxx
GET    /reports/incidents/summary
POST   /reports/export             # Generate CSV/PDF
```

**Export Formats:**
- CSV: For spreadsheet analysis
- PDF: For presentation/printing
- JSON: For API consumers

---

## Luồng Nghiệp Vụ

### 1. Cleaning Workflow

```
┌─────────────────────────────────────────────────────────┐
│ 1. ADMIN: Import cleaning schedule                     │
│    - Upload CSV hoặc create manual schedule            │
│    - Recurrence: Daily, Weekly, OneTime                │
└──────────────────┬──────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────┐
│ 2. SYSTEM: Auto-generate cleaning tasks                │
│    - Create tasks theo schedule                         │
│    - Assign to Cleaning staff                           │
│    - Attach checklist template                          │
└──────────────────┬──────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────┐
│ 3. CLEANER: Receive task notification                  │
│    - View task details trên mobile app                  │
│    - See checklist items                                │
│    - Navigate to unit                                   │
└──────────────────┬──────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────┐
│ 4. CLEANER: Start task                                 │
│    - Mark task as "InProgress"                          │
│    - Complete checklist items one-by-one               │
│    - Upload photos for proof (with GPS)                │
└──────────────────┬──────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────┐
│ 5. CLEANER: Complete task                              │
│    - All checklist items marked done                    │
│    - Submit task                                        │
│    - Task status → "Completed"                          │
└──────────────────┬──────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────┐
│ 6. SYSTEM: Quality Assurance                           │
│    - AI validates photo quality (planned)               │
│    - Admin reviews if needed                            │
│    - Update unit status to "Ready"                      │
└─────────────────────────────────────────────────────────┘
```

### 2. Maintenance Workflow

```
┌─────────────────────────────────────────────────────────┐
│ INCIDENT REPORTED                                       │
│ - Guest hoặc Cleaner phát hiện vấn đề                  │
│ - Create incident với photos                            │
│ - Set severity level                                    │
└──────────────────┬──────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────┐
│ SYSTEM: Auto-create maintenance task                   │
│ - Convert incident → task                               │
│ - Assign to Maintenance team                            │
│ - Priority based on severity                            │
└──────────────────┬──────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────┐
│ MAINTENANCE: Diagnose issue                            │
│ - View incident details + photos                        │
│ - Check required materials                              │
│ - Update task with findings                             │
└──────────────────┬──────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────┐
│ MAINTENANCE: Fix issue                                 │
│ - Complete repair                                       │
│ - Upload before/after photos                            │
│ - Log materials used (inventory)                        │
└──────────────────┬──────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────┐
│ COMPLETE & VERIFY                                       │
│ - Mark task completed                                   │
│ - Resolve incident                                      │
│ - Notify Admin                                          │
└─────────────────────────────────────────────────────────┘
```

### 3. Inventory Workflow

```
┌─────────────────────────────────────────────────────────┐
│ DAILY OPERATIONS                                        │
│ - Cleaners use supplies                                 │
│ - Log usage in inventory_txns (Out)                    │
│ - System updates inventory_levels                       │
└──────────────────┬──────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────┐
│ LOW STOCK DETECTION                                     │
│ - current_qty < par_level                               │
│ - System generates alert                                │
│ - Notify Admin + Inventory manager                      │
└──────────────────┬──────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────┐
│ REPLENISHMENT                                           │
│ - Admin reviews alert                                   │
│ - Create purchase order (external system)               │
│ - Receive supplies                                      │
└──────────────────┬──────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────┐
│ STOCK IN                                                │
│ - Log receipt in inventory_txns (In)                    │
│ - Update inventory_levels                               │
│ - Alert cleared                                         │
└─────────────────────────────────────────────────────────┘
```

### 4. Communication Flow

```
┌─────────────────────────────────────────────────────────┐
│ ISSUE DISCOVERED                                        │
│ - Cleaner finds urgent issue during cleaning            │
└──────────────────┬──────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────┐
│ MULTI-CHANNEL COMMUNICATION                             │
│ ├─> Create incident (structured data)                   │
│ ├─> Send chat message to Maintenance                    │
│ └─> System sends FCM notification                       │
└──────────────────┬──────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────┐
│ MAINTENANCE RESPONDS                                    │
│ - Receive notification on phone                         │
│ - View incident details                                 │
│ - Reply in chat thread                                  │
└──────────────────┬──────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────┐
│ COLLABORATIVE RESOLUTION                                │
│ - Real-time chat updates                                │
│ - Task status updates visible to all                    │
│ - Admin monitors progress                               │
└─────────────────────────────────────────────────────────┘
```

---

## API Endpoints

### Authentication

```http
POST   /api/auth/register
POST   /api/auth/login
POST   /api/auth/refresh
POST   /api/auth/logout
```

### Users

```http
GET    /api/users
POST   /api/users
GET    /api/users/:id
PATCH  /api/users/:id
DELETE /api/users/:id
GET    /api/users/me
PATCH  /api/users/me/password
```

### Properties & Units

```http
# Properties
GET    /api/properties
POST   /api/properties
GET    /api/properties/:id
PATCH  /api/properties/:id
DELETE /api/properties/:id

# Units
GET    /api/properties/:propertyId/units
POST   /api/properties/:propertyId/units
GET    /api/units/:id
PATCH  /api/units/:id
PATCH  /api/units/:id/status
DELETE /api/units/:id
```

### Tasks & Schedules

```http
# Schedules
GET    /api/schedules
POST   /api/schedules
GET    /api/schedules/:id
PATCH  /api/schedules/:id
DELETE /api/schedules/:id

# Tasks
GET    /api/tasks?status=xxx&type=xxx&assigneeId=xxx
POST   /api/tasks
GET    /api/tasks/:id
PATCH  /api/tasks/:id
PATCH  /api/tasks/:id/status
DELETE /api/tasks/:id

# Checklists
GET    /api/tasks/:taskId/checklist
POST   /api/tasks/:taskId/checklist/items/:itemId/complete

# Media
POST   /api/tasks/:taskId/media
GET    /api/tasks/:taskId/media
DELETE /api/media/:mediaId
```

### Incidents

```http
GET    /api/incidents
POST   /api/incidents
GET    /api/incidents/:id
PATCH  /api/incidents/:id
DELETE /api/incidents/:id

GET    /api/lost-found
POST   /api/lost-found
GET    /api/lost-found/:id
PATCH  /api/lost-found/:id
DELETE /api/lost-found/:id
```

### Inventory

```http
# Items
GET    /api/inventory/items
POST   /api/inventory/items
GET    /api/inventory/items/:id
PATCH  /api/inventory/items/:id
DELETE /api/inventory/items/:id

# Levels
GET    /api/inventory/levels?propertyId=xxx
GET    /api/inventory/levels/:itemId/:propertyId
PATCH  /api/inventory/levels/:itemId/:propertyId

# Transactions
GET    /api/inventory/transactions?propertyId=xxx
POST   /api/inventory/transactions
GET    /api/inventory/low-stock
```

### Laundry

```http
GET    /api/laundry/orders
POST   /api/laundry/orders
GET    /api/laundry/orders/:id
PATCH  /api/laundry/orders/:id/steps/:stepType
DELETE /api/laundry/orders/:id
```

### Lawn/Pool

```http
GET    /api/lawnpool/profiles
POST   /api/lawnpool/profiles
GET    /api/lawnpool/profiles/:propertyId
PATCH  /api/lawnpool/profiles/:propertyId
DELETE /api/lawnpool/profiles/:propertyId
```

### Chat

```http
# Threads
GET    /api/chat/threads
POST   /api/chat/threads
GET    /api/chat/threads/:id
DELETE /api/chat/threads/:id

# Participants
POST   /api/chat/threads/:id/participants
DELETE /api/chat/threads/:threadId/participants/:userId

# Messages
GET    /api/chat/threads/:threadId/messages
POST   /api/chat/threads/:threadId/messages
PATCH  /api/chat/messages/:messageId
DELETE /api/chat/messages/:messageId
```

### Files

```http
GET    /api/files/presign?key=xxx&contentType=xxx
POST   /api/files/confirm
GET    /api/files/:key
DELETE /api/files/:key
```

### Notifications

```http
POST   /api/notifications/register-device
GET    /api/notifications/history
PATCH  /api/notifications/:id/read
```

### Reports

```http
GET    /api/reports/tasks/completion?startDate=xxx&endDate=xxx
GET    /api/reports/tasks/by-staff?staffId=xxx
GET    /api/reports/inventory/usage?propertyId=xxx
GET    /api/reports/incidents/summary
POST   /api/reports/export
```

### API Response Format

**Success Response:**
```json
{
  "success": true,
  "data": { ... },
  "message": "Operation successful"
}
```

**Error Response:**
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable error message",
    "details": { ... }
  }
}
```

**Paginated Response:**
```json
{
  "success": true,
  "data": [...],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "totalPages": 8
  }
}
```

---

## Bảo Mật và Xác Thực

### Authentication Strategy

**JWT-based Authentication:**
```
Access Token (Short-lived: 15 minutes)
  └─> Used for API requests
  └─> Stored in memory (not localStorage)

Refresh Token (Long-lived: 7 days)
  └─> Used to get new access token
  └─> Stored in httpOnly cookie (web) or secure storage (mobile)
  └─> Single-use (rotated on refresh)
```

### Authorization

**Role-Based Access Control (RBAC):**

```typescript
@Roles('Admin', 'Maintenance')
@UseGuards(JwtAuthGuard, RolesGuard)
@Get('/sensitive-data')
getSensitiveData() {
  // Only Admin and Maintenance can access
}
```

**Permission Matrix:**

| Resource | Admin | Cleaning | Maintenance | Laundry | LawnPool |
|----------|-------|----------|-------------|---------|----------|
| Users (Create/Update/Delete) | ✅ | ❌ | ❌ | ❌ | ❌ |
| Properties (CRUD) | ✅ | Read | Read | Read | Read |
| Tasks (View All) | ✅ | Assigned | Assigned | Assigned | Assigned |
| Tasks (Assign) | ✅ | ❌ | ❌ | ❌ | ❌ |
| Incidents (Create) | ✅ | ✅ | ✅ | ✅ | ✅ |
| Incidents (Resolve) | ✅ | ❌ | ✅ | ❌ | ❌ |
| Inventory (View) | ✅ | Read | Read | Read | Read |
| Inventory (Manage) | ✅ | Log Usage | Log Usage | Log Usage | Log Usage |
| Reports | ✅ | Own Data | Own Data | Own Data | Own Data |
| Chat | ✅ | ✅ | ✅ | ✅ | ✅ |

### Security Best Practices

✅ **Password Security:**
- Bcrypt hashing (10 rounds)
- Minimum 8 characters
- Complexity requirements
- No password in logs/errors

✅ **API Security:**
- HTTPS only (TLS 1.3)
- CORS configured
- Rate limiting (100 req/min per IP)
- Request validation (class-validator)
- SQL injection prevention (TypeORM parameterized queries)
- XSS prevention (input sanitization)

✅ **File Upload Security:**
- File type validation
- File size limits (10MB)
- Virus scanning (planned)
- Presigned URLs (temporary access)
- No direct file access

✅ **Token Security:**
- JWT with RS256 signing
- Token expiration
- Refresh token rotation
- Token blacklist for logout
- No tokens in URL params

✅ **Database Security:**
- Least privilege database user
- Connection pooling
- Prepared statements
- Encrypted connections
- Regular backups

---

## Deployment và DevOps

### Docker Compose Development

```yaml
version: '3.8'
services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_DB: aristay_db
      POSTGRES_USER: aristay_user
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/schema.sql:/docker-entrypoint-initdb.d/schema.sql

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  minio:
    image: minio/minio
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
    ports:
      - "9000:9000"
      - "9001:9001"
    volumes:
      - minio_data:/data

  api:
    build: .
    ports:
      - "3000:3000"
    depends_on:
      - postgres
      - redis
      - minio
    environment:
      NODE_ENV: development
      DB_HOST: postgres
      REDIS_HOST: redis
      S3_ENDPOINT: http://minio:9000
    volumes:
      - ./src:/app/src

volumes:
  postgres_data:
  minio_data:
```

### Environment Variables

```bash
# Application
NODE_ENV=production
PORT=3000
API_PREFIX=/api

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=aristay_db
DB_USER=aristay_user
DB_PASSWORD=your_secure_password
DB_POOL_MIN=2
DB_POOL_MAX=10

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# JWT
JWT_ACCESS_SECRET=your_access_secret_key_change_in_production
JWT_ACCESS_EXPIRES=15m
JWT_REFRESH_SECRET=your_refresh_secret_key_change_in_production
JWT_REFRESH_EXPIRES=7d

# S3 / MinIO
S3_ENDPOINT=http://localhost:9000
S3_BUCKET=aristay-files
S3_ACCESS_KEY=minioadmin
S3_SECRET_KEY=minioadmin
S3_REGION=us-east-1
S3_USE_SSL=false

# Firebase Cloud Messaging
FCM_SERVER_KEY=your_fcm_server_key

# Logging
LOG_LEVEL=info
LOG_PRETTY=true
```

### Production Deployment

**Recommended Stack:**
```
┌──────────────────────────────────────┐
│          Load Balancer               │
│     (AWS ALB / NGINX)                │
└────────────┬─────────────────────────┘
             │
    ┌────────┼────────┐
    │        │        │
┌───▼───┐ ┌──▼──┐ ┌───▼───┐
│ API-1 │ │API-2│ │ API-3 │  (Auto-scaling)
└───┬───┘ └──┬──┘ └───┬───┘
    │        │        │
    └────────┼────────┘
             │
    ┌────────┼────────┐
    │                 │
┌───▼───────┐   ┌────▼──────┐
│ PostgreSQL│   │   Redis   │
│  (RDS)    │   │(ElastiCache)
└───────────┘   └───────────┘
```

**AWS Services:**
- **Compute**: ECS Fargate / EKS
- **Database**: RDS PostgreSQL (Multi-AZ)
- **Cache**: ElastiCache Redis
- **Storage**: S3
- **CDN**: CloudFront
- **Monitoring**: CloudWatch
- **Secrets**: AWS Secrets Manager

### CI/CD Pipeline

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests
        run: npm test

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Build Docker image
        run: docker build -t aristay-api .
      - name: Push to ECR
        run: docker push $ECR_REPO

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to ECS
        run: aws ecs update-service ...
```

### Monitoring & Logging

**Logging Strategy:**
```typescript
// Structured logging với Pino
logger.info({
  event: 'task_completed',
  taskId: task.id,
  assigneeId: task.assigneeId,
  duration: endTime - startTime
});
```

**Metrics to Monitor:**
- Request rate / Response time
- Error rate (4xx, 5xx)
- Database connection pool
- Queue length (BullMQ)
- Memory/CPU usage
- Disk I/O

**Alerting:**
- High error rate (>5%)
- Slow response time (>500ms p95)
- Database connection failures
- Low disk space
- Failed queue jobs

### Backup Strategy

**Database:**
- Automated daily backups (RDS)
- Point-in-time recovery (7 days)
- Monthly snapshots (retained 1 year)

**Files:**
- S3 versioning enabled
- Cross-region replication
- Lifecycle policies

### Scaling Considerations

**Horizontal Scaling:**
- Stateless API servers (easy to scale)
- Load balancer distributes traffic
- Shared database & cache

**Vertical Scaling:**
- Increase RDS instance size
- Increase Redis instance size

**Database Optimization:**
- Read replicas for reports
- Connection pooling
- Query optimization
- Proper indexing

**Caching Strategy:**
- Redis for session data
- Cache frequently accessed data (properties, users)
- Invalidate on updates

---

## Performance Optimization

### Database Optimization

```sql
-- Compound indexes for common queries
CREATE INDEX idx_tasks_assignee_status_due
ON tasks(assignee_id, status, due_date);

-- Partial indexes for active data
CREATE INDEX idx_active_tasks
ON tasks(status)
WHERE status IN ('Pending', 'InProgress');

-- JSONB indexing
CREATE INDEX idx_schedules_recurrence
ON schedules USING GIN (recurrence_pattern);
```

### API Response Optimization

- **Pagination**: Default 20 items per page
- **Field selection**: Allow clients to specify fields
- **Eager loading**: Reduce N+1 queries
- **Compression**: Gzip responses
- **Caching**: Cache frequent queries

### Image Optimization

- **Compression**: Compress images before upload
- **Thumbnails**: Generate thumbnails for list views
- **Lazy loading**: Load images on-demand
- **CDN**: Serve images via CloudFront

---

## Future Enhancements

### Phase 1 (MVP) ✅
- Core API implementation
- Basic mobile apps
- Essential features (tasks, inventory, chat)

### Phase 2 (Q2 2025)
- AI-powered photo QA
- Automated scheduling optimization
- Advanced reporting & analytics
- Mobile app offline mode

### Phase 3 (Q3 2025)
- Guest mobile app (self-service)
- IoT integration (smart locks, sensors)
- Predictive maintenance
- Machine learning for demand forecasting

### Phase 4 (Q4 2025)
- Multi-language support
- White-label solution
- API for third-party integrations
- Advanced workflow automation

---

## Tài Liệu Tham Khảo

### Internal Documentation
- `database/README.md` - Database schema documentation
- `aristay_business_flow.md` - Detailed business requirements
- `aristay_permission_matrix.html` - Role-based permissions
- `aristay_flowcharts_*.html` - Interactive flowcharts

### External Resources
- [NestJS Documentation](https://docs.nestjs.com)
- [TypeORM Documentation](https://typeorm.io)
- [PostgreSQL Documentation](https://www.postgresql.org/docs)
- [BullMQ Documentation](https://docs.bullmq.io)

---

## Liên Hệ & Support

**Development Team:**
- Architecture: [Architect Name]
- Backend Lead: [Backend Lead]
- DevOps: [DevOps Lead]

**Repository:**
- GitHub: https://github.com/[org]/aristay
- Issues: https://github.com/[org]/aristay/issues

---

**Phiên bản tài liệu**: 1.0.0
**Ngày cập nhật**: 2025-11-10
**Trạng thái**: Development Phase
