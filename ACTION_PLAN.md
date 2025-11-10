# AriStay - Action Plan Chi Tiết

## Tổng Quan Dự Án

**AriStay** là hệ thống quản lý bất động sản cho thuê ngắn hạn (short-term rental) với các tính năng:
- Quản lý lịch dọn phòng và bảo trì
- Quản lý kho vật tư và giặt là
- Báo cáo sự cố và đồ thất lạc
- Chat/messaging giữa staff
- GPS tracking và photo verification
- Thông báo real-time

### Trạng Thái Hiện Tại
✅ **Đã hoàn thành:**
- Database schema (22 tables) với relationships đầy đủ
- Seed data để test
- Tài liệu nghiệp vụ chi tiết
- Architecture skeleton với NestJS

❌ **Chưa có:**
- Backend API (0% code)
- Mobile app
- Admin web dashboard
- Deployment infrastructure

---

## PHASE 1: Thiết Lập Môi Trường & Cấu Trúc Dự Án (Tuần 1)

### 1.1 Khởi Tạo NestJS Project
**Thời gian:** 1 ngày

```bash
# Tạo project mới
npx @nestjs/cli new aristay-backend
cd aristay-backend

# Cài đặt dependencies chính
npm install --save @nestjs/typeorm typeorm pg
npm install --save @nestjs/passport passport passport-jwt
npm install --save @nestjs/jwt bcryptjs
npm install --save @nestjs/config
npm install --save @nestjs/swagger swagger-ui-express
npm install --save class-validator class-transformer
npm install --save @nestjs/bull bull bullmq
npm install --save @aws-sdk/client-s3
npm install --save socket.io @nestjs/websockets
npm install --save pino pino-http nestjs-pino

# Dev dependencies
npm install --save-dev @types/passport-jwt @types/bcryptjs
npm install --save-dev @types/node
```

**Deliverables:**
- ✅ NestJS project initialized
- ✅ Dependencies installed
- ✅ Package.json configured

---

### 1.2 Cấu Hình Docker Compose
**Thời gian:** 0.5 ngày

Tạo `docker-compose.yml`:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:16-alpine
    container_name: aristay-db
    environment:
      POSTGRES_USER: aristay_admin
      POSTGRES_PASSWORD: secure_password_here
      POSTGRES_DB: aristay_dev
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/schema.sql:/docker-entrypoint-initdb.d/01-schema.sql
      - ./database/seed.sql:/docker-entrypoint-initdb.d/02-seed.sql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U aristay_admin"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: aristay-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  minio:
    image: minio/minio:latest
    container_name: aristay-minio
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin123
    ports:
      - "9000:9000"
      - "9001:9001"
    volumes:
      - minio_data:/data

volumes:
  postgres_data:
  redis_data:
  minio_data:
```

**Deliverables:**
- ✅ Docker Compose configured
- ✅ PostgreSQL, Redis, MinIO running
- ✅ Database auto-initialized with schema & seed

---

### 1.3 Setup TypeORM Configuration
**Thời gian:** 0.5 ngày

Tạo `src/config/database.config.ts`:

```typescript
import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';

export const getDatabaseConfig = (configService: ConfigService): TypeOrmModuleOptions => ({
  type: 'postgres',
  host: configService.get('DB_HOST', 'localhost'),
  port: configService.get('DB_PORT', 5432),
  username: configService.get('DB_USERNAME', 'aristay_admin'),
  password: configService.get('DB_PASSWORD', 'secure_password_here'),
  database: configService.get('DB_NAME', 'aristay_dev'),
  entities: [__dirname + '/../**/*.entity{.ts,.js}'],
  migrations: [__dirname + '/../migrations/*{.ts,.js}'],
  synchronize: false, // NEVER use in production
  logging: configService.get('NODE_ENV') === 'development',
});
```

Tạo `.env`:

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=aristay_admin
DB_PASSWORD=secure_password_here
DB_NAME=aristay_dev

# JWT
JWT_ACCESS_SECRET=your-super-secret-access-key-change-this
JWT_REFRESH_SECRET=your-super-secret-refresh-key-change-this
JWT_ACCESS_EXPIRY=15m
JWT_REFRESH_EXPIRY=7d

# AWS S3 / MinIO
S3_ENDPOINT=http://localhost:9000
S3_ACCESS_KEY=minioadmin
S3_SECRET_KEY=minioadmin123
S3_BUCKET=aristay-media
S3_REGION=us-east-1

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# Firebase
FCM_SERVER_KEY=your-firebase-server-key

# App
NODE_ENV=development
PORT=3000
```

**Deliverables:**
- ✅ TypeORM module configured
- ✅ Environment variables setup
- ✅ Database connection working

---

### 1.4 Tạo TypeORM Entities (22 Tables)
**Thời gian:** 2 ngày

Tạo entities theo database schema. Ví dụ `src/entities/user.entity.ts`:

```typescript
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
} from 'typeorm';

export enum UserRole {
  ADMIN = 'admin',
  CLEANING = 'cleaning',
  MAINTENANCE = 'maintenance',
  LAUNDRY = 'laundry',
  LAWN_POOL = 'lawn_pool',
}

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column()
  password_hash: string;

  @Column()
  full_name: string;

  @Column({ nullable: true })
  phone: string;

  @Column({
    type: 'enum',
    enum: UserRole,
  })
  role: UserRole;

  @Column({ default: true })
  is_active: boolean;

  @Column({ type: 'text', nullable: true })
  fcm_token: string;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  // Relations
  @OneToMany(() => RefreshToken, token => token.user)
  refresh_tokens: RefreshToken[];

  @OneToMany(() => Task, task => task.assigned_to_user)
  assigned_tasks: Task[];
}
```

**Tạo 22 entities:**
1. User
2. RefreshToken
3. Property
4. Unit
5. Schedule
6. Task
7. TaskChecklistTemplate
8. TaskChecklistTemplateItem
9. TaskChecklist
10. TaskChecklistItem
11. TaskMedia
12. Incident
13. LostFound
14. InventoryItem
15. InventoryLevel
16. InventoryTxn
17. LaundryOrder
18. LaundryStep
19. YardPoolProfile
20. ChatThread
21. ChatParticipant
22. ChatMessage

**Deliverables:**
- ✅ All 22 entities created
- ✅ Relationships defined
- ✅ Enums & constraints added

---

### 1.5 Setup Module Structure
**Thời gian:** 1 ngày

Tạo modules:

```bash
nest g module auth
nest g module users
nest g module properties
nest g module tasks
nest g module schedules
nest g module incidents
nest g module inventory
nest g module laundry
nest g module lawn-pool
nest g module chat
nest g module files
nest g module notifications
nest g module reports
```

**Deliverables:**
- ✅ Module structure created
- ✅ App module configured with imports

---

## PHASE 2: Authentication & Authorization (Tuần 2)

### 2.1 JWT Strategy Implementation
**Thời gian:** 1 ngày

```typescript
// src/auth/strategies/jwt.strategy.ts
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { UsersService } from '../../users/users.service';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    private configService: ConfigService,
    private usersService: UsersService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: configService.get('JWT_ACCESS_SECRET'),
    });
  }

  async validate(payload: any) {
    const user = await this.usersService.findById(payload.sub);
    if (!user || !user.is_active) {
      throw new UnauthorizedException();
    }
    return user;
  }
}
```

**Deliverables:**
- ✅ JWT Strategy
- ✅ Refresh Token Strategy
- ✅ Guards configured

---

### 2.2 Role-Based Access Control (RBAC)
**Thời gian:** 1 ngày

```typescript
// src/auth/decorators/roles.decorator.ts
import { SetMetadata } from '@nestjs/common';
import { UserRole } from '../../entities/user.entity';

export const ROLES_KEY = 'roles';
export const Roles = (...roles: UserRole[]) => SetMetadata(ROLES_KEY, roles);

// src/auth/guards/roles.guard.ts
import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from '../decorators/roles.decorator';
import { UserRole } from '../../entities/user.entity';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<UserRole[]>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (!requiredRoles) {
      return true;
    }

    const { user } = context.switchToHttp().getRequest();
    return requiredRoles.some((role) => user.role === role);
  }
}
```

**Deliverables:**
- ✅ Roles decorator
- ✅ Roles guard
- ✅ Permission matrix implementation

---

### 2.3 Auth API Endpoints
**Thời gian:** 1.5 ngày

```typescript
// src/auth/auth.controller.ts
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  async register(@Body() dto: RegisterDto) {
    return this.authService.register(dto);
  }

  @Post('login')
  async login(@Body() dto: LoginDto) {
    return this.authService.login(dto);
  }

  @Post('refresh')
  async refresh(@Body() dto: RefreshTokenDto) {
    return this.authService.refreshTokens(dto.refresh_token);
  }

  @Post('logout')
  @UseGuards(JwtAuthGuard)
  async logout(@Req() req) {
    return this.authService.logout(req.user.id);
  }
}
```

**API Endpoints:**
- `POST /auth/register` - Đăng ký user mới
- `POST /auth/login` - Đăng nhập
- `POST /auth/refresh` - Refresh access token
- `POST /auth/logout` - Đăng xuất

**Deliverables:**
- ✅ Auth service với business logic
- ✅ Auth controller với validation
- ✅ DTOs với class-validator
- ✅ Password hashing với bcryptjs

---

## PHASE 3: Users Module (Tuần 2)

### 3.1 Users CRUD Operations
**Thời gian:** 1 ngày

**API Endpoints:**
- `GET /users` - List users (Admin only)
- `GET /users/:id` - Get user detail
- `POST /users` - Create user (Admin only)
- `PATCH /users/:id` - Update user
- `DELETE /users/:id` - Delete/deactivate user (Admin only)

**Deliverables:**
- ✅ Users service
- ✅ Users controller
- ✅ DTOs (CreateUserDto, UpdateUserDto)
- ✅ Pagination & filtering

---

### 3.2 Profile Management
**Thời gian:** 0.5 ngày

**API Endpoints:**
- `GET /users/me` - Get current user profile
- `PATCH /users/me` - Update own profile
- `PATCH /users/me/password` - Change password
- `POST /users/me/fcm-token` - Update FCM token

---

## PHASE 4: Properties & Units (Tuần 3)

### 4.1 Properties CRUD
**Thời gian:** 1 ngày

**API Endpoints:**
- `GET /properties` - List properties
- `GET /properties/:id` - Get property detail
- `POST /properties` - Create property (Admin)
- `PATCH /properties/:id` - Update property (Admin)
- `DELETE /properties/:id` - Delete property (Admin)

---

### 4.2 Units CRUD
**Thời gian:** 1 ngày

**API Endpoints:**
- `GET /properties/:propertyId/units` - List units
- `GET /units/:id` - Get unit detail
- `POST /properties/:propertyId/units` - Create unit
- `PATCH /units/:id` - Update unit
- `PATCH /units/:id/status` - Update unit status
- `DELETE /units/:id` - Delete unit

**Unit Statuses:**
- Ready (sẵn sàng)
- Occupied (đang thuê)
- Maintenance (bảo trì)
- Blocked (tạm khóa)

---

## PHASE 5: Tasks & Scheduling (Tuần 3-4)

### 5.1 Schedule Management
**Thời gian:** 2 ngày

**API Endpoints:**
- `GET /schedules` - List schedules
- `GET /schedules/:id` - Get schedule detail
- `POST /schedules` - Create schedule (Admin)
- `PATCH /schedules/:id` - Update schedule
- `DELETE /schedules/:id` - Delete schedule

**Features:**
- Recurring schedules (daily, weekly, monthly)
- One-time schedules
- Auto-generate tasks from schedules
- Schedule templates

---

### 5.2 Task Management
**Thời gian:** 2 ngày

**API Endpoints:**
- `GET /tasks` - List tasks (filter by status, user, property)
- `GET /tasks/:id` - Get task detail
- `POST /tasks` - Create manual task
- `PATCH /tasks/:id` - Update task
- `PATCH /tasks/:id/assign` - Assign task to user
- `PATCH /tasks/:id/status` - Update task status
- `DELETE /tasks/:id` - Cancel task

**Task Workflow:**
```
Pending → InProgress → Completed → Verified
         ↓
      Canceled
```

---

### 5.3 Checklist System
**Thời gian:** 2 ngày

**Checklist Templates:**
- `GET /checklist-templates` - List templates
- `POST /checklist-templates` - Create template
- `PATCH /checklist-templates/:id` - Update template
- `DELETE /checklist-templates/:id` - Delete template

**Task Checklists:**
- `GET /tasks/:taskId/checklist` - Get task checklist
- `PATCH /tasks/:taskId/checklist/:itemId` - Check/uncheck item
- `POST /tasks/:taskId/checklist` - Add custom checklist item

---

## PHASE 6: File Upload & Media (Tuần 4)

### 6.1 S3/MinIO Integration
**Thời gian:** 1.5 ngày

```typescript
// src/files/files.service.ts
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';

@Injectable()
export class FilesService {
  private s3Client: S3Client;

  constructor(private configService: ConfigService) {
    this.s3Client = new S3Client({
      endpoint: configService.get('S3_ENDPOINT'),
      region: configService.get('S3_REGION'),
      credentials: {
        accessKeyId: configService.get('S3_ACCESS_KEY'),
        secretAccessKey: configService.get('S3_SECRET_KEY'),
      },
    });
  }

  async generatePresignedUrl(fileName: string, fileType: string): Promise<string> {
    const key = `uploads/${Date.now()}-${fileName}`;
    const command = new PutObjectCommand({
      Bucket: this.configService.get('S3_BUCKET'),
      Key: key,
      ContentType: fileType,
    });

    return await getSignedUrl(this.s3Client, command, { expiresIn: 3600 });
  }
}
```

**API Endpoints:**
- `POST /files/presigned-url` - Get presigned URL for upload
- `GET /files/:key` - Get file URL

---

### 6.2 Task Media with GPS
**Thời gian:** 1 ngày

```typescript
// src/tasks/dto/upload-media.dto.ts
export class UploadMediaDto {
  @IsString()
  s3_key: string;

  @IsOptional()
  @IsNumber()
  gps_lat?: number;

  @IsOptional()
  @IsNumber()
  gps_lng?: number;

  @IsOptional()
  @IsString()
  notes?: string;
}
```

**API Endpoints:**
- `POST /tasks/:taskId/media` - Add media to task
- `GET /tasks/:taskId/media` - List task media
- `DELETE /tasks/:taskId/media/:mediaId` - Delete media

---

## PHASE 7: Incidents & Lost/Found (Tuần 5)

### 7.1 Incidents Management
**Thời gian:** 1.5 ngày

**API Endpoints:**
- `GET /incidents` - List incidents
- `GET /incidents/:id` - Get incident detail
- `POST /incidents` - Report new incident
- `PATCH /incidents/:id` - Update incident
- `PATCH /incidents/:id/status` - Update incident status

**Incident Types:**
- Damage
- Cleanliness Issue
- Maintenance Need
- Other

**Severity Levels:**
- Low
- Medium
- High
- Critical

---

### 7.2 Lost & Found
**Thời gian:** 1 ngày

**API Endpoints:**
- `GET /lost-found` - List items
- `GET /lost-found/:id` - Get item detail
- `POST /lost-found` - Report lost/found item
- `PATCH /lost-found/:id` - Update item
- `PATCH /lost-found/:id/status` - Update status (Found, Claimed, Discarded)

---

## PHASE 8: Inventory Management (Tuần 5-6)

### 8.1 Inventory Items (Master Catalog)
**Thời gian:** 1 ngày

**API Endpoints:**
- `GET /inventory/items` - List inventory items
- `POST /inventory/items` - Create item (Admin)
- `PATCH /inventory/items/:id` - Update item
- `DELETE /inventory/items/:id` - Delete item

**Item Categories:**
- Cleaning Supplies
- Linens
- Toiletries
- Kitchen
- Maintenance Tools

---

### 8.2 Inventory Levels & Transactions
**Thời gian:** 2 ngày

**API Endpoints:**
- `GET /inventory/levels` - List inventory levels (by property)
- `GET /inventory/levels/:propertyId` - Get property inventory
- `POST /inventory/transactions` - Record transaction (IN/OUT/Adjustment)
- `GET /inventory/transactions` - Transaction history
- `GET /inventory/alerts` - Low stock alerts

**Transaction Types:**
- IN (nhập kho)
- OUT (xuất kho)
- Adjustment (điều chỉnh)

**Par Level Alerts:**
- Automatically notify when qty < par_level
- Send to Admin & relevant staff

---

## PHASE 9: Laundry Module (Tuần 6)

### 9.1 Laundry Orders & Workflow
**Thời gian:** 1.5 ngày

**API Endpoints:**
- `GET /laundry/orders` - List orders
- `GET /laundry/orders/:id` - Get order detail
- `POST /laundry/orders` - Create order
- `PATCH /laundry/orders/:id/steps/:stepId` - Update step status

**Workflow Steps:**
1. PickUp (Pickup)
2. Wash (Giặt)
3. Dry (Sấy)
4. DropOff (Giao lại)

Each step tracks: status, completed_at, completed_by, notes

---

## PHASE 10: Lawn/Pool Module (Tuần 6)

### 10.1 Yard/Pool Profiles
**Thời gian:** 1 ngày

**API Endpoints:**
- `GET /lawn-pool/profiles` - List profiles
- `GET /lawn-pool/profiles/:id` - Get profile detail
- `POST /lawn-pool/profiles` - Create profile
- `PATCH /lawn-pool/profiles/:id` - Update profile

**Service Types:**
- Lawn Mowing
- Tree/Shrub Trimming
- Pool Cleaning
- Pool Chemical Balancing
- Irrigation Check

---

## PHASE 11: Chat/Messaging (Tuần 7)

### 11.1 Chat Threads & Messages
**Thời gian:** 2 ngày

**API Endpoints:**
- `GET /chat/threads` - List user's threads
- `GET /chat/threads/:id` - Get thread detail
- `POST /chat/threads` - Create new thread
- `POST /chat/threads/:id/messages` - Send message
- `GET /chat/threads/:id/messages` - Get messages (paginated)
- `PATCH /chat/messages/:id/read` - Mark as read

---

### 11.2 WebSocket Real-time
**Thời gian:** 2 ngày

```typescript
// src/chat/chat.gateway.ts
@WebSocketGateway({
  cors: { origin: '*' },
})
export class ChatGateway {
  @WebSocketServer()
  server: Server;

  @SubscribeMessage('join_thread')
  handleJoinThread(client: Socket, threadId: string) {
    client.join(`thread_${threadId}`);
  }

  @SubscribeMessage('send_message')
  async handleMessage(client: Socket, payload: any) {
    const message = await this.chatService.createMessage(payload);
    this.server.to(`thread_${payload.threadId}`).emit('new_message', message);
  }
}
```

**Real-time Events:**
- `join_thread` - Join thread room
- `send_message` - Send new message
- `new_message` - Receive message event
- `typing` - User typing indicator

---

## PHASE 12: Notifications (Tuần 7)

### 12.1 Firebase Cloud Messaging
**Thời gian:** 1.5 ngày

```typescript
// src/notifications/notifications.service.ts
import * as admin from 'firebase-admin';

@Injectable()
export class NotificationsService {
  constructor() {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
  }

  async sendToUser(userId: string, notification: NotificationPayload) {
    const user = await this.usersService.findById(userId);
    if (!user.fcm_token) return;

    await admin.messaging().send({
      token: user.fcm_token,
      notification: {
        title: notification.title,
        body: notification.body,
      },
      data: notification.data,
    });
  }

  async sendToRole(role: UserRole, notification: NotificationPayload) {
    const users = await this.usersService.findByRole(role);
    const tokens = users.map(u => u.fcm_token).filter(Boolean);

    if (tokens.length === 0) return;

    await admin.messaging().sendMulticast({
      tokens,
      notification: {
        title: notification.title,
        body: notification.body,
      },
      data: notification.data,
    });
  }
}
```

**Notification Triggers:**
- Task assigned → Notify assigned user
- Task completed → Notify Admin
- Low inventory → Notify Admin
- New incident → Notify Admin + Maintenance
- New message → Notify thread participants

---

## PHASE 13: Background Jobs (Tuần 8)

### 13.1 BullMQ Setup
**Thời gian:** 1 ngày

```typescript
// src/jobs/jobs.module.ts
import { BullModule } from '@nestjs/bull';

@Module({
  imports: [
    BullModule.forRoot({
      redis: {
        host: 'localhost',
        port: 6379,
      },
    }),
    BullModule.registerQueue(
      { name: 'notifications' },
      { name: 'reports' },
      { name: 'schedules' },
    ),
  ],
})
export class JobsModule {}
```

---

### 13.2 Scheduled Jobs
**Thời gian:** 1.5 ngày

**Cron Jobs:**
- **Daily 6AM:** Generate tasks from recurring schedules
- **Daily 8PM:** Send end-of-day summary report
- **Weekly Monday:** Send weekly performance report
- **Daily 12AM:** Cleanup old refresh tokens
- **Hourly:** Check inventory par levels and send alerts

```typescript
// src/jobs/schedule.processor.ts
@Processor('schedules')
export class ScheduleProcessor {
  @Cron('0 6 * * *') // Every day at 6 AM
  async generateDailyTasks() {
    const schedules = await this.schedulesService.getActiveSchedules();
    for (const schedule of schedules) {
      await this.tasksService.generateFromSchedule(schedule);
    }
  }
}
```

---

## PHASE 14: Reports Module (Tuần 8)

### 14.1 Task Reports
**Thời gian:** 1.5 ngày

**API Endpoints:**
- `GET /reports/tasks/completion` - Task completion rate by period
- `GET /reports/tasks/by-user` - Tasks by user
- `GET /reports/tasks/by-property` - Tasks by property
- `GET /reports/tasks/export` - Export to CSV/Excel

---

### 14.2 Inventory & Analytics Reports
**Thời gian:** 1.5 ngày

**API Endpoints:**
- `GET /reports/inventory/usage` - Inventory usage trends
- `GET /reports/inventory/par-level-violations` - Items below par level
- `GET /reports/staff/performance` - Staff performance metrics
- `GET /reports/incidents/summary` - Incident summary

---

## PHASE 15: API Documentation & Testing (Tuần 9)

### 15.1 Swagger Documentation
**Thời gian:** 1 ngày

```typescript
// src/main.ts
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const config = new DocumentBuilder()
    .setTitle('AriStay API')
    .setDescription('Property Management System API Documentation')
    .setVersion('1.0')
    .addBearerAuth()
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  await app.listen(3000);
}
```

**Deliverables:**
- ✅ All endpoints documented with @ApiOperation, @ApiResponse
- ✅ DTOs documented with @ApiProperty
- ✅ Interactive Swagger UI at `/api/docs`

---

### 15.2 Unit Tests
**Thời gian:** 2 ngày

```typescript
// src/auth/auth.service.spec.ts
describe('AuthService', () => {
  let service: AuthService;
  let usersService: UsersService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: UsersService,
          useValue: {
            findByEmail: jest.fn(),
            create: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
    usersService = module.get<UsersService>(UsersService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('login', () => {
    it('should return tokens when credentials are valid', async () => {
      // Test implementation
    });
  });
});
```

**Test Coverage Target:** >80% cho services

---

### 15.3 Integration & E2E Tests
**Thời gian:** 2 ngày

```typescript
// test/auth.e2e-spec.ts
describe('Auth (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  it('/auth/login (POST)', () => {
    return request(app.getHttpServer())
      .post('/auth/login')
      .send({ email: 'test@example.com', password: 'password123' })
      .expect(200)
      .expect((res) => {
        expect(res.body.access_token).toBeDefined();
      });
  });
});
```

---

## PHASE 16: Database Migrations (Tuần 9)

### 16.1 TypeORM Migrations
**Thời gian:** 1 ngày

```bash
# Generate migration from entities
npm run typeorm migration:generate -- -n InitialSchema

# Run migrations
npm run typeorm migration:run

# Revert migration
npm run typeorm migration:revert
```

Update `package.json`:
```json
{
  "scripts": {
    "typeorm": "ts-node -r tsconfig-paths/register ./node_modules/typeorm/cli.js",
    "migration:generate": "npm run typeorm -- migration:generate",
    "migration:run": "npm run typeorm -- migration:run",
    "migration:revert": "npm run typeorm -- migration:revert"
  }
}
```

**Deliverables:**
- ✅ Migrations generated
- ✅ `synchronize: false` in production
- ✅ Migration workflow documented

---

## PHASE 17: Admin Web Dashboard (Tuần 10-13)

### 17.1 React/Next.js Setup
**Thời gian:** 1 ngày

```bash
npx create-next-app@latest aristay-admin --typescript --tailwind --app
cd aristay-admin

# Install dependencies
npm install axios swr
npm install @tanstack/react-query
npm install react-hook-form @hookform/resolvers zod
npm install date-fns
npm install recharts # for charts
npm install @headlessui/react @heroicons/react
```

**Tech Stack:**
- Next.js 14 (App Router)
- TypeScript
- Tailwind CSS
- React Query (data fetching)
- React Hook Form (forms)
- Recharts (analytics)

---

### 17.2 Authentication UI
**Thời gian:** 1.5 ngày

**Pages:**
- `/login` - Login page
- `/register` - Registration (Admin creates users)
- Redirect logic based on JWT

**Features:**
- JWT storage in localStorage
- Auto-refresh tokens
- Protected routes with middleware

---

### 17.3 Dashboard Overview
**Thời gian:** 2 ngày

**Dashboard Widgets:**
- Tasks summary (Pending, InProgress, Completed)
- Today's schedule
- Recent incidents
- Low inventory alerts
- Active staff count
- Charts: Task completion trends, Staff performance

---

### 17.4 Properties & Units Management
**Thời gian:** 2 ngày

**Features:**
- Properties list with search/filter
- Property detail view
- Units list per property
- Create/Edit property form
- Create/Edit unit form
- Unit status update

---

### 17.5 Task Management UI
**Thời gian:** 3 ngày

**Features:**
- Calendar view of scheduled tasks
- List view with filters (status, user, property, date)
- Task detail modal with checklist
- Assign task to user
- Task status updates
- Photo gallery view

---

### 17.6 Schedule Management
**Thời gian:** 2 ngày

**Features:**
- Schedules list
- Create recurring schedule form
- Edit/Delete schedules
- Preview generated tasks

---

### 17.7 Staff Management
**Thời gian:** 1.5 ngày

**Features:**
- Users list with role filter
- Create user form
- Edit user (role, active status)
- Deactivate user

---

### 17.8 Inventory Management
**Thời gian:** 2 ngày

**Features:**
- Inventory items master list
- Inventory levels by property
- Transaction history
- Record IN/OUT/Adjustment
- Low stock alerts view

---

### 17.9 Reports & Analytics
**Thời gian:** 2 ngày

**Features:**
- Task completion reports (charts)
- Staff performance metrics
- Inventory usage trends
- Incident summary
- Export to CSV

---

## PHASE 18: Mobile App (Tuần 14-18)

### 18.1 React Native Setup
**Thời gian:** 1 ngày

```bash
npx react-native init AriStayMobile --template react-native-template-typescript
cd AriStayMobile

# Install dependencies
npm install @react-navigation/native @react-navigation/stack
npm install react-native-screens react-native-safe-area-context
npm install axios @tanstack/react-query
npm install react-hook-form
npm install react-native-image-picker
npm install @react-native-community/geolocation
npm install @notifee/react-native
npm install @react-native-firebase/app @react-native-firebase/messaging
npm install @react-native-async-storage/async-storage
```

**Alternatif: Flutter**
```bash
flutter create aristay_mobile
cd aristay_mobile

# Add dependencies to pubspec.yaml
# - dio (HTTP)
# - provider (state management)
# - image_picker
# - geolocator
# - firebase_messaging
# - sqflite (offline storage)
```

---

### 18.2 Authentication Flow
**Thời gian:** 1.5 ngày

**Screens:**
- Splash Screen
- Login Screen
- Home Screen (after login)

**Features:**
- JWT storage with AsyncStorage
- Auto-login if token valid
- Logout functionality

---

### 18.3 Task List & Detail
**Thời gian:** 2 ngày

**Screens:**
- Task List (filter by status: My Tasks, Pending, Completed)
- Task Detail Screen

**Features:**
- Pull-to-refresh
- Task status badge
- Tap to view detail
- Quick status update (Start, Complete)

---

### 18.4 Checklist UI
**Thời gian:** 1.5 ngày

**Features:**
- Display checklist items with checkboxes
- Check/uncheck items
- Add notes to checklist item
- Progress indicator (3/10 completed)

---

### 18.5 Camera Integration
**Thời gian:** 2 ngày

```typescript
// React Native
import { launchCamera } from 'react-native-image-picker';

const takePhoto = async () => {
  const result = await launchCamera({
    mediaType: 'photo',
    quality: 0.8,
  });

  if (result.assets && result.assets[0]) {
    const photo = result.assets[0];
    await uploadPhoto(photo.uri);
  }
};
```

**Features:**
- Take photo from camera
- Select from gallery
- Multiple photo upload
- Photo preview before upload
- Upload progress indicator

---

### 18.6 GPS Tracking
**Thời gian:** 1.5 ngày

```typescript
// React Native
import Geolocation from '@react-native-community/geolocation';

Geolocation.getCurrentPosition(
  (position) => {
    const { latitude, longitude } = position.coords;
    // Send with photo upload
  },
  (error) => console.error(error),
  { enableHighAccuracy: true }
);
```

**Features:**
- Get current location when taking photo
- Display location on task detail
- Verify user is at property location (optional)

---

### 18.7 Offline Mode
**Thời gian:** 3 ngày

**Strategy:**
- Use SQLite (sqflite) or AsyncStorage
- Queue actions when offline
- Sync when online
- Conflict resolution

**Features:**
- View tasks offline
- Check checklist items offline
- Queue photos for upload
- Auto-sync when connected

---

### 18.8 Push Notifications
**Thời gian:** 2 ngày

**Setup Firebase:**
```typescript
import messaging from '@react-native-firebase/messaging';

// Request permission
await messaging().requestPermission();

// Get FCM token
const token = await messaging().getToken();

// Send token to backend
await api.post('/users/me/fcm-token', { fcm_token: token });

// Handle foreground messages
messaging().onMessage(async (remoteMessage) => {
  // Display notification
});
```

**Notifications:**
- Task assigned
- Task due soon
- New message
- Low inventory alert

---

### 18.9 Chat/Messaging UI
**Thời gian:** 2 ngày

**Screens:**
- Chat Threads List
- Chat Detail (conversation view)

**Features:**
- Real-time messaging with WebSocket
- Send text & images
- Message read status
- Unread badge count

---

## PHASE 19: Advanced Features (Tuần 19-20)

### 19.1 AI Photo Quality Check
**Thời gian:** 2 ngày

**Integration Options:**
- OpenAI Vision API
- Google Cloud Vision
- AWS Rekognition
- Custom ML model

**Features:**
- Check if photo is blurry
- Verify photo shows expected area (room, pool, etc.)
- Flag low-quality photos
- Auto-reject or request retake

---

### 19.2 Smart Task Routing
**Thời gian:** 1.5 ngày

**Algorithm:**
- Assign based on staff availability
- Assign based on location proximity
- Load balancing (equal task distribution)
- Skill-based routing (pool cleaner → pool tasks)

---

### 19.3 Auto-Scheduling
**Thời gian:** 2 ngày

**Features:**
- Integrate with booking system API (Airbnb, Booking.com)
- Auto-create cleaning task on check-out day
- Auto-schedule maintenance based on usage
- Buffer time between bookings

---

### 19.4 Gamification
**Thời gian:** 1.5 ngày

**Features:**
- Points for completed tasks
- Leaderboard
- Badges (100 tasks, Perfect week, etc.)
- Performance score
- Monthly rewards

---

## PHASE 20: Deployment & DevOps (Tuần 20+)

### 20.1 CI/CD Pipeline
**Thời gian:** 2 ngày

**GitHub Actions Workflow:**

```yaml
# .github/workflows/backend.yml
name: Backend CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run test
      - run: npm run test:e2e

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: your-registry/aristay-backend:latest

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to production
        run: |
          # Deploy script here
```

---

### 20.2 Production Docker Config
**Thời gian:** 1 ngày

**Dockerfile:**

```dockerfile
# Multi-stage build
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:18-alpine AS production

WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./

EXPOSE 3000

CMD ["node", "dist/main"]
```

---

### 20.3 Cloud Deployment
**Thời gian:** 2 ngày

**Options:**

**1. AWS:**
- ECS/Fargate for containers
- RDS PostgreSQL
- ElastiCache Redis
- S3 for media
- CloudFront CDN

**2. Google Cloud:**
- Cloud Run for containers
- Cloud SQL PostgreSQL
- Memorystore Redis
- Cloud Storage
- Cloud CDN

**3. DigitalOcean (Cost-effective):**
- App Platform or Droplets
- Managed PostgreSQL
- Managed Redis
- Spaces (S3-compatible)

**4. Self-hosted:**
- VPS (Ubuntu 22.04)
- Docker Compose
- Nginx reverse proxy
- Let's Encrypt SSL

---

### 20.4 Database Backup Automation
**Thời gian:** 0.5 ngày

**Cron job:**
```bash
# Daily backup at 2 AM
0 2 * * * /path/to/backup.sh

# Backup script uploads to S3
aws s3 cp /backups/aristay_$(date +%Y%m%d).sql.gz s3://aristay-backups/
```

**Retention policy:**
- Daily backups: Keep 7 days
- Weekly backups: Keep 4 weeks
- Monthly backups: Keep 12 months

---

### 20.5 Monitoring & Logging
**Thời gian:** 1.5 ngày

**Tools:**
- **Sentry:** Error tracking
- **LogRocket:** User session replay (frontend)
- **Datadog / New Relic:** APM
- **Pino + Elasticsearch:** Log aggregation
- **Prometheus + Grafana:** Metrics

**Alerts:**
- High error rate
- API response time >2s
- Database connection failures
- Disk space >80%

---

### 20.6 Performance Optimization
**Thời gian:** 1.5 ngày

**Backend:**
- Add Redis caching for frequently accessed data
- Database query optimization (indexes)
- Connection pooling
- Implement pagination everywhere
- Rate limiting

**Frontend:**
- Code splitting
- Image lazy loading
- Memoization (React.memo)
- Service worker for PWA

---

### 20.7 Security Audit
**Thời gian:** 1.5 ngày

**Checklist:**
- ✅ SQL injection prevention (TypeORM parameterized queries)
- ✅ XSS prevention (input sanitization)
- ✅ CSRF protection
- ✅ Rate limiting on auth endpoints
- ✅ Helmet.js security headers
- ✅ HTTPS only
- ✅ Environment secrets not in code
- ✅ JWT token expiration
- ✅ Password strength requirements
- ✅ File upload validation (type, size)
- ✅ CORS configuration
- ✅ API authentication on all protected routes

**Tools:**
- `npm audit` for dependency vulnerabilities
- OWASP ZAP for penetration testing
- SonarQube for code quality

---

## Tổng Kết Timeline

### **MVP (Minimum Viable Product) - 12 Tuần**
- ✅ Phase 1-8: Backend core features
- ✅ Phase 17 (partial): Basic admin dashboard
- ✅ Phase 18 (partial): Basic mobile app
- ⏳ Deployment on staging environment

### **Full Version - 20 Tuần**
- ✅ All phases completed
- ✅ Advanced features (AI, automation)
- ✅ Production deployment
- ✅ Mobile app on App Store/Play Store

---

## Phân Công Nhóm (Recommended)

### **Team của 5 người:**

**1. Backend Lead (1 người):**
- Phase 1-16 (Backend development)
- Database management
- API testing

**2. Frontend Developer (2 người):**
- Developer 1: Admin Dashboard (Phase 17)
- Developer 2: Mobile App (Phase 18)

**3. DevOps Engineer (1 người):**
- Docker setup
- CI/CD pipeline
- Cloud deployment
- Monitoring

**4. Full-stack Developer (1 người):**
- Support backend & frontend
- Advanced features (Phase 19)
- Testing & bug fixes

---

## Chi Phí Ước Tính (Monthly)

### **Development Phase:**
- Developers (5 người x $3000/tháng): **$15,000/tháng** x 5 tháng = **$75,000**

### **Infrastructure (Production):**
- **Option 1: DigitalOcean (Small scale)**
  - App Platform: $12/month
  - Managed PostgreSQL: $15/month
  - Managed Redis: $15/month
  - Spaces (100GB): $5/month
  - **Total: ~$50/month**

- **Option 2: AWS (Scalable)**
  - ECS Fargate: ~$30/month
  - RDS PostgreSQL: ~$50/month
  - ElastiCache: ~$15/month
  - S3: ~$10/month
  - **Total: ~$150/month**

### **Third-party Services:**
- Firebase (FCM): Free tier → $25/month
- Sentry: Free tier → $26/month
- OpenAI API (photo check): ~$50/month
- **Total: ~$100/month**

### **Grand Total:**
- Development: **$75,000** (one-time)
- Monthly operational: **$50-250/month**

---

## Rủi Ro & Giảm Thiểu

### **Rủi Ro 1: Timeline trễ hạn**
**Giảm thiểu:**
- Agile sprints (2-week cycles)
- Daily standups
- Code reviews để catch bugs sớm

### **Rủi Ro 2: Scope creep (tính năng thêm liên tục)**
**Giảm thiểu:**
- Strict MVP scope
- Feature requests go to backlog for v2

### **Rủi Ro 3: Offline sync conflicts**
**Giảm thiểu:**
- Implement "last write wins" strategy
- Timestamp-based conflict resolution

### **Rủi Ro 4: Security breaches**
**Giảm thiểu:**
- Regular security audits
- Penetration testing
- Bug bounty program

---

## Next Steps (Bước Tiếp Theo)

### **Tuần này:**
1. ✅ Review action plan này
2. ⏳ Set up development environment (Docker)
3. ⏳ Initialize NestJS project
4. ⏳ Create first module (Auth)

### **Tuần tới:**
1. Complete Auth module
2. Set up CI/CD pipeline
3. Begin Properties module

---

## Tài Liệu Tham Khảo

- **NestJS Documentation:** https://docs.nestjs.com
- **TypeORM Documentation:** https://typeorm.io
- **React Native Documentation:** https://reactnative.dev
- **Next.js Documentation:** https://nextjs.org/docs
- **Firebase Cloud Messaging:** https://firebase.google.com/docs/cloud-messaging
- **AWS SDK for JavaScript:** https://docs.aws.amazon.com/sdk-for-javascript

---

**Tài liệu này được tạo:** 2025-11-10
**Phiên bản:** 1.0
**Người tạo:** Claude AI
