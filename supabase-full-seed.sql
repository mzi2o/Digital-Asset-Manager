-- Complete Supabase INSERT seed for ALL empty tables
-- Paste into SQL Editor & RUN. Safe: ON CONFLICT DO NOTHING.

-- Departments (likely populated, skip if not empty)
INSERT INTO departments (id, name, is_it_department) VALUES 
(1, 'IT', true),
(2, 'Administration', false),
(3, 'Magasin', false),
(4, 'Qualité', false),
(5, 'Labo', false),
(6, 'Datos', false),
(7, 'Cadenas', false) ON CONFLICT (id) DO NOTHING;

-- Enterprises (empty)
INSERT INTO enterprises (id, name) VALUES (1, 'Tintcolor') ON CONFLICT (id) DO NOTHING;

-- Production Units (empty)
INSERT INTO production_units (id, name, enterprise_id) VALUES 
(1, 'Unit1', 1) ON CONFLICT (id) DO NOTHING;

-- Purchase Request Items (empty)
INSERT INTO purchase_request_items (id, request_id, product_id, requested_qty, status) VALUES 
(1, 1, 1, 5, 'Received'),
(2, 2, 3, 1, 'Received'),
(3, 3, 5, 13, 'Received'),
(4, 4, 3, 1, 'Received'),
(5, 5, 3, 1, 'Received'),
(6, 6, 3, 15, 'Pending') ON CONFLICT (id) DO NOTHING;

-- Receiving Transactions (empty)
INSERT INTO receiving_transactions (id, purchase_request_item_id, received_qty, is_damaged) VALUES 
(1, 2, 1, false),
(2, 1, 4, false),
(3, 1, 5, false),
(4, 1, 5, false),
(5, 3, 13, false),
(6, 4, 1, false),
(7, 3, 1, false),
(8, 4, 1, false),
(9, 5, 1, false) ON CONFLICT (id) DO NOTHING;

-- Toner Consumption (empty)
INSERT INTO toner_consumption (id, product_id, dept_id, quantity, is_flagged) VALUES 
(1, 2, 2, 1, false),
(2, 1, 4, 2, false),
(3, 5, 6, 20, false),
(4, 5, 7, 1, false) ON CONFLICT (id) DO NOTHING;

-- Transaction History (empty)
INSERT INTO transaction_history (id, product_id, dept_id, quantity, transaction_type) VALUES 
(1, 2, 2, 1, 'OUT'),
(2, 1, 4, 2, 'OUT'),
(3, 5, 6, 20, 'OUT'),
(4, 5, 7, 1, 'OUT'),
(5, 3, NULL, 1, 'IN'),
(6, 1, NULL, 4, 'IN'),
(7, 1, NULL, 5, 'IN'),
(8, 1, NULL, 5, 'IN'),
(9, 5, NULL, 13, 'IN'),
(10, 3, NULL, 1, 'IN'),
(11, 5, NULL, 1, 'IN'),
(12, 3, NULL, 1, 'IN'),
(13, 3, NULL, 1, 'IN') ON CONFLICT (id) DO NOTHING;

-- Reset sequences (fixed table name extraction)
DO $$
DECLARE
  seq_name TEXT;
  table_name TEXT;
BEGIN
  FOREACH seq_name IN ARRAY ARRAY[
    'departments_id_seq','enterprises_id_seq','production_units_id_seq',
    'purchase_request_items_id_seq','receiving_transactions_id_seq',
    'toner_consumption_id_seq','transaction_history_id_seq'
  ] 
  LOOP
    table_name := CASE 
      WHEN seq_name = 'departments_id_seq' THEN 'departments'
      WHEN seq_name = 'enterprises_id_seq' THEN 'enterprises'
      WHEN seq_name = 'production_units_id_seq' THEN 'production_units'
      WHEN seq_name = 'purchase_request_items_id_seq' THEN 'purchase_request_items'
      WHEN seq_name = 'receiving_transactions_id_seq' THEN 'receiving_transactions'
      WHEN seq_name = 'toner_consumption_id_seq' THEN 'toner_consumption'
      WHEN seq_name = 'transaction_history_id_seq' THEN 'transaction_history'
    END;
    EXECUTE 'SELECT setval($1, COALESCE((SELECT MAX(id)+1 FROM ' || quote_ident(table_name) || '), 1), false)' USING seq_name;
  END LOOP;
END $$;

-- Simple verify empty tables
SELECT 'enterprises: ' || COUNT(*) FROM enterprises UNION ALL
SELECT 'production_units: ' || COUNT(*) FROM production_units UNION ALL
SELECT 'purchase_request_items: ' || COUNT(*) FROM purchase_request_items UNION ALL
SELECT 'receiving_transactions: ' || COUNT(*) FROM receiving_transactions UNION ALL
SELECT 'toner_consumption: ' || COUNT(*) FROM toner_consumption UNION ALL
SELECT 'transaction_history: ' || COUNT(*) FROM transaction_history;

