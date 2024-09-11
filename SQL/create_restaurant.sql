  -- Drop tables if they exist
  DROP TABLE IF EXISTS staff;
  DROP TABLE IF EXISTS menu;
  DROP TABLE IF EXISTS customers;
  DROP TABLE IF EXISTS transactions;

  -- Create tables
  CREATE TABLE staff (
    staff_id INTEGER,
    name TEXT,
    job TEXT
  );

  CREATE TABLE menu (
    menu_id INTEGER,
    name TEXT,
    type TEXT,
    price REAL
  );

  CREATE TABLE customers (
    customer_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    birthdate TEXT
  );

  CREATE TABLE transactions (
    transaction_id INTEGER,
    customer_id INTEGER,
    staff_id INTEGER,
    menu_id INTEGER,
    quantity INTEGER,
    transaction_date TEXT
  );

  -- Insert sample data into tables
  INSERT INTO staff VALUES 
    (1, 'James', 'Chef'),
    (2, 'Mary', 'Waitress'),
    (3, 'John', 'Waitress'),
    (4, 'Susan', 'Manager'),
    (5, 'Mike', 'Bartender'),
    (6, 'Anna', 'Waitress');

  INSERT INTO menu VALUES 
    (1, 'Pizza', 'Food', 10.99),
    (2, 'Hamburger', 'Food', 5.99),
    (3, 'Fried Chicken', 'Food', 8.99),
    (4, 'Coke', 'Drink', 2.99),
    (5, 'Water', 'Drink', 1.99),
    (6, 'Pasta', 'Food', 12.99),
    (7, 'Salad', 'Food', 7.99),
    (8, 'Coffee', 'Drink', 3.99),
    (9, 'Tea', 'Drink', 2.49);

  INSERT INTO customers VALUES 
    (1, 'James', 'Smith', '1990-01-01'),
    (2, 'Mary', 'Jane', '1991-02-02'),
    (3, 'John', 'Doe', '1992-03-03'),
    (4, 'Jane', 'Doe', '1990-01-01'),
    (5, 'Emily', 'Clark', '1988-04-04'),
    (6, 'David', 'Brown', '1989-05-05'),
    (7, 'Daniel', 'Wilson', '1993-06-06'),
    (8, 'Sophia', 'Davis', '1994-07-07'),
    (9, 'Olivia', 'Miller', '1987-08-08');

  INSERT INTO transactions VALUES 
    (1, 1, 1, 1, 2, '2024-06-01'),
    (2, 2, 2, 2, 1, '2024-06-02'),
    (3, 3, 3, 3, 3, '2024-06-03'),
    (4, 4, 4, 4, 2, '2024-06-04'),
    (5, 5, 5, 5, 1, '2024-06-05'),
    (6, 6, 6, 6, 1, '2024-06-06'),
    (7, 7, 1, 7, 2, '2024-06-07'),
    (8, 8, 2, 8, 3, '2024-06-08'),
    (9, 9, 3, 9, 4, '2024-06-09'),
    (10, 1, 4, 1, 1, '2024-06-10'),
    (11, 2, 5, 2, 2, '2024-06-11'),
    (12, 3, 6, 3, 1, '2024-06-12'),
    (13, 4, 1, 4, 3, '2024-06-13'),
    (14, 5, 2, 5, 2, '2024-06-14'),
    (15, 6, 3, 6, 1, '2024-06-15'),
    (16, 7, 4, 7, 2, '2024-06-16'),
    (17, 8, 5, 8, 3, '2024-06-17'),
    (18, 9, 6, 9, 4, '2024-06-18'),
    (19, 1, 1, 1, 2, '2024-06-19'),
    (20, 2, 2, 2, 1, '2024-06-20');

-- which menu is the most popular?
-- top 5 menu sold
SELECT menu.name, COUNT(*), SUM(quantity) 
FROM transactions
JOIN menu
ON transactions.menu_id = menu.menu_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- drink transaction
WITH drink_menu AS (
  SELECT
      menu_id,
      name
    FROM menu
    WHERE type = 'Drink'
)
SELECT 
  drink_menu.name as drink_name, 
    count(*) AS drink_transaction, 
    SUM(quantity) AS drink_quantity
from transactions
JOIN drink_menu ON drink_menu.menu_id = transactions.menu_id

-- customer revenue / total spending
SELECT
  c.first_name || ' ' || c.last_name as customer_full_name,
    total_spending
from 
(SELECT t.customer_id, ROUND(SUM(t.quantity * m.price), 2) AS total_spending
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
JOIN menu m ON t.menu_id = m.menu_id
GROUP BY 1) AS customer_spending
JOIN customers c ON customer_spending.customer_id = c.customer_id
ORDER BY 2 DESC
