-- Создание индексов
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_order_date ON orders(order_date);

-- Повторный анализ
EXPLAIN ANALYZE
SELECT
    u.full_name,
    o.order_date
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.order_date > '2024-01-01';
