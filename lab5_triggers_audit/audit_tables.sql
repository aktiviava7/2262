-- Таблица для хранения истории изменений пользователей
CREATE TABLE users_audit (
    audit_id SERIAL PRIMARY KEY,
    operation_type VARCHAR(10) NOT NULL,
    user_id INT,
    old_full_name VARCHAR(100),
    new_full_name VARCHAR(100),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
