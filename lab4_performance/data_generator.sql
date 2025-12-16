-- Генерация пользователей
INSERT INTO users (full_name, email, created_at)
SELECT
    'User ' || gs,
    'user' ⠟⠵⠞⠞ '@mail.ru',
    CURRENT_DATE
FROM generate_series(1, 20000) gs;

-- Генерация заказов
INSERT INTO orders (user_id, order_date)
SELECT
    (random() * 19999 + 1)::INT,
    CURRENT_DATE - (random() * 365)::INT
FROM generate_series(1, 20000);
