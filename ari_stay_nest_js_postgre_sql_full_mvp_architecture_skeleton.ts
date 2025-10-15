# Project: arista y‑api (NestJS + PostgreSQL, JWT Refresh, S3, FCM, BullMQ)

> Skeleton codebase following the MVP architecture we defined. This is **dev‑ready** but intentionally light: entities, DTOs, controllers, basic services, and infrastructure (Docker Compose for Postgres + Redis + MinIO). You can run and iterate module by module.

---

## File tree
```
aristay-api/
├─ package.json
├─ tsconfig.json
├─ tsconfig.build.json
├─ nest-cli.json
├─ .env.example
├─ docker-compose.yml
├─ README.md
└─ src/
   ├─ main.ts
   ├─ app.module.ts
   ├─ common/
   │  ├─ dto/pagination.dto.ts
   │  ├─ guards/jwt-auth.guard.ts
   │  ├─ interceptors/transform.interceptor.ts
   │  └─ utils/kind.ts
   ├─ config/
   │  ├─ app.config.ts
   │  ├─ db.config.ts
   │  ├─ jwt.config.ts
   │  ├─ s3.config.ts
   │  └─ fcm.config.ts
   ├─ database/
   │  └─ typeorm.config.ts
   ├─ auth/
   │  ├─ auth.module.ts
   │  ├─ auth.controller.ts
   │  ├─ auth.service.ts
   │  ├─ strategies/
   │  │  ├─ jwt-access.strategy.ts
   │  │  └─ jwt-refresh.strategy.ts
   │  ├─ dto/
   │  │  ├─ login.dto.ts
   │  │  ├─ register.dto.ts
   │  │  └─ refresh.dto.ts
   │  └─ entities/
   │     └─ refresh-token.entity.ts
   ├─ users/
   │  ├─ users.module.ts
   │  ├─ users.controller.ts
   │  ├─ users.service.ts
   │  └─ user.entity.ts
   ├─ properties/
   │  ├─ properties.module.ts
   │  ├─ properties.controller.ts
   │  ├─ properties.service.ts
   │  └─ entities/{property.entity.ts, unit.entity.ts}
   ├─ tasks/
   │  ├─ tasks.module.ts
   │  ├─ tasks.controller.ts
   │  ├─ tasks.service.ts
   │  └─ entities/{schedule.entity.ts, task.entity.ts, checklist-template.entity.ts, checklist.entity.ts, media.entity.ts}
   ├─ incidents/
   │  ├─ incidents.module.ts
   │  ├─ incidents.controller.ts
   │  ├─ incidents.service.ts
   │  └─ entities/{incident.entity.ts, lostfound.entity.ts}
   ├─ inventory/
   │  ├─ inventory.module.ts
   │  ├─ inventory.controller.ts
   │  ├─ inventory.service.ts
   │  └─ entities/{item.entity.ts, level.entity.ts, txn.entity.ts}
   ├─ laundry/
   │  ├─ laundry.module.ts
   │  ├─ laundry.controller.ts
   │  ├─ laundry.service.ts
   │  └─ entities/{order.entity.ts, step.entity.ts}
   ├─ lawnpool/
   │  ├─ lawnpool.module.ts
   │  ├─ lawnpool.controller.ts
   │  ├─ lawnpool.service.ts
   │  └─ entities/profile.entity.ts
   ├─ chat/
   │  ├─ chat.module.ts
   │  ├─ chat.controller.ts
   │  ├─ chat.service.ts
   │  └─ entities/{thread.entity.ts, participant.entity.ts, message.entity.ts}
   ├─ notifications/
   │  ├─ notifications.module.ts
   │  ├─ notifications.service.ts
   │  └─ fcm.client.ts
   ├─ files/
   │  ├─ files.module.ts
   │  ├─ files.controller.ts
   │  ├─ files.service.ts
   │  └─ s3.client.ts
   └─ reports/
      ├─ reports.module.ts
      ├─ reports.controller.ts
      └─ reports.service.ts
```

---

## package.json
```json
{
  "name": "aristay-api",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "start": "nest start",
    "start:dev": "nest start --watch",
    "build": "nest build",
    "lint": "eslint .",
    "format": "prettier --write \"src/**/*.ts\""
  },
  "dependencies": {
    "@nestjs/common": "^10.0.0",
    "@nestjs/core": "^10.0.0",
    "@nestjs/platform-express": "^10.0.0",
    "@nestjs/config": "^3.2.2",
    "@nestjs/jwt": "^10.2.0",
    "@nestjs/passport": "^10.0.3",
    "@nestjs/swagger": "^7.4.2",
    "@nestjs/terminus": "^10.2.3",
    "bullmq": "^5.9.0",
    "ioredis": "^5.4.1",
    "passport": "^0.7.0",
    "passport-jwt": "^4.0.1",
    "bcryptjs": "^2.4.3",
    "class-transformer": "^0.5.1",
    "class-validator": "^0.14.1",
    "typeorm": "^0.3.20",
    "pg": "^8.11.5",
    "aws-sdk": "^2.1611.0",
    "reflect-metadata": "^0.2.2",
    "rxjs": "^7.8.1",
    "pino-pretty": "^11.2.1",
    "nestjs-pino": "^4.0.0"
  },
  "devDependencies": {
    "@nestjs/cli": "^10.0.0",
    "@nestjs/schematics": "^10.0.0",
    "@nestjs/testing": "^10.0.0",
    "@types/bcryptjs": "^2.4.2",
    "@types/node": "^20.11.30",
    "prettier": "^3.3.3",
    "ts-node": "^10.9.2",
    "typescript": "^5.5.4"
  }
}
```

---

## .env.example
```env
# HTTP
PORT=3000
NODE_ENV=development

# Postgres
DB_HOST=postgres
DB_PORT=5432
DB_NAME=aristay
DB_USER=postgres
DB_PASS=postgres

# Redis (BullMQ)
REDIS_HOST=redis
REDIS_PORT=6379

# JWT
JWT_ACCESS_SECRET=change_me_access
JWT_ACCESS_EXPIRES=15m
JWT_REFRESH_SECRET=change_me_refresh
JWT_REFRESH_EXPIRES=7d

# S3 (MinIO for local)
S3_ENDPOINT=http://minio:9000
S3_USE_SSL=false
S3_BUCKET=aristay
S3_ACCESS_KEY=minioadmin
S3_SECRET_KEY=minioadmin

# FCM
FCM_SERVER_KEY=change_me
```

---

## docker-compose.yml
```yaml
version: '3.9'
services:
  api:
    image: node:20
    working_dir: /app
    command: sh -c "npm i -g pnpm && pnpm i && pnpm start:dev"
    ports: ["3000:3000"]
    environment:
      - PORT=3000
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=aristay
      - DB_USER=postgres
      - DB_PASS=postgres
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - S3_ENDPOINT=http://minio:9000
      - S3_USE_SSL=false
      - S3_BUCKET=aristay
      - S3_ACCESS_KEY=minioadmin
      - S3_SECRET_KEY=minioadmin
      - JWT_ACCESS_SECRET=dev_access
      - JWT_REFRESH_SECRET=dev_refresh
    depends_on: [postgres, redis, minio]
    volumes:
      - ./:/app

  postgres:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: aristay
    ports: ["5432:5432"]
    volumes:
      - pgdata:/var/lib/postgresql/data

  redis:
    image: redis:7
    ports: ["6379:6379"]

  minio:
    image: minio/minio:latest
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
    ports:
      - "9000:9000"
      - "9001:9001"
    volumes:
      - minio:/data

volumes:
  pgdata:
  minio:
```

---

## src/main.ts
```ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { Logger } from 'nestjs-pino';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { bufferLogs: true });
  app.useLogger(app.get(Logger));
  app.enableCors();
  app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
  await app.listen(process.env.PORT || 3000);
}
bootstrap();
```

---

## src/app.module.ts
```ts
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from 'typeorm';
import { LoggerModule } from 'nestjs-pino';
import appConfig from './config/app.config';
import dbConfig from './config/db.config';
import jwtConfig from './config/jwt.config';
import s3Config from './config/s3.config';
import fcmConfig from './config/fcm.config';
import { typeOrmConfig } from './database/typeorm.config';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { PropertiesModule } from './properties/properties.module';
import { TasksModule } from './tasks/tasks.module';
import { IncidentsModule } from './incidents/incidents.module';
import { InventoryModule } from './inventory/inventory.module';
import { LaundryModule } from './laundry/laundry.module';
import { LawnPoolModule } from './lawnpool/lawnpool.module';
import { ChatModule } from './chat/chat.module';
import { FilesModule } from './files/files.module';
import { NotificationsModule } from './notifications/notifications.module';
import { ReportsModule } from './reports/reports.module';

@Module({
  imports: [
    LoggerModule.forRoot({}),
    ConfigModule.forRoot({ isGlobal: true, load: [appConfig, dbConfig, jwtConfig, s3Config, fcmConfig] }),
    TypeOrmModule.forRootAsync({ useFactory: () => typeOrmConfig }),
    AuthModule,
    UsersModule,
    PropertiesModule,
    TasksModule,
    IncidentsModule,
    InventoryModule,
    LaundryModule,
    LawnPoolModule,
    ChatModule,
    FilesModule,
    NotificationsModule,
    ReportsModule,
  ],
})
export class AppModule {}
```

---

## src/config/db.config.ts
```ts
export default () => ({
  db: {
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT || 5432),
    name: process.env.DB_NAME || 'aristay',
    user: process.env.DB_USER || 'postgres',
    pass: process.env.DB_PASS || 'postgres',
  },
});
```

## src/database/typeorm.config.ts
```ts
import { TypeOrmModuleOptions } from 'typeorm';
import { User } from '../users/user.entity';
import { Property } from '../properties/entities/property.entity';
import { Unit } from '../properties/entities/unit.entity';
import { Schedule } from '../tasks/entities/schedule.entity';
import { Task } from '../tasks/entities/task.entity';
import { ChecklistTemplate, ChecklistTemplateItem } from '../tasks/entities/checklist-template.entity';
import { Checklist, ChecklistItem } from '../tasks/entities/checklist.entity';
import { Media } from '../tasks/entities/media.entity';
import { Incident } from '../incidents/entities/incident.entity';
import { LostFound } from '../incidents/entities/lostfound.entity';
import { InventoryItem } from '../inventory/entities/item.entity';
import { InventoryLevel } from '../inventory/entities/level.entity';
import { InventoryTxn } from '../inventory/entities/txn.entity';
import { LaundryOrder } from '../laundry/entities/order.entity';
import { LaundryStep } from '../laundry/entities/step.entity';
import { YardPoolProfile } from '../lawnpool/entities/profile.entity';
import { Thread } from '../chat/entities/thread.entity';
import { Participant } from '../chat/entities/participant.entity';
import { Message } from '../chat/entities/message.entity';
import { RefreshToken } from '../auth/entities/refresh-token.entity';

export const typeOrmConfig: TypeOrmModuleOptions = {
  type: 'postgres',
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT || 5432),
  database: process.env.DB_NAME,
  username: process.env.DB_USER,
  password: process.env.DB_PASS,
  entities: [
    User,
    Property,
    Unit,
    Schedule,
    Task,
    ChecklistTemplate,
    ChecklistTemplateItem,
    Checklist,
    ChecklistItem,
    Media,
    Incident,
    LostFound,
    InventoryItem,
    InventoryLevel,
    InventoryTxn,
    LaundryOrder,
    LaundryStep,
    YardPoolProfile,
    Thread,
    Participant,
    Message,
    RefreshToken,
  ],
  synchronize: true, // DEV ONLY; replace with migrations in prod
};
```

---

## src/users/user.entity.ts (UUID + roles)
```ts
import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, Index } from 'typeorm';

export type UserRole = 'Admin' | 'Cleaning' | 'Maintenance' | 'Laundry' | 'LawnPool';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid') id!: string;

  @Index({ unique: true })
  @Column('text') email!: string;

  @Column('text') passwordHash!: string;

  @Column('text') fullName!: string;

  @Column('text', { default: 'Cleaning' }) role!: UserRole;

  @Column('text', { default: 'Active' }) status!: 'Active' | 'Inactive';

  @CreateDateColumn() createdAt!: Date;
  @UpdateDateColumn() updatedAt!: Date;
}
```

---

## src/auth (JWT access + refresh, Passport)
### entities/refresh-token.entity.ts
```ts
import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, CreateDateColumn, Index } from 'typeorm';
import { User } from '../../users/user.entity';

@Entity('refresh_tokens')
export class RefreshToken {
  @PrimaryGeneratedColumn('uuid') id!: string;

  @Index()
  @Column('text') token!: string; // hashed if you prefer

  @ManyToOne(() => User, { onDelete: 'CASCADE' }) user!: User;

  @Column('timestamptz') expiresAt!: Date;

  @CreateDateColumn() createdAt!: Date;
}
```

### dto/login + register + refresh
```ts
// login.dto.ts
import { IsEmail, MinLength } from 'class-validator';
export class LoginDto { @IsEmail() email!: string; @MinLength(6) password!: string; }

// register.dto.ts
import { IsEmail, IsIn, IsNotEmpty, MinLength } from 'class-validator';
export class RegisterDto {
  @IsEmail() email!: string;
  @MinLength(6) password!: string;
  @IsNotEmpty() fullName!: string;
  @IsIn(['Admin','Cleaning','Maintenance','Laundry','LawnPool']) role!: string;
}

// refresh.dto.ts
import { IsNotEmpty } from 'class-validator';
export class RefreshDto { @IsNotEmpty() refreshToken!: string; }
```

### strategies (JWT access/refresh)
```ts
// jwt-access.strategy.ts
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { Injectable } from '@nestjs/common';

@Injectable()
export class JwtAccessStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: process.env.JWT_ACCESS_SECRET,
    });
  }
  async validate(payload: any) { return payload; }
}

// jwt-refresh.strategy.ts
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-jwt';
import { Injectable } from '@nestjs/common';

function fromBodyRefreshToken(req: any) { return req?.body?.refreshToken || null; }

@Injectable()
export class JwtRefreshStrategy extends PassportStrategy(Strategy, 'jwt-refresh') {
  constructor() {
    super({ jwtFromRequest: fromBodyRefreshToken, secretOrKey: process.env.JWT_REFRESH_SECRET });
  }
  async validate(payload: any) { return payload; }
}
```

### auth.module/service/controller
```ts
// auth.module.ts
import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { UsersModule } from '../users/users.module';
import { RefreshToken } from './entities/refresh-token.entity';
import { JwtAccessStrategy } from './strategies/jwt-access.strategy';
import { JwtRefreshStrategy } from './strategies/jwt-refresh.strategy';

@Module({
  imports: [
    UsersModule,
    TypeOrmModule.forFeature([RefreshToken]),
    JwtModule.register({}),
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtAccessStrategy, JwtRefreshStrategy],
})
export class AuthModule {}

// auth.service.ts
import { Injectable, ConflictException, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcryptjs';
import { UsersService } from '../users/users.service';
import { RefreshToken } from './entities/refresh-token.entity';

@Injectable()
export class AuthService {
  constructor(
    private readonly users: UsersService,
    private readonly jwt: JwtService,
    @InjectRepository(RefreshToken) private readonly rtRepo: Repository<RefreshToken>,
  ) {}

  private signAccess(payload: any) {
    return this.jwt.sign(payload, {
      secret: process.env.JWT_ACCESS_SECRET,
      expiresIn: process.env.JWT_ACCESS_EXPIRES || '15m',
    });
  }
  private signRefresh(payload: any) {
    return this.jwt.sign(payload, {
      secret: process.env.JWT_REFRESH_SECRET,
      expiresIn: process.env.JWT_REFRESH_EXPIRES || '7d',
    });
  }

  async register(data: { email: string; password: string; fullName: string; role: string }) {
    const exists = await this.users.findByEmail(data.email);
    if (exists) throw new ConflictException('Email already exists');
    const user = await this.users.createWithPassword(data);
    return { id: user.id, email: user.email };
  }

  async login(email: string, password: string) {
    const user = await this.users.findByEmail(email);
    if (!user) throw new UnauthorizedException('Invalid credentials');
    const ok = await bcrypt.compare(password, user.passwordHash);
    if (!ok) throw new UnauthorizedException('Invalid credentials');

    const payload = { sub: user.id, email: user.email, role: user.role };
    const accessToken = this.signAccess(payload);
    const refreshToken = this.signRefresh({ sub: user.id });

    const rt = this.rtRepo.create({ token: refreshToken, user: user as any, expiresAt: new Date(Date.now() + 7*24*3600*1000) });
    await this.rtRepo.save(rt);

    return { accessToken, refreshToken, user: { id: user.id, email: user.email, fullName: user.fullName, role: user.role } };
  }

  async refresh(refreshToken: string) {
    try {
      const payload = this.jwt.verify(refreshToken, { secret: process.env.JWT_REFRESH_SECRET });
      const record = await this.rtRepo.findOne({ where: { token: refreshToken }, relations: ['user'] });
      if (!record) throw new UnauthorizedException('Invalid refresh token');
      const accessToken = this.signAccess({ sub: record.user.id, email: record.user.email, role: record.user.role });
      return { accessToken };
    } catch {
      throw new UnauthorizedException('Invalid refresh token');
    }
  }
}

// auth.controller.ts
import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';

@Controller('auth')
export class AuthController {
  constructor(private readonly auth: AuthService) {}

  @Post('register') register(@Body() body: any) { return this.auth.register(body); }
  @Post('login') login(@Body() body: any) { return this.auth.login(body.email, body.password); }
  @Post('refresh') refresh(@Body() body: any) { return this.auth.refresh(body.refreshToken); }
}
```

---

## src/users (service exposes helpers for auth)
```ts
// users.service.ts (excerpt)
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcryptjs';
import { User } from './user.entity';

@Injectable()
export class UsersService {
  constructor(@InjectRepository(User) private readonly repo: Repository<User>) {}

  findByEmail(email: string) { return this.repo.findOne({ where: { email } }); }

  async createWithPassword(data: { email: string; password: string; fullName: string; role: string }) {
    const passwordHash = await bcrypt.hash(data.password, 10);
    const user = this.repo.create({ email: data.email, passwordHash, fullName: data.fullName, role: data.role as any });
    return this.repo.save(user);
  }
}
```

---

## src/properties/entities
```ts
// property.entity.ts
import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';
@Entity('properties')
export class Property { @PrimaryGeneratedColumn('uuid') id!: string; @Column('text') name!: string; @Column('text') address!: string; @Column('text', { nullable: true }) notes?: string; @Column('bool', { default: true }) active!: boolean; }

// unit.entity.ts
import { Entity, Column, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';
import { Property } from './property.entity';
@Entity('units')
export class Unit { @PrimaryGeneratedColumn('uuid') id!: string; @ManyToOne(() => Property, { onDelete: 'CASCADE' }) property!: Property; @Column('text') code!: string; @Column('int',{nullable:true}) floor?: number; @Column('int',{nullable:true}) beds?: number; @Column('text',{default:'Ready'}) status!: string; }
```

---

## src/tasks/entities (key ones)
```ts
// schedule.entity.ts
import { Entity, Column, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';
import { Property } from '../../properties/entities/property.entity';
import { Unit } from '../../properties/entities/unit.entity';
@Entity('schedules')
export class Schedule {
  @PrimaryGeneratedColumn('uuid') id!: string;
  @Column('text') type!: string; // Cleaning|Maintenance|Laundry|LawnPool
  @ManyToOne(() => Property) property!: Property;
  @ManyToOne(() => Unit, { nullable: true }) unit?: Unit;
  @Column('timestamptz') startAt!: Date;
  @Column('timestamptz') endAt!: Date;
  @Column('jsonb', { nullable: true }) recurrence?: any;
  @Column('text', { default: 'Manual' }) source!: string;
  @Column('text', { nullable: true }) color?: string;
}

// task.entity.ts
import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { Property } from '../../properties/entities/property.entity';
import { Unit } from '../../properties/entities/unit.entity';
import { User } from '../../users/user.entity';
@Entity('tasks')
export class Task {
  @PrimaryGeneratedColumn('uuid') id!: string;
  @Column('text') type!: string; // Cleaning, Maintenance, Laundry, LawnPool, ToDo
  @Column('text') title!: string;
  @Column('text', { nullable: true }) description?: string;
  @ManyToOne(() => Property) property!: Property;
  @ManyToOne(() => Unit, { nullable: true }) unit?: Unit;
  @ManyToOne(() => User, { nullable: true }) assignee?: User;
  @Column('text', { default: 'Pending' }) status!: string;
  @Column('timestamptz', { nullable: true }) dueAt?: Date;
  @CreateDateColumn() createdAt!: Date;
  @UpdateDateColumn() updatedAt!: Date;
}

// checklist-template.entity.ts
import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';
@Entity('task_checklist_templates')
export class ChecklistTemplate { @PrimaryGeneratedColumn('uuid') id!: string; @Column('text') type!: string; @Column('text') name!: string; }
@Entity('task_checklist_template_items')
export class ChecklistTemplateItem { @PrimaryGeneratedColumn('uuid') id!: string; @Column('text') label!: string; @Column('bool') required!: boolean; @Column('uuid') templateId!: string; }

// checklist.entity.ts
import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';
@Entity('task_checklists')
export class Checklist { @PrimaryGeneratedColumn('uuid') id!: string; @Column('uuid') taskId!: string; }
@Entity('task_checklist_items')
export class ChecklistItem { @PrimaryGeneratedColumn('uuid') id!: string; @Column('uuid') checklistId!: string; @Column('text') label!: string; @Column('bool') required!: boolean; @Column('text',{default:'Open'}) status!: string; @Column('text',{nullable:true}) note?: string; }

// media.entity.ts
import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';
@Entity('task_media')
export class Media { @PrimaryGeneratedColumn('uuid') id!: string; @Column('uuid') taskId!: string; @Column('text') kind!: string; @Column('text') url!: string; @Column('numeric',{precision:9,scale:6,nullable:true}) gps_lat?: number; @Column('numeric',{precision:9,scale:6,nullable:true}) gps_lng?: number; @Column('timestamptz',{nullable:true}) taken_at?: Date; @Column('text',{nullable:true}) device?: string; }
```

---

## src/files (S3 upload presigned)
```ts
// s3.client.ts
import AWS from 'aws-sdk';
export function s3() {
  const endpoint = new AWS.Endpoint(process.env.S3_ENDPOINT!.replace('http://','').replace('https://',''));
  return new AWS.S3({
    endpoint: process.env.S3_ENDPOINT,
    s3ForcePathStyle: true,
    signatureVersion: 'v4',
    accessKeyId: process.env.S3_ACCESS_KEY,
    secretAccessKey: process.env.S3_SECRET_KEY,
    sslEnabled: process.env.S3_USE_SSL === 'true',
  });
}

// files.service.ts (excerpt)
import { Injectable } from '@nestjs/common';
import { s3 } from './s3.client';
@Injectable()
export class FilesService {
  async getPresignedPut(key: string, contentType: string) {
    const client = s3();
    const params = { Bucket: process.env.S3_BUCKET!, Key: key, Expires: 600, ContentType: contentType };
    const url = await client.getSignedUrlPromise('putObject', params);
    return { url, key };
  }
}

// files.controller.ts
import { Controller, Get, Query } from '@nestjs/common';
import { FilesService } from './files.service';
@Controller('files')
export class FilesController {
  constructor(private readonly srv: FilesService) {}
  @Get('presign') presign(@Query('key') key: string, @Query('contentType') contentType: string) { return this.srv.getPresignedPut(key, contentType); }
}
```

---

## src/notifications (FCM send)
```ts
// fcm.client.ts
import fetch from 'node-fetch';
export async function fcmSend(token: string, title: string, body: string) {
  const resp = await fetch('https://fcm.googleapis.com/fcm/send', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Authorization: `key=${process.env.FCM_SERVER_KEY}` },
    body: JSON.stringify({ to: token, notification: { title, body } }),
  });
  return resp.json();
}
```

---

## README.md (quick start)
```md
# AriStay API — Full MVP Skeleton

### 1) Run stack
docker compose up -d

### 2) Install deps inside host and run API
pnpm i # or npm/yarn
pnpm start:dev

### 3) Create first admin
POST http://localhost:3000/auth/register { email, password, fullName, role: 'Admin' }
POST http://localhost:3000/auth/login { email, password } → accessToken/refreshToken

### 4) Upload flow
GET  /files/presign?key=uploads/test.jpg&contentType=image/jpeg → url
PUT  url (binary body)

### Notes
- TypeORM `synchronize: true` for dev; switch to migrations in prod.
- JWT access/refresh, S3 via MinIO, Redis for queues (BullMQ wiring template ready).
- Add endpoints gradually to modules (Tasks, Inventory, Laundry, Lawn/Pool, Chat, Reports).
