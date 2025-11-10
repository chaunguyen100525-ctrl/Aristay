-- ============================================================================
-- AriStay Database Schema
-- PostgreSQL 16+
-- Description: Complete database schema for AriStay property management system
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- AUTHENTICATION & USERS
-- ============================================================================

-- Users table: Store all system users with roles
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    full_name TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'Cleaning' CHECK (role IN ('Admin', 'Cleaning', 'Maintenance', 'Laundry', 'LawnPool')),
    status TEXT NOT NULL DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE users IS 'System users with role-based access';
COMMENT ON COLUMN users.role IS 'User role: Admin, Cleaning, Maintenance, Laundry, LawnPool';
COMMENT ON COLUMN users.status IS 'User status: Active or Inactive';

-- Create index on email for faster lookups
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_status ON users(status);

-- Refresh tokens table: Store JWT refresh tokens
CREATE TABLE refresh_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    token TEXT NOT NULL,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE refresh_tokens IS 'JWT refresh tokens for authentication';

CREATE INDEX idx_refresh_tokens_token ON refresh_tokens(token);
CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);

-- ============================================================================
-- PROPERTIES & UNITS
-- ============================================================================

-- Properties table: Store property information
CREATE TABLE properties (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    notes TEXT,
    active BOOLEAN NOT NULL DEFAULT true
);

COMMENT ON TABLE properties IS 'Properties/buildings managed by the system';
COMMENT ON COLUMN properties.active IS 'Whether the property is actively managed';

CREATE INDEX idx_properties_active ON properties(active);

-- Units table: Individual units/rooms within properties
CREATE TABLE units (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
    code TEXT NOT NULL,
    floor INTEGER,
    beds INTEGER,
    status TEXT NOT NULL DEFAULT 'Ready' CHECK (status IN ('Ready', 'Occupied', 'Maintenance', 'Blocked'))
);

COMMENT ON TABLE units IS 'Individual units/rooms within properties';
COMMENT ON COLUMN units.code IS 'Unit identifier (e.g., room number, unit code)';
COMMENT ON COLUMN units.status IS 'Unit status: Ready, Occupied, Maintenance, Blocked';

CREATE INDEX idx_units_property_id ON units(property_id);
CREATE INDEX idx_units_status ON units(status);
CREATE UNIQUE INDEX idx_units_property_code ON units(property_id, code);

-- ============================================================================
-- SCHEDULES & TASKS
-- ============================================================================

-- Schedules table: Recurring and one-time schedules
CREATE TABLE schedules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type TEXT NOT NULL CHECK (type IN ('Cleaning', 'Maintenance', 'Laundry', 'LawnPool')),
    property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
    unit_id UUID REFERENCES units(id) ON DELETE CASCADE,
    start_at TIMESTAMPTZ NOT NULL,
    end_at TIMESTAMPTZ NOT NULL,
    recurrence JSONB,
    source TEXT NOT NULL DEFAULT 'Manual' CHECK (source IN ('Manual', 'CSV', 'API')),
    color TEXT
);

COMMENT ON TABLE schedules IS 'Task schedules (recurring or one-time)';
COMMENT ON COLUMN schedules.type IS 'Schedule type: Cleaning, Maintenance, Laundry, LawnPool';
COMMENT ON COLUMN schedules.recurrence IS 'Recurrence pattern in JSON format (e.g., {"frequency": "daily", "interval": 1})';
COMMENT ON COLUMN schedules.source IS 'Source of schedule: Manual, CSV import, API';

CREATE INDEX idx_schedules_property_id ON schedules(property_id);
CREATE INDEX idx_schedules_unit_id ON schedules(unit_id);
CREATE INDEX idx_schedules_type ON schedules(type);
CREATE INDEX idx_schedules_start_at ON schedules(start_at);

-- Tasks table: Individual tasks
CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type TEXT NOT NULL CHECK (type IN ('Cleaning', 'Maintenance', 'Laundry', 'LawnPool', 'ToDo')),
    title TEXT NOT NULL,
    description TEXT,
    property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
    unit_id UUID REFERENCES units(id) ON DELETE CASCADE,
    assignee_id UUID REFERENCES users(id) ON DELETE SET NULL,
    status TEXT NOT NULL DEFAULT 'Pending' CHECK (status IN ('Pending', 'InProgress', 'Completed', 'Cancelled', 'Overdue')),
    due_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE tasks IS 'Individual tasks assigned to users';
COMMENT ON COLUMN tasks.type IS 'Task type: Cleaning, Maintenance, Laundry, LawnPool, ToDo';
COMMENT ON COLUMN tasks.status IS 'Task status: Pending, InProgress, Completed, Cancelled, Overdue';

CREATE INDEX idx_tasks_property_id ON tasks(property_id);
CREATE INDEX idx_tasks_unit_id ON tasks(unit_id);
CREATE INDEX idx_tasks_assignee_id ON tasks(assignee_id);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_type ON tasks(type);
CREATE INDEX idx_tasks_due_at ON tasks(due_at);

-- Checklist templates table: Reusable checklist templates
CREATE TABLE task_checklist_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type TEXT NOT NULL,
    name TEXT NOT NULL
);

COMMENT ON TABLE task_checklist_templates IS 'Reusable checklist templates for different task types';

CREATE INDEX idx_checklist_templates_type ON task_checklist_templates(type);

-- Checklist template items table: Items within templates
CREATE TABLE task_checklist_template_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    template_id UUID NOT NULL REFERENCES task_checklist_templates(id) ON DELETE CASCADE,
    label TEXT NOT NULL,
    required BOOLEAN NOT NULL DEFAULT false
);

COMMENT ON TABLE task_checklist_template_items IS 'Items within checklist templates';

CREATE INDEX idx_checklist_template_items_template_id ON task_checklist_template_items(template_id);

-- Task checklists table: Checklist instances for tasks
CREATE TABLE task_checklists (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE
);

COMMENT ON TABLE task_checklists IS 'Checklist instances associated with tasks';

CREATE INDEX idx_task_checklists_task_id ON task_checklists(task_id);

-- Task checklist items table: Items within task checklists
CREATE TABLE task_checklist_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    checklist_id UUID NOT NULL REFERENCES task_checklists(id) ON DELETE CASCADE,
    label TEXT NOT NULL,
    required BOOLEAN NOT NULL DEFAULT false,
    status TEXT NOT NULL DEFAULT 'Open' CHECK (status IN ('Open', 'Completed', 'Skipped')),
    note TEXT
);

COMMENT ON TABLE task_checklist_items IS 'Individual items within task checklists';

CREATE INDEX idx_task_checklist_items_checklist_id ON task_checklist_items(checklist_id);
CREATE INDEX idx_task_checklist_items_status ON task_checklist_items(status);

-- Task media table: Photos and media for proof of work
CREATE TABLE task_media (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    kind TEXT NOT NULL CHECK (kind IN ('Before', 'After', 'During', 'Issue', 'Other')),
    url TEXT NOT NULL,
    gps_lat NUMERIC(9, 6),
    gps_lng NUMERIC(9, 6),
    taken_at TIMESTAMPTZ,
    device TEXT
);

COMMENT ON TABLE task_media IS 'Media files (photos) associated with tasks for proof of work';
COMMENT ON COLUMN task_media.kind IS 'Media type: Before, After, During, Issue, Other';
COMMENT ON COLUMN task_media.gps_lat IS 'GPS latitude where photo was taken';
COMMENT ON COLUMN task_media.gps_lng IS 'GPS longitude where photo was taken';

CREATE INDEX idx_task_media_task_id ON task_media(task_id);
CREATE INDEX idx_task_media_kind ON task_media(kind);

-- ============================================================================
-- INCIDENTS & LOST & FOUND
-- ============================================================================

-- Incidents table: Damage reports and issues
CREATE TABLE incidents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
    unit_id UUID REFERENCES units(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('Damage', 'Malfunction', 'Safety', 'Cleanliness', 'Other')),
    severity TEXT NOT NULL DEFAULT 'Low' CHECK (severity IN ('Low', 'Medium', 'High', 'Urgent')),
    description TEXT NOT NULL,
    photos JSONB,
    status TEXT NOT NULL DEFAULT 'Open' CHECK (status IN ('Open', 'InProgress', 'Resolved', 'Closed')),
    reported_by_id UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE incidents IS 'Incident reports (damage, malfunction, safety issues)';
COMMENT ON COLUMN incidents.type IS 'Incident type: Damage, Malfunction, Safety, Cleanliness, Other';
COMMENT ON COLUMN incidents.severity IS 'Severity level: Low, Medium, High, Urgent';
COMMENT ON COLUMN incidents.photos IS 'JSON array of photo URLs';

CREATE INDEX idx_incidents_property_id ON incidents(property_id);
CREATE INDEX idx_incidents_unit_id ON incidents(unit_id);
CREATE INDEX idx_incidents_status ON incidents(status);
CREATE INDEX idx_incidents_severity ON incidents(severity);

-- Lost and found table
CREATE TABLE lost_found (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
    item_description TEXT NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    condition TEXT,
    found_date DATE NOT NULL,
    status TEXT NOT NULL DEFAULT 'Found' CHECK (status IN ('Found', 'Claimed', 'Disposed')),
    photos JSONB,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE lost_found IS 'Lost and found items';
COMMENT ON COLUMN lost_found.status IS 'Item status: Found, Claimed, Disposed';

CREATE INDEX idx_lost_found_property_id ON lost_found(property_id);
CREATE INDEX idx_lost_found_status ON lost_found(status);
CREATE INDEX idx_lost_found_found_date ON lost_found(found_date);

-- ============================================================================
-- INVENTORY MANAGEMENT
-- ============================================================================

-- Inventory items table: Master list of inventory items
CREATE TABLE inventory_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    unit_of_measure TEXT NOT NULL,
    category TEXT NOT NULL
);

COMMENT ON TABLE inventory_items IS 'Master list of inventory items (supplies, linens, etc.)';
COMMENT ON COLUMN inventory_items.unit_of_measure IS 'Unit of measure (e.g., piece, box, liter)';

CREATE INDEX idx_inventory_items_category ON inventory_items(category);

-- Inventory levels table: Stock levels per property
CREATE TABLE inventory_levels (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
    item_id UUID NOT NULL REFERENCES inventory_items(id) ON DELETE CASCADE,
    par_level INTEGER NOT NULL DEFAULT 0,
    current_qty INTEGER NOT NULL DEFAULT 0,
    UNIQUE(property_id, item_id)
);

COMMENT ON TABLE inventory_levels IS 'Current inventory levels per property';
COMMENT ON COLUMN inventory_levels.par_level IS 'Minimum stock level (reorder point)';
COMMENT ON COLUMN inventory_levels.current_qty IS 'Current quantity in stock';

CREATE INDEX idx_inventory_levels_property_id ON inventory_levels(property_id);
CREATE INDEX idx_inventory_levels_item_id ON inventory_levels(item_id);

-- Inventory transactions table: Stock in/out logs
CREATE TABLE inventory_txns (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
    item_id UUID NOT NULL REFERENCES inventory_items(id) ON DELETE CASCADE,
    qty_change INTEGER NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('In', 'Out', 'Adjustment')),
    note TEXT,
    created_by_id UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE inventory_txns IS 'Inventory transaction log (in/out/adjustments)';
COMMENT ON COLUMN inventory_txns.qty_change IS 'Quantity change (positive for in, negative for out)';

CREATE INDEX idx_inventory_txns_property_id ON inventory_txns(property_id);
CREATE INDEX idx_inventory_txns_item_id ON inventory_txns(item_id);
CREATE INDEX idx_inventory_txns_created_at ON inventory_txns(created_at);

-- ============================================================================
-- LAUNDRY MANAGEMENT
-- ============================================================================

-- Laundry orders table
CREATE TABLE laundry_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'Pending' CHECK (status IN ('Pending', 'PickedUp', 'Washing', 'Drying', 'Completed', 'Cancelled')),
    ordered_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    notes TEXT
);

COMMENT ON TABLE laundry_orders IS 'Laundry service orders';
COMMENT ON COLUMN laundry_orders.status IS 'Order status: Pending, PickedUp, Washing, Drying, Completed, Cancelled';

CREATE INDEX idx_laundry_orders_property_id ON laundry_orders(property_id);
CREATE INDEX idx_laundry_orders_status ON laundry_orders(status);

-- Laundry steps table: Track workflow steps
CREATE TABLE laundry_steps (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES laundry_orders(id) ON DELETE CASCADE,
    step_type TEXT NOT NULL CHECK (step_type IN ('PickUp', 'Wash', 'Dry', 'DropOff')),
    status TEXT NOT NULL DEFAULT 'Pending' CHECK (status IN ('Pending', 'InProgress', 'Completed')),
    completed_at TIMESTAMPTZ,
    notes TEXT
);

COMMENT ON TABLE laundry_steps IS 'Individual steps within laundry orders';

CREATE INDEX idx_laundry_steps_order_id ON laundry_steps(order_id);
CREATE INDEX idx_laundry_steps_status ON laundry_steps(status);

-- ============================================================================
-- LAWN/POOL MANAGEMENT
-- ============================================================================

-- Yard/Pool profiles table
CREATE TABLE yard_pool_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('Lawn', 'Pool', 'Garden', 'Both')),
    dimensions TEXT,
    notes TEXT,
    equipment JSONB
);

COMMENT ON TABLE yard_pool_profiles IS 'Lawn and pool service profiles';
COMMENT ON COLUMN yard_pool_profiles.type IS 'Service type: Lawn, Pool, Garden, Both';
COMMENT ON COLUMN yard_pool_profiles.equipment IS 'JSON object with equipment details';

CREATE INDEX idx_yard_pool_profiles_property_id ON yard_pool_profiles(property_id);
CREATE INDEX idx_yard_pool_profiles_type ON yard_pool_profiles(type);

-- ============================================================================
-- CHAT/MESSAGING
-- ============================================================================

-- Chat threads table
CREATE TABLE chat_threads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID REFERENCES properties(id) ON DELETE CASCADE,
    title TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE chat_threads IS 'Chat conversation threads';

CREATE INDEX idx_chat_threads_property_id ON chat_threads(property_id);

-- Chat participants table
CREATE TABLE chat_participants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    thread_id UUID NOT NULL REFERENCES chat_threads(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(thread_id, user_id)
);

COMMENT ON TABLE chat_participants IS 'Users participating in chat threads';

CREATE INDEX idx_chat_participants_thread_id ON chat_participants(thread_id);
CREATE INDEX idx_chat_participants_user_id ON chat_participants(user_id);

-- Chat messages table
CREATE TABLE chat_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    thread_id UUID NOT NULL REFERENCES chat_threads(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE chat_messages IS 'Individual messages within chat threads';

CREATE INDEX idx_chat_messages_thread_id ON chat_messages(thread_id);
CREATE INDEX idx_chat_messages_user_id ON chat_messages(user_id);
CREATE INDEX idx_chat_messages_created_at ON chat_messages(created_at);

-- ============================================================================
-- TRIGGERS FOR UPDATED_AT
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to tables with updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON tasks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_incidents_updated_at BEFORE UPDATE ON incidents
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- INITIAL DATA / SEED
-- ============================================================================

-- Note: Seed data is in separate file seed.sql

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
