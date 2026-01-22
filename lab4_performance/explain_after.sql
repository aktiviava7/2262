-- Создание индексов для оптимизации
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_order_date ON orders(order_date);
CREATE INDEX IF NOT EXISTS idx_orders_user_date ON orders(user_id, order_date);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Анализ производительности ПОСЛЕ оптимизации
EXPLAIN (ANALYZE, BUFFERS, VERBOSE, TIMING)
SELECT
    u.full_name,
    o.order_date,
    o.total_amount,
    COUNT(oi.id) as items_count
FROM users u
JOIN orders o ON u.id = o.user_id
LEFT JOIN order_items oi ON o.id = oi.order_id
WHERE o.order_date > '2024-01-01'
GROUP BY u.id, u.full_name, o.id, o.order_date, o.total_amount
ORDER BY o.order_date DESC
LIMIT 500;

-- Дополнительный анализ с разными типами EXPLAIN
EXPLAIN (COSTS, ANALYZE, BUFFERS)
SELECT * FROM orders WHERE order_date > '2024-01-01';

EXPLAIN (ANALYZE, WAL)
UPDATE orders SET total_amount = total_amount * 1.1 
WHERE order_date > '2024-01-01';
