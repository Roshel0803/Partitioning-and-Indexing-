create database listandhash;
use listandhash;

create table SALES (
    sale_id INT NOT NULL,
    region VARCHAR(30) NOT NULL,
    customer_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (sale_id, region)
);

INSERT INTO SALES
(sale_id, region, customer_id, amount)
VALUES
(1,  'India',     101, 1500.00),
(2,  'USA',       102, 2500.00),
(3,  'UK',        103, 1800.00),
(4,  'Australia', 104, 2200.00),
(5,  'India',     105, 3000.00),
(6,  'USA',       106, 4500.00),
(7,  'UK',        107, 1200.00),
(8,  'Australia', 108, 3500.00),
(9,  'India',     109, 2700.00),
(10, 'USA',       110, 3200.00),
(11, 'UK',        111, 4100.00),
(12, 'Australia', 112, 1900.00);

select * from sales;

CREATE TABLE SALES_LIST (
    sale_id INT NOT NULL,
    region VARCHAR(30) NOT NULL,
    customer_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (sale_id, region)
)
PARTITION BY LIST COLUMNS(region) (
    PARTITION p_india VALUES IN ('India'),
    PARTITION p_usa VALUES IN ('USA'),
    PARTITION p_uk VALUES IN ('UK'),
    PARTITION p_australia VALUES IN ('Australia')
);

INSERT INTO SALES_LIST
(sale_id, region, customer_id, amount)
SELECT sale_id, region, customer_id, amount
FROM SALES;

select * from sales_list;

-- Retrieve sales records for India and USA
select * from SALES_LIST
WHERE region IN ('India', 'USA');

-- hash partitioning using customer_id
CREATE TABLE SALES_HASH (
    sale_id INT NOT NULL,
    region VARCHAR(30) NOT NULL,
    customer_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (sale_id, customer_id)
)
PARTITION BY HASH(customer_id)
PARTITIONS 4;

INSERT INTO SALES_HASH
(sale_id, region, customer_id, amount)
SELECT sale_id, region, customer_id, amount
FROM SALES;

select * from SALES_HASH;

SELECT
    PARTITION_NAME,
    TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = 'retail_db'
  AND TABLE_NAME = 'SALES_HASH';
  
EXPLAIN
SELECT *
FROM SALES_HASH
WHERE customer_id = 105;