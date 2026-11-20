-- Cleaned Supabase seed SQL from full_backup.sql
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard/project/[your-project-ref]/sql/new
-- TRUNCATE tables first if needed to avoid duplicates: TRUNCATE departments, enterprises, ... RESTART IDENTITY CASCADE;
-- Skip 'session' table for security.

-- Departments
DELETE FROM departments;
COPY public.departments (id, name, is_it_department) FROM stdin;
1	IT	t
2	Administration	f
3	Magasin	f
4	Qualité	f
5	Labo	f
6	Datos	f
7	Cadenas	f
\.;

-- Enterprises (empty)
DELETE FROM enterprises;

-- Production Units (empty)
DELETE FROM production_units;

-- Products
DELETE FROM products;
COPY public.products (id, sku, manufacturer_item_name, internal_item_name, category, current_stock, min_threshold, supplier_barcode) FROM stdin;
4	SW-CISCO-24P	Cisco Switch 24 Port	\N	Network	2	2	\N
2	RB-MAK-X5	Thermal Ribbon X5	\N	Ribbon	49	20	\N
8	SW-CISCO-24PR	Cisco Switch 24 Port		IT Equipment	3	5	\N
11	SW-CISCO-24Pee	Cisco Switch 24 Port		IT Equipment	1	5	\N
1	TN-HP-414A	HP 414A Black Toner	Toner Noir HP LaserJet	Toner	22	5	\N
5	RL-MAK-T1	Thermal Rollos T1	\N	Rollos	93	30	\N
3	CAM-DH-2MP	Dahua IP Camera 2MP	Camera IP 2M Dome	IT Equipment	12	3	\N
\.;

SELECT setval('products_id_seq', (SELECT MAX(id) FROM products));

-- Purchase Requests
DELETE FROM purchase_requests;
COPY public.purchase_requests (id, request_qr, requested_by, request_date, status, notes) FROM stdin;
1	REQ_1	\N	2026-02-08 01:18:35.099599	Pending	Initial inventory order
2	REQ_2	Marwa	2026-02-09 09:28:11.268683	Pending	\N
3	REQ_3	Mousaeb	2026-02-09 09:57:10.556126	Pending	\N
4	REQ_4	outman 	2026-02-09 09:59:08.092951	Pending	\N
6	REQ_6	mousab	2026-02-09 12:07:19.192356	Pending	\N
5	REQ_5	marwa	2026-02-09 12:05:10.544393	Received	\N
\.;

SELECT setval('purchase_requests_id_seq', (SELECT MAX(id) FROM purchase_requests));

-- Purchase Request Items (depends on requests/products)
DELETE FROM purchase_request_items;
COPY public.purchase_request_items (id, request_id, product_id, requested_qty, expected_delivery_date, supplier_name, unit_price, status) FROM stdin;
2	2	3	1	\N	\N	\N	Received
1	1	1	5	\N	HP Official	\N	Received
3	3	5	13	\N	\N	\N	Received
6	6	3	15	\N	\N	\N	Pending
4	4	3	1	\N	\N	\N	Received
5	5	3	1	\N	manar technology	\N	Received
\.;

SELECT setval('purchase_request_items_id_seq', (SELECT MAX(id) FROM purchase_request_items));

-- Receiving Transactions (depends on items)
DELETE FROM receiving_transactions;
COPY public.receiving_transactions (id, purchase_request_item_id, received_qty, received_date, received_by, is_damaged, damage_notes, photo_url) FROM stdin;
1	2	1	2026-02-09 11:50:53.410399	\N	f	\N	\N
2	1	4	2026-02-09 11:54:17.956103	\N	f	\N	\N
3	1	5	2026-02-09 11:57:05.219577	\N	f	\N	\N
4	1	5	2026-02-09 11:57:23.522822	\N	f	\N	\N
5	3	13	2026-02-09 11:57:59.237376	\N	f	\N	\N
6	4	1	2026-02-09 12:00:30.688735	\N	f	\N	\N
7	3	1	2026-02-09 12:00:45.73075	\N	f	\N	\N
8	4	1	2026-02-09 12:08:04.055911	\N	f	\N	\N
9	5	1	2026-02-09 12:47:39.366294	\N	f	\N	\N
\.;

SELECT setval('receiving_transactions_id_seq', (SELECT MAX(id) FROM receiving_transactions));

-- Toner Consumption
DELETE FROM toner_consumption;
COPY public.toner_consumption (id, product_id, dept_id, quantity, consumption_date, requested_by, approved_by, is_flagged) FROM stdin;
1	2	2	1	2026-02-09 09:20:44.796559	\N	\N	f
2	1	4	2	2026-02-09 09:21:31.288077	\N	\N	f
3	5	6	20	2026-02-09 09:34:05.149985	\N	\N	f
4	5	7	1	2026-02-09 10:02:49.267602	\N	\N	f
\.;

SELECT setval('toner_consumption_id_seq', (SELECT MAX(id) FROM toner_consumption));

-- Transaction History
DELETE FROM transaction_history;
COPY public.transaction_history (id, product_id, dept_id, user_id, quantity, transaction_type, reason_code, trans_date, reference_request_id) FROM stdin;
1	2	2	\N	1	OUT	Regular Use	2026-02-09 09:20:44.796559	\N
2	1	4	\N	2	OUT	Regular Use	2026-02-09 09:21:31.288077	\N
3	5	6	\N	20	OUT	Regular Use	2026-02-09 09:34:05.149985	\N
4	5	7	\N	1	OUT	Regular Use	2026-02-09 10:02:49.267602	\N
5	3	\N	\N	1	IN	\N	2026-02-09 11:50:53.410399	2
6	1	\N	\N	4	IN	\N	2026-02-09 11:54:17.956103	1
7	1	\N	\N	5	IN	\N	2026-02-09 11:57:05.219577	1
8	1	\N	\N	5	IN	\N	2026-02-09 11:57:23.522822	1
9	5	\N	\N	13	IN	\N	2026-02-09 11:57:59.237376	3
10	3	\N	\N	1	IN	\N	2026-02-09 12:00:30.688735	4
11	5	\N	\N	1	IN	\N	2026-02-09 12:00:45.73075	3
12	3	\N	\N	1	IN	\N	2026-02-09 12:08:04.055911	4
13	3	\N	\N	1	IN	\N	2026-02-09 12:47:39.366294	5
\.;

SELECT setval('transaction_history_id_seq', (SELECT MAX(id) FROM transaction_history));

-- Users
DELETE FROM users;
COPY public.users (id, name, email, password_hash, role, is_active, last_login, created_at) FROM stdin;
2	Benamti Otman	b.otman@tintcolor2010.com	$2b$10$QoFl3ma1Jncyk.I6epStQ.GSxXjJm2Rz3EJYVg4gL1DJDGsWUP196	Admin	t	\N	2026-02-09 10:51:50.467893
3	Akhazzan Mossaab	i.mosaab@tintcolor2010.com	$2b$10$QoFl3ma1Jncyk.I6epStQ.GSxXjJm2Rz3EJYVg4gL1DJDGsWUP196	Admin	t	\N	2026-02-09 10:51:50.472761
4	Xevi	xevim@hallotex.com	$2b$10$QoFl3ma1Jncyk.I6epStQ.GSxXjJm2Rz3EJYVg4gL1DJDGsWUP196	Admin	t	\N	2026-02-09 10:51:50.478114
5	Zineb Aktaou	zineb@tintcolor2010.com	$2b$10$QoFl3ma1Jncyk.I6epStQ.GSxXjJm2Rz3EJYVg4gL1DJDGsWUP196	Admin	t	\N	2026-02-09 10:51:50.481937
1	Marwa Mazini	marwa6mzi@gmail.com	$2b$10$QoFl3ma1Jncyk.I6epStQ.GSxXjJm2Rz3EJYVg4gL1DJDGsWUP196	Admin	t	2026-02-09 12:46:45.446	2026-02-09 10:51:50.426658
\.;

SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));

-- Verify
SELECT 'Products: ' || COUNT(*) FROM products UNION ALL
SELECT 'Purchase Requests: ' || COUNT(*) FROM purchase_requests UNION ALL
SELECT 'Users: ' || COUNT(*) FROM users;

