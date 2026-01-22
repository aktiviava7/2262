-- Генерация пользователей (20 000 записей)
INSERT INTO users (full_name, email, created_at)
SELECT
    'User ' || gs,
    'user' || gs || '@mail.ru',  -- Исправлено: убраны непечатаемые символы
    CURRENT_DATE - (random() * 365)::INT
FROM generate_series(1, 20000) gs;

-- Генерация заказов (20 000 записей)
INSERT INTO orders (user_id, order_date, total_amount)
SELECT
    (random() * 19999 + 1)::INT,
    CURRENT_DATE - (random() * 365)::INT,
    (random() * 1000)::DECIMAL(10,2)
FROM generate_series(1, 20000);

-- Генерация товаров (20 000 записей)
INSERT INTO products (name, price, category_id)
SELECT
    'Product ' || gs,
    (random() * 1000)::DECIMAL(10,2),
    (random() * 10)::INT
FROM generate_series(1, 20000) gs;

-- Генерация позиций заказов (40 000 записей для связи many-to-many)
INSERT INTO order_items (order_id, product_id, quantity)
SELECT
    (random() * 19999 + 1)::INT,
    (random() * 19999 + 1)::INT,
    (random() * 10 + 1)::INT
FROM generate_series(1, 40000);
