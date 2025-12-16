EXPLAIN ANALYZE
SELECT
    u.full_name,
    o.order_date
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.order_date > '2024-01-01';
