-- ============================================================================
-- AriStay Database Seed Data
-- PostgreSQL 16+
-- Description: Sample data for testing and development
-- ============================================================================

-- Note: Run schema.sql first before running this seed file

-- ============================================================================
-- USERS (Sample users with different roles)
-- ============================================================================

-- Password for all test users: "password123" (hashed with bcrypt, rounds=10)
-- Hash generated using: bcrypt.hash('password123', 10)

INSERT INTO users (id, email, password_hash, full_name, role, status) VALUES
    ('11111111-1111-1111-1111-111111111111', 'admin@aristay.com', '$2a$10$YourHashedPasswordHere1234567890ABC', 'Admin User', 'Admin', 'Active'),
    ('22222222-2222-2222-2222-222222222222', 'cleaning1@aristay.com', '$2a$10$YourHashedPasswordHere1234567890ABC', 'Maria Garcia', 'Cleaning', 'Active'),
    ('33333333-3333-3333-3333-333333333333', 'cleaning2@aristay.com', '$2a$10$YourHashedPasswordHere1234567890ABC', 'John Smith', 'Cleaning', 'Active'),
    ('44444444-4444-4444-4444-444444444444', 'maintenance@aristay.com', '$2a$10$YourHashedPasswordHere1234567890ABC', 'Robert Johnson', 'Maintenance', 'Active'),
    ('55555555-5555-5555-5555-555555555555', 'laundry@aristay.com', '$2a$10$YourHashedPasswordHere1234567890ABC', 'Linda Chen', 'Laundry', 'Active'),
    ('66666666-6666-6666-6666-666666666666', 'lawnpool@aristay.com', '$2a$10$YourHashedPasswordHere1234567890ABC', 'David Martinez', 'LawnPool', 'Active');

-- ============================================================================
-- PROPERTIES & UNITS
-- ============================================================================

INSERT INTO properties (id, name, address, notes, active) VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Beachside Resort', '123 Ocean Drive, Miami Beach, FL 33139', 'Luxury beachfront property with ocean views', true),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Downtown Suites', '456 Main Street, San Francisco, CA 94102', 'Modern apartments in city center', true),
    ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mountain View Lodge', '789 Alpine Way, Aspen, CO 81611', 'Ski resort with mountain views', true);

INSERT INTO units (property_id, code, floor, beds, status) VALUES
    -- Beachside Resort (Property A)
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '101', 1, 2, 'Ready'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '102', 1, 2, 'Occupied'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '103', 1, 3, 'Ready'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '201', 2, 2, 'Maintenance'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '202', 2, 3, 'Ready'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'PH-1', 3, 4, 'Occupied'),

    -- Downtown Suites (Property B)
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'A1', 1, 1, 'Ready'),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'A2', 1, 1, 'Occupied'),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'B1', 2, 2, 'Ready'),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'B2', 2, 2, 'Ready'),

    -- Mountain View Lodge (Property C)
    ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'CABIN-1', 1, 4, 'Ready'),
    ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'CABIN-2', 1, 4, 'Occupied'),
    ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'SUITE-1', 2, 6, 'Ready');

-- ============================================================================
-- SCHEDULES
-- ============================================================================

INSERT INTO schedules (type, property_id, unit_id, start_at, end_at, recurrence, source, color) VALUES
    -- Daily cleaning for occupied rooms
    ('Cleaning', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
     (SELECT id FROM units WHERE property_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' AND code = '102'),
     NOW() + INTERVAL '1 day', NOW() + INTERVAL '1 day 2 hours',
     '{"frequency": "daily", "interval": 1}'::jsonb, 'Manual', '#4CAF50'),

    -- Weekly pool maintenance
    ('LawnPool', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NULL,
     NOW() + INTERVAL '2 days', NOW() + INTERVAL '2 days 3 hours',
     '{"frequency": "weekly", "interval": 1, "dayOfWeek": "Monday"}'::jsonb, 'Manual', '#2196F3'),

    -- Monthly deep cleaning
    ('Cleaning', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
     (SELECT id FROM units WHERE property_id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb' AND code = 'A1'),
     NOW() + INTERVAL '7 days', NOW() + INTERVAL '7 days 4 hours',
     '{"frequency": "monthly", "interval": 1, "dayOfMonth": 1}'::jsonb, 'Manual', '#FF9800');

-- ============================================================================
-- TASKS
-- ============================================================================

INSERT INTO tasks (id, type, title, description, property_id, unit_id, assignee_id, status, due_at) VALUES
    ('dddddddd-dddd-dddd-dddd-dddddddddddd', 'Cleaning', 'Daily Cleaning - Room 101',
     'Standard checkout cleaning: change linens, vacuum, clean bathroom',
     'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
     (SELECT id FROM units WHERE code = '101' LIMIT 1),
     '22222222-2222-2222-2222-222222222222', 'Pending', NOW() + INTERVAL '2 hours'),

    ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Maintenance', 'Fix leaky faucet - Room 201',
     'Guest reported dripping bathroom sink faucet',
     'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
     (SELECT id FROM units WHERE code = '201' LIMIT 1),
     '44444444-4444-4444-4444-444444444444', 'InProgress', NOW() + INTERVAL '4 hours'),

    ('ffffffff-ffff-ffff-ffff-ffffffffffff', 'LawnPool', 'Pool chemical check',
     'Test and balance pool chemicals, clean filter',
     'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NULL,
     '66666666-6666-6666-6666-666666666666', 'Pending', NOW() + INTERVAL '1 day'),

    ('10101010-1010-1010-1010-101010101010', 'Laundry', 'Laundry pickup - Beachside',
     'Collect dirty linens from housekeeping storage',
     'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NULL,
     '55555555-5555-5555-5555-555555555555', 'Completed', NOW() - INTERVAL '1 day');

-- ============================================================================
-- CHECKLIST TEMPLATES
-- ============================================================================

INSERT INTO task_checklist_templates (id, type, name) VALUES
    ('template-1', 'Cleaning', 'Standard Room Cleaning'),
    ('template-2', 'Cleaning', 'Deep Cleaning'),
    ('template-3', 'Maintenance', 'General Maintenance'),
    ('template-4', 'LawnPool', 'Pool Maintenance');

INSERT INTO task_checklist_template_items (template_id, label, required) VALUES
    -- Standard Room Cleaning
    ('template-1', 'Remove all trash', true),
    ('template-1', 'Change bed linens', true),
    ('template-1', 'Vacuum all floors', true),
    ('template-1', 'Clean bathroom (toilet, sink, shower)', true),
    ('template-1', 'Wipe down all surfaces', true),
    ('template-1', 'Restock amenities (soap, shampoo, etc.)', true),
    ('template-1', 'Check all light bulbs', false),

    -- Deep Cleaning
    ('template-2', 'Move furniture and vacuum underneath', true),
    ('template-2', 'Clean windows inside and out', true),
    ('template-2', 'Wipe down baseboards', true),
    ('template-2', 'Clean inside cabinets and drawers', true),
    ('template-2', 'Sanitize all surfaces', true),

    -- General Maintenance
    ('template-3', 'Inspect reported issue', true),
    ('template-3', 'Take before photos', true),
    ('template-3', 'Perform repair/replacement', true),
    ('template-3', 'Test functionality', true),
    ('template-3', 'Take after photos', true),
    ('template-3', 'Clean up work area', true),

    -- Pool Maintenance
    ('template-4', 'Test pH level', true),
    ('template-4', 'Test chlorine level', true),
    ('template-4', 'Adjust chemicals as needed', true),
    ('template-4', 'Clean filter', true),
    ('template-4', 'Skim debris from surface', true),
    ('template-4', 'Check equipment operation', true);

-- ============================================================================
-- TASK CHECKLISTS (Instance for specific tasks)
-- ============================================================================

INSERT INTO task_checklists (id, task_id) VALUES
    ('checklist-1', 'dddddddd-dddd-dddd-dddd-dddddddddddd');

INSERT INTO task_checklist_items (checklist_id, label, required, status, note) VALUES
    ('checklist-1', 'Remove all trash', true, 'Open', NULL),
    ('checklist-1', 'Change bed linens', true, 'Open', NULL),
    ('checklist-1', 'Vacuum all floors', true, 'Open', NULL),
    ('checklist-1', 'Clean bathroom', true, 'Open', NULL),
    ('checklist-1', 'Wipe down all surfaces', true, 'Open', NULL),
    ('checklist-1', 'Restock amenities', true, 'Open', NULL);

-- ============================================================================
-- INCIDENTS
-- ============================================================================

INSERT INTO incidents (property_id, unit_id, type, severity, description, photos, status, reported_by_id) VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
     (SELECT id FROM units WHERE code = '201' LIMIT 1),
     'Damage', 'Medium', 'Broken towel rack in bathroom',
     '["https://s3.example.com/incidents/towel-rack-1.jpg"]'::jsonb,
     'Open', '22222222-2222-2222-2222-222222222222'),

    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
     (SELECT id FROM units WHERE code = 'A2' LIMIT 1),
     'Malfunction', 'High', 'Air conditioning not cooling properly',
     '[]'::jsonb,
     'InProgress', '33333333-3333-3333-3333-333333333333');

-- ============================================================================
-- LOST & FOUND
-- ============================================================================

INSERT INTO lost_found (property_id, item_description, quantity, condition, found_date, status, photos) VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'iPhone 13 Pro - Black', 1, 'Good', CURRENT_DATE - INTERVAL '2 days', 'Found',
     '["https://s3.example.com/lostfound/iphone-1.jpg"]'::jsonb),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Sunglasses - Ray-Ban', 1, 'Good', CURRENT_DATE - INTERVAL '5 days', 'Found',
     '["https://s3.example.com/lostfound/sunglasses-1.jpg"]'::jsonb),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Book - "The Great Gatsby"', 1, 'Fair', CURRENT_DATE - INTERVAL '10 days', 'Found',
     '[]'::jsonb);

-- ============================================================================
-- INVENTORY
-- ============================================================================

INSERT INTO inventory_items (id, name, unit_of_measure, category) VALUES
    ('item-1', 'Bath Towel (White)', 'piece', 'Linens'),
    ('item-2', 'Hand Towel (White)', 'piece', 'Linens'),
    ('item-3', 'Bed Sheet (Queen)', 'piece', 'Linens'),
    ('item-4', 'Bed Sheet (King)', 'piece', 'Linens'),
    ('item-5', 'Pillowcase', 'piece', 'Linens'),
    ('item-6', 'Toilet Paper (Roll)', 'roll', 'Bathroom Supplies'),
    ('item-7', 'Shampoo (30ml bottle)', 'bottle', 'Bathroom Supplies'),
    ('item-8', 'Conditioner (30ml bottle)', 'bottle', 'Bathroom Supplies'),
    ('item-9', 'Body Soap (Bar)', 'bar', 'Bathroom Supplies'),
    ('item-10', 'Cleaning Spray (All-purpose)', 'bottle', 'Cleaning Supplies'),
    ('item-11', 'Glass Cleaner', 'bottle', 'Cleaning Supplies'),
    ('item-12', 'Disinfectant', 'bottle', 'Cleaning Supplies'),
    ('item-13', 'Trash Bags (Large)', 'box', 'Cleaning Supplies'),
    ('item-14', 'Vacuum Bags', 'box', 'Cleaning Supplies'),
    ('item-15', 'Pool Chlorine (lb)', 'pound', 'Pool Supplies');

INSERT INTO inventory_levels (property_id, item_id, par_level, current_qty) VALUES
    -- Beachside Resort
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'item-1', 50, 45),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'item-2', 50, 48),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'item-3', 30, 25),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'item-4', 20, 18),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'item-5', 60, 55),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'item-6', 100, 85),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'item-7', 50, 42),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'item-8', 50, 41),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'item-9', 100, 88),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'item-10', 20, 15),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'item-15', 50, 35),

    -- Downtown Suites
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'item-1', 30, 28),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'item-2', 30, 29),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'item-3', 20, 15),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'item-6', 60, 52),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'item-10', 15, 12);

INSERT INTO inventory_txns (property_id, item_id, qty_change, type, note, created_by_id) VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'item-1', 20, 'In', 'Weekly restock delivery', '11111111-1111-1111-1111-111111111111'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'item-6', -15, 'Out', 'Used for room cleaning', '22222222-2222-2222-2222-222222222222'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'item-15', -5, 'Out', 'Pool maintenance', '66666666-6666-6666-6666-666666666666'),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'item-3', -5, 'Out', 'Linen change for units', '55555555-5555-5555-5555-555555555555');

-- ============================================================================
-- LAUNDRY
-- ============================================================================

INSERT INTO laundry_orders (id, property_id, status, ordered_at, completed_at) VALUES
    ('laundry-1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Completed', NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day'),
    ('laundry-2', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Washing', NOW() - INTERVAL '3 hours', NULL),
    ('laundry-3', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Pending', NOW(), NULL);

INSERT INTO laundry_steps (order_id, step_type, status, completed_at) VALUES
    -- Order 1 (Completed)
    ('laundry-1', 'PickUp', 'Completed', NOW() - INTERVAL '2 days'),
    ('laundry-1', 'Wash', 'Completed', NOW() - INTERVAL '1 day 20 hours'),
    ('laundry-1', 'Dry', 'Completed', NOW() - INTERVAL '1 day 18 hours'),
    ('laundry-1', 'DropOff', 'Completed', NOW() - INTERVAL '1 day'),

    -- Order 2 (In Progress)
    ('laundry-2', 'PickUp', 'Completed', NOW() - INTERVAL '3 hours'),
    ('laundry-2', 'Wash', 'InProgress', NULL),
    ('laundry-2', 'Dry', 'Pending', NULL),
    ('laundry-2', 'DropOff', 'Pending', NULL),

    -- Order 3 (Pending)
    ('laundry-3', 'PickUp', 'Pending', NULL),
    ('laundry-3', 'Wash', 'Pending', NULL),
    ('laundry-3', 'Dry', 'Pending', NULL),
    ('laundry-3', 'DropOff', 'Pending', NULL);

-- ============================================================================
-- LAWN/POOL PROFILES
-- ============================================================================

INSERT INTO yard_pool_profiles (property_id, type, dimensions, notes, equipment) VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Pool', '25m x 10m, depth 1.2m - 2.5m',
     'Olympic-style pool with heating system',
     '{"filter": "Sand filter", "pump": "Hayward 2HP", "heater": "Raypak 400k BTU"}'::jsonb),

    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Lawn', '500 sqm front lawn, 300 sqm back garden',
     'Weekly mowing required, monthly fertilization',
     '{"mower": "John Deere X350", "sprinkler": "Rain Bird automatic system"}'::jsonb),

    ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Both', 'Pool: 15m x 8m, Lawn: 1000 sqm',
     'Mountain property with seasonal maintenance',
     '{"pool_cover": "Winter cover", "snow_removal": "Required Nov-Mar"}'::jsonb);

-- ============================================================================
-- CHAT
-- ============================================================================

INSERT INTO chat_threads (id, property_id, title) VALUES
    ('thread-1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Room 201 Maintenance Issue'),
    ('thread-2', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Weekly Cleaning Coordination'),
    ('thread-3', NULL, 'General Staff Discussion');

INSERT INTO chat_participants (thread_id, user_id) VALUES
    -- Thread 1: Maintenance issue
    ('thread-1', '11111111-1111-1111-1111-111111111111'), -- Admin
    ('thread-1', '44444444-4444-4444-4444-444444444444'), -- Maintenance
    ('thread-1', '22222222-2222-2222-2222-222222222222'), -- Cleaning (reported)

    -- Thread 2: Cleaning coordination
    ('thread-2', '11111111-1111-1111-1111-111111111111'), -- Admin
    ('thread-2', '22222222-2222-2222-2222-222222222222'), -- Cleaning 1
    ('thread-2', '33333333-3333-3333-3333-333333333333'), -- Cleaning 2

    -- Thread 3: General
    ('thread-3', '11111111-1111-1111-1111-111111111111'), -- Admin
    ('thread-3', '22222222-2222-2222-2222-222222222222'), -- Cleaning 1
    ('thread-3', '44444444-4444-4444-4444-444444444444'), -- Maintenance
    ('thread-3', '55555555-5555-5555-5555-555555555555'); -- Laundry

INSERT INTO chat_messages (thread_id, user_id, content, created_at) VALUES
    -- Thread 1 conversation
    ('thread-1', '22222222-2222-2222-2222-222222222222',
     'I found a leaky faucet in room 201 during cleaning. Needs attention ASAP.',
     NOW() - INTERVAL '4 hours'),
    ('thread-1', '11111111-1111-1111-1111-111111111111',
     'Thanks for reporting Maria. I''m assigning this to Robert from maintenance.',
     NOW() - INTERVAL '3 hours 50 minutes'),
    ('thread-1', '44444444-4444-4444-4444-444444444444',
     'Got it. I''m heading there now to assess the situation.',
     NOW() - INTERVAL '3 hours 30 minutes'),
    ('thread-1', '44444444-4444-4444-4444-444444444444',
     'Update: It''s just a worn washer. I have the parts, should be fixed in 30 mins.',
     NOW() - INTERVAL '2 hours'),

    -- Thread 2 conversation
    ('thread-2', '11111111-1111-1111-1111-111111111111',
     'Good morning team! We have 3 checkouts today - rooms A1, B1, and B2.',
     NOW() - INTERVAL '6 hours'),
    ('thread-2', '22222222-2222-2222-2222-222222222222',
     'I can handle A1 and B1. Should be done by noon.',
     NOW() - INTERVAL '5 hours 45 minutes'),
    ('thread-2', '33333333-3333-3333-3333-333333333333',
     'I''ll take B2. Also, we''re running low on bathroom supplies in the storage.',
     NOW() - INTERVAL '5 hours 30 minutes'),
    ('thread-2', '11111111-1111-1111-1111-111111111111',
     'Thanks John. I''ll order more supplies today.',
     NOW() - INTERVAL '5 hours 15 minutes'),

    -- Thread 3 conversation
    ('thread-3', '11111111-1111-1111-1111-111111111111',
     'Reminder: Staff meeting next Monday at 9 AM to discuss new procedures.',
     NOW() - INTERVAL '1 day'),
    ('thread-3', '22222222-2222-2222-2222-222222222222',
     'I''ll be there!',
     NOW() - INTERVAL '23 hours'),
    ('thread-3', '44444444-4444-4444-4444-444444444444',
     'Confirmed.',
     NOW() - INTERVAL '22 hours'),
    ('thread-3', '55555555-5555-5555-5555-555555555555',
     'See you there.',
     NOW() - INTERVAL '21 hours');

-- ============================================================================
-- SUMMARY
-- ============================================================================

-- This seed file creates:
-- - 6 users (1 admin, 2 cleaning, 1 maintenance, 1 laundry, 1 lawn/pool)
-- - 3 properties with 13 total units
-- - 3 schedules (daily, weekly, monthly)
-- - 4 tasks in various states
-- - 4 checklist templates with items
-- - 2 incidents (damage and malfunction)
-- - 3 lost & found items
-- - 15 inventory items with levels for 2 properties
-- - 4 inventory transactions
-- - 3 laundry orders with workflow steps
-- - 3 yard/pool profiles
-- - 3 chat threads with 17 messages

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Uncomment to verify data after seeding:

-- SELECT 'Users:' as entity, COUNT(*) as count FROM users
-- UNION ALL SELECT 'Properties:', COUNT(*) FROM properties
-- UNION ALL SELECT 'Units:', COUNT(*) FROM units
-- UNION ALL SELECT 'Tasks:', COUNT(*) FROM tasks
-- UNION ALL SELECT 'Incidents:', COUNT(*) FROM incidents
-- UNION ALL SELECT 'Inventory Items:', COUNT(*) FROM inventory_items
-- UNION ALL SELECT 'Laundry Orders:', COUNT(*) FROM laundry_orders
-- UNION ALL SELECT 'Chat Threads:', COUNT(*) FROM chat_threads
-- UNION ALL SELECT 'Chat Messages:', COUNT(*) FROM chat_messages;

-- ============================================================================
-- END OF SEED DATA
-- ============================================================================
