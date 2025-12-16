INSERT INTO users (full_name, email, created_at) VALUES
('Иван Иванов', 'ivan@mail.ru', '2024-01-10'),
('Петр Петров', 'petr@mail.ru', '2024-02-15'),
('Анна Смирнова', 'anna@mail.ru', '2024-03-20'),
('Ольга Кузнецова', 'olga@mail.ru', '2024-04-05');

INSERT INTO products (product_name, price) VALUES
('Ноутбук', 75000.00),
('Смартфон', 45000.00),
('Наушники', 5000.00),
('Клавиатура', 3500.00);

INSERT INTO orders (user_id, order_date) VALUES
(1, '2024-05-01'),
(2, '2024-05-02'),
(3, '2024-05-03'),
(1, '2024-05-04');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 2, 1),
(3, 4, 1);
