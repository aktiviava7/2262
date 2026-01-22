-- Анализ производительности ДО оптимизации
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
