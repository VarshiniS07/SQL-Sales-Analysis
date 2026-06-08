-- ================================================
-- SQL Sales Analysis Project
-- Author: Varshini S
-- GitHub: VarshiniS07
-- Tools: MySQL
-- Description: Sales data analysis using 3 tables
-- ================================================

-- Create and use database
CREATE DATABASE sales_analysis;
USE sales_analysis;

-- ================================================
-- TABLE CREATION
-- ================================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ================================================
-- SAMPLE DATA
-- ================================================

INSERT INTO customers VALUES
(1, 'Rahul Sharma', 'Mumbai', 'Maharashtra'),
(2, 'Priya Patel', 'Ahmedabad', 'Gujarat'),
(3, 'Ananya Singh', 'Delhi', 'Delhi'),
(4, 'Karthik Rajan', 'Chennai', 'Tamil Nadu'),
(5, 'Sneha Reddy', 'Hyderabad', 'Telangana'),
(6, 'Amit Kumar', 'Kolkata', 'West Bengal'),
(7, 'Divya Nair', 'Kochi', 'Kerala'),
(8, 'Rohit Verma', 'Jaipur', 'Rajasthan'),
(9, 'Meera Iyer', 'Bangalore', 'Karnataka'),
(10, 'Vijay Mehta', 'Pune', 'Maharashtra');

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 55000),
(2, 'Mobile Phone', 'Electronics', 18000),
(3, 'Headphones', 'Electronics', 2500),
(4, 'Desk Chair', 'Furniture', 8000),
(5, 'Notebook Set', 'Stationery', 350),
(6, 'Backpack', 'Accessories', 1500),
(7, 'Monitor', 'Electronics', 22000),
(8, 'Keyboard', 'Electronics', 1800),
(9, 'Study Table', 'Furniture', 12000),
(10, 'Pen Drive', 'Accessories', 600);

INSERT INTO orders VALUES
(1, 1, 1, 1, '2024-01-05'),
(2, 2, 2, 2, '2024-01-10'),
(3, 3, 3, 1, '2024-02-14'),
(4, 4, 4, 1, '2024-02-20'),
(5, 5, 5, 5, '2024-03-01'),
(6, 6, 6, 2, '2024-03-15'),
(7, 7, 7, 1, '2024-04-02'),
(8, 8, 8, 3, '2024-04-18'),
(9, 9, 9, 1, '2024-05-05'),
(10, 10, 10, 4, '2024-05-20'),
(11, 1, 2, 1, '2024-06-01'),
(12, 3, 1, 1, '2024-06-15'),
(13, 5, 7, 1, '2024-07-10'),
(14, 2, 4, 2, '2024-07-22'),
(15, 7, 3, 3, '2024-08-05');

-- ================================================
-- ANALYSIS QUERIES
-- ================================================

-- Q1: Total orders per customer
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC;

-- Q2: Products above 5000
SELECT product_name, category, price
FROM products
WHERE price > 5000;

-- Q3: Top 3 customers by spending
SELECT c.customer_name, SUM(p.price * o.quantity) AS total_amount
FROM orders o
JOIN products p ON p.product_id = o.product_id
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_amount DESC
LIMIT 3;

-- Q4: Monthly revenue trend
SELECT YEAR(order_date) AS year, MONTH(order_date) AS month,
SUM(p.price * o.quantity) AS revenue
FROM orders o
JOIN products p ON p.product_id = o.product_id
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;

-- Q5: Repeat customers
SELECT c.customer_name, COUNT(o.order_id) AS no_of_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 1;

-- Q6: Revenue per category
SELECT p.category, SUM(o.quantity * p.price) AS total_sales
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;

-- Q7: Most sold product
SELECT p.product_name, SUM(o.quantity) AS total_quantity
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 1;

-- Q8: Revenue per state
SELECT c.state, SUM(p.price * o.quantity) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON p.product_id = o.product_id
GROUP BY c.state
ORDER BY total_revenue DESC;

-- Q9: Orders in Q1 2024
SELECT o.order_id, c.customer_name, o.order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE YEAR(order_date) = 2024
AND MONTH(order_date) IN (1, 2, 3);

-- Q10: Average order value per category
SELECT p.category, AVG(p.price * o.quantity) AS avg_order_value
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY avg_order_value DESC;
