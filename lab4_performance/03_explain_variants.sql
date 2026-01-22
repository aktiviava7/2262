-- Сравнение различных вариантов запросов с EXPLAIN ANALYZE

-- ВАРИАНТ 1: JOIN с фильтрацией по дате
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT 
    u.full_name,
    COUNT(o.id) as order_count,
    SUM(o.total_amount) as total_spent
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.order_date > '2024-01-01'
GROUP BY u.id, u.full_name
HAVING COUNT(o.id) > 5
ORDER BY total_spent DESC
LIMIT 100;

-- ВАРИАНТ 2: Подзапрос вместо JOIN
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT 
    u.full_name,
    (SELECT COUNT(*) FROM orders WHERE user_id = u.id AND order_date > '2024-01-01') as order_count,
    (SELECT SUM(total_amount) FROM orders WHERE user_id = u.id AND order_date > '2024-01-01') as total_spent
FROM users u
WHERE (SELECT COUNT(*) FROM orders WHERE user_id = u.id AND order_date > '2024-01-01') > 5
ORDER BY total_spent DESC
LIMIT 100;

-- ВАРИАНТ 3: CTE (Common Table Expression)
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
WITH user_orders AS (
    SELECT 
        user_id,
        COUNT(*) as order_count,
        SUM(total_amount) as total_spent
    FROM orders
    WHERE order_date > '2024-01-01'
    GROUP BY user_id
    HAVING COUNT(*) > 5
)
SELECT 
    u.full_name,
    uo.order_count,
    uo.total_spent
FROM users u
JOIN user_orders uo ON u.id = uo.user_id
ORDER BY uo.total_spent DESC
LIMIT 100;

-- ВАРИАНТ 4: Запрос с несколькими JOIN
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT 
    u.full_name,
    o.order_date,
    p.name as product_name,
    oi.quantity,
    o.total_amount
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.order_date > '2024-01-01'
AND p.price > 100
ORDER BY o.order_date DESC
LIMIT 100;

-- ВАРИАНТ 5: Запрос с оконными функциями
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT 
    u.full_name,
    o.order_date,
    o.total_amount,
    SUM(o.total_amount) OVER (PARTITION BY o.user_id) as user_total,
    RANK() OVER (ORDER BY o.total_amount DESC) as amount_rank
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.order_date > '2024-01-01'
ORDER BY o.total_amount DESC
LIMIT 100;
