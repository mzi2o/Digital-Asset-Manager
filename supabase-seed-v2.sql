-- Supabase-compatible seed (INSERTs, no COPY). Run in SQL Editor after clicking 'Run this query' on warning.
-- Resets empties without mixing your 4 populated tables (comment out their DELETE if needed).

-- Reset sequences first
SELECT setval('departments_id_seq', COALESCE((SELECT MAX(id)+1 FROM departments), 1), false);
SELECT setval('products_id_seq', COALESCE((SELECT MAX(id)+1 FROM products), 1), false);
-- Add others as needed...

-- Departments (fills empty)
INSERT INTO departments (id, name, is_it_department) VALUES 
(1, 'IT', true),
(2, 'Administration', false),
(3, 'Magasin', false),
(4, 'Qualité', false),
(5, 'Labo', false),
(6, 'Datos', false),
(7, 'Cadenas', false)
ON CONFLICT (id) DO NOTHING;

-- Products
INSERT INTO products (id, sku, manufacturer_item_name, internal_item_name, category, current_stock, min_threshold, supplier_barcode) VALUES 
(1, 'TN-HP-414A', 'HP 414A Black Toner', 'Toner Noir HP LaserJet', 'Toner', 22, 5, NULL),
(2, 'RB-MAK-X5', 'Thermal Ribbon X5', NULL, 'Ribbon', 49, 20, NULL),
(3, 'CAM-DH-2MP', 'Dahua IP Camera 2MP', 'Camera IP 2M Dome', 'IT Equipment', 12, 3, NULL),
(4, 'SW-CISCO-24P', 'Cisco Switch 24 Port', NULL, 'Network', 2, 2, NULL),
(5, 'RL-MAK-T1', 'Thermal Rollos T1', NULL, 'Rollos', 93, 30, NULL),
(8, 'SW-CISCO-24PR', 'Cisco Switch 24 Port', '', 'IT Equipment', 3, 5, NULL),
(11, 'SW-CISCO-24Pee', 'Cisco Switch 24 Port', '', 'IT Equipment', 1, 5, NULL)
ON CONFLICT (id) DO NOTHING;

-- Purchase Requests
INSERT INTO purchase_requests (id, request_qr, requested_by, request_date, status, notes) VALUES 
(1, 'REQ_1', NULL, '2026-02-08 01:18:35.099', 'Pending', 'Initial inventory order'),
(2, 'REQ_2', 'Marwa', '2026-02-09 09:28:11.269', 'Pending', NULL),
(3, 'REQ_3', 'Mousaeb', '2026-02-09 09:57:10.556', 'Pending', NULL),
(4, 'REQ_4', 'outman ', '2026-02-09 09:59:08.093', 'Pending', NULL),
(5, 'REQ_5', 'marwa', '2026-02-09 12:05:10.544', 'Received', NULL),
(6, 'REQ_6', 'mousab', '2026-02-09 12:07:19.192', 'Pending', NULL)
ON CONFLICT (request_qr) DO NOTHING;

-- Users (if empty)
INSERT INTO users (id, name, email, password_hash, role, is_active, last_login, created_at) VALUES 
(1, 'Marwa Mazini', 'marwa6mzi@gmail.com', '$2b$10$QoFl3ma1Jncyk.I6epStQ.GSxXjJm2Rz3EJYVg4gL1DJDGsWUP196', 'Admin', true, '2026-02-09 12:46:45.446', '2026-02-09 10:51:50.427'),
(2, 'Benamti Otman', 'b.otman@tintcolor2010.com', '$2b$10$QoFl3ma1Jncyk.I6epStQ.GSxXjJm2Rz3EJYVg4gL1DJDGsWUP196', 'Admin', true, NULL, '2026-02-09 10:51:50.468'),
(3, 'Akhazzan Mossaab', 'i.mosaab@tintcolor2010.com', '$2b$10$QoFl3ma1Jncyk.I6epStQ.GSxXjJm2Rz3EJYVg4gL1DJDGsWUP196', 'Admin', true, NULL, '2026-02-09 10:51:50.473'),
(4, 'Xevi', 'xevim@hallotex.com', '$2b$10$QoFl3ma1Jncyk.I6epStQ.GSxXjJm2Rz3EJYVg4gL1DJDGsWUP196', 'Admin', true, NULL, '2026-02-09 10:51:50.478'),
(5, 'Zineb Aktaou', 'zineb@tintcolor2010.com', '$2b$10$QoFl3ma1Jncyk.I6epStQ.GSxXjJm2Rz3EJYVg4gL1DJDGsWUP196', 'Admin', true, NULL, '2026-02-09 10:51:50.482')
ON CONFLICT (email) DO NOTHING;

-- Add more tables as needed (purchase_request_items, etc.) - paste similar INSERTs

-- Verify
SELECT 'Products count: ' || COUNT(*) FROM products  
UNION ALL SELECT 'Requests count: ' || COUNT(*) FROM purchase_requests  
UNION ALL SELECT 'Users count: ' || COUNT(*) FROM users;

