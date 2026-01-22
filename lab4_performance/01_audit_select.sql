-- Анализ производительности через системные представления

-- 1. Размер таблиц
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname || '.' || tablename)) as total_size
FROM pg_tables 
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY pg_total_relation_size(schemaname || '.' || tablename) DESC;

-- 2. Статистика использования индексов
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan as index_scans,
    idx_tup_read as tuples_read,
    idx_tup_fetch as tuples_fetched
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;

-- 3. Медленные запросы (если включен pg_stat_statements)
SELECT 
    query,
    calls,
    total_time,
    mean_time,
    rows
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;

-- 4. Активные блокировки
SELECT 
    pid,
    usename,
    query,
    wait_event_type,
    wait_event
FROM pg_stat_activity
WHERE state = 'active';

-- 5. Проверка заполненности таблиц
SELECT 
    n_live_tup as live_tuples,
    n_dead_tup as dead_tuples,
    last_vacuum,
    last_autovacuum
FROM pg_stat_user_tables
WHERE relname IN ('users', 'orders', 'products', 'order_items');
