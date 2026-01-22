-- Итоговый анализ сравнения производительности

-- 1. Создание дополнительных индексов для тестирования
CREATE INDEX IF NOT EXISTS idx_orders_user_date ON orders(user_id, order_date);
CREATE INDEX IF NOT EXISTS idx_products_price ON products(price);
CREATE INDEX IF NOT EXISTS idx_order_items_composite ON order_items(order_id, product_id);

-- 2. Сравнение запроса ДО и ПОСЛЕ оптимизации
-- ДО оптимизации (удаляем индексы для чистоты теста)
DROP INDEX IF EXISTS idx_orders_user_id;
DROP INDEX IF EXISTS idx_orders_order_date;
DROP INDEX IF EXISTS idx_orders_user_date;

EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT 
    u.full_name,
    o.order_date,
    o.total_amount
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY o.order_date
LIMIT 1000;

-- ПОСЛЕ оптимизации (создаем индексы обратно)
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_order_date ON orders(order_date);
CREATE INDEX idx_orders_user_date ON orders(user_id, order_date);

EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT 
    u.full_name,
    o.order_date,
    o.total_amount
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY o.order_date
LIMIT 1000;

-- 3. Анализ использования индексов
SELECT 
    relname as table_name,
    seq_scan,
    seq_tup_read,
    idx_scan,
    idx_tup_fetch,
    n_tup_ins,
    n_tup_upd,
    n_tup_del
FROM pg_stat_user_tables
WHERE relname IN ('users', 'orders', 'products', 'order_items');

-- 4. Сводная таблица сравнения
WITH before_after AS (
    SELECT 
        'До оптимизации' as period,
        COUNT(*) as total_orders,
        AVG(total_amount) as avg_order_amount,
        MIN(order_date) as first_order,
        MAX(order_date) as last_order
    FROM orders
    UNION ALL
    SELECT 
        'После оптимизации' as period,
        COUNT(*) as total_orders,
        AVG(total_amount) as avg_order_amount,
        MIN(order_date) as first_order,
        MAX(order_date) as last_order
    FROM orders
)
SELECT * FROM before_after;

-- 5. Рекомендации по оптимизации
SELECT 
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;
