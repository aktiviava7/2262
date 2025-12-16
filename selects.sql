-- Запрос 1: список заказов пользователей
SELECT
    u.full_name,
    o.order_date
FROM users u
JOIN orders o ON u.id = o.user_id;

-- Запрос 2: состав заказов с товарами
SELECT
    u.full_name,
    p.product_name,
    oi.quantity,
    p.price
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id;
