-- Функция аудита изменений пользователей
CREATE OR REPLACE FUNCTION log_user_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO users_audit (
            operation_type,
            user_id,
            new_full_name
        )
        VALUES (
            'INSERT',
            NEW.id,
            NEW.full_name
        );
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO users_audit (
            operation_type,
            user_id,
            old_full_name,
            new_full_name
        )
        VALUES (
            'UPDATE',
            OLD.id,
            OLD.full_name,
            NEW.full_name
        );
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO users_audit (
            operation_type,
            user_id,
            old_full_name
        )
        VALUES (
            'DELETE',
            OLD.id,
            OLD.full_name
        );
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Триггер аудита
CREATE TRIGGER audit_user_changes
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW
EXECUTE FUNCTION log_user_changes();
