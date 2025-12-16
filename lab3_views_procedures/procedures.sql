-- Процедура: добавление нового пользователя
CREATE OR REPLACE PROCEDURE add_user(
    p_full_name VARCHAR,
    p_email VARCHAR,
    p_created_at DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO users (full_name, email, created_at)
    VALUES (p_full_name, p_email, p_created_at);
END;
$$;

-- Процедура: создание заказа
CREATE OR REPLACE PROCEDURE create_order(
    p_user_id INT,
    p_order_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO orders (user_id, order_date)
    VALUES (p_user_id, p_order_date);
END;
$$;

CALL add_user('Сергей Волков', 'sergey@mail.ru', '2024-06-01');
CALL create_order(1, '2024-06-10');
