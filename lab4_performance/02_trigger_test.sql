-- Создание триггеров и проверка их работы

-- 1. Создаем таблицу аудита
CREATE TABLE IF NOT EXISTS audit_log (
    id SERIAL PRIMARY KEY,
    table_name VARCHAR(50),
    operation VARCHAR(10),
    record_id INTEGER,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    old_values JSONB,
    new_values JSONB
);

-- 2. Создаем функцию для триггера
CREATE OR REPLACE FUNCTION audit_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO audit_log (table_name, operation, record_id, new_values)
        VALUES (TG_TABLE_NAME, 'INSERT', NEW.id, row_to_json(NEW));
        RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO audit_log (table_name, operation, record_id, old_values, new_values)
        VALUES (TG_TABLE_NAME, 'UPDATE', NEW.id, row_to_json(OLD), row_to_json(NEW));
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO audit_log (table_name, operation, record_id, old_values)
        VALUES (TG_TABLE_NAME, 'DELETE', OLD.id, row_to_json(OLD));
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 3. Создаем триггер на таблицу orders
DROP TRIGGER IF EXISTS audit_orders_trigger ON orders;
CREATE TRIGGER audit_orders_trigger
AFTER INSERT OR UPDATE OR DELETE ON orders
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

-- 4. Тестируем триггеры
-- Вставка записи
EXPLAIN ANALYZE
INSERT INTO orders (user_id, order_date, total_amount)
VALUES (1, CURRENT_DATE, 500.00);

-- Обновление записи
EXPLAIN ANALYZE
UPDATE orders SET total_amount = 600.00 WHERE id = 1;

-- Удаление записи
EXPLAIN ANALYZE
DELETE FROM orders WHERE id = 1;

-- 5. Проверяем таблицу аудита
EXPLAIN ANALYZE
SELECT * FROM audit_log ORDER BY changed_at DESC LIMIT 5;

-- 6. Анализируем производительность триггеров
SELECT 
    COUNT(*) as total_audit_records,
    MIN(changed_at) as first_record,
    MAX(changed_at) as last_record
FROM audit_log;
