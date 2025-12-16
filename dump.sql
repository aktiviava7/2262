-- Dump schema for internet shop database
-- PostgreSQL 15+

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    created_at DATE
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC(10,2)
);
