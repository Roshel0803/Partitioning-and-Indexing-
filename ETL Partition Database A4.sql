create database etl_partition;
use etl_partition;

CREATE TABLE FACT_SALESS (
    sale_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    sale_date DATE NOT NULL,
    sales_amount DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (sale_id, sale_date)
)
PARTITION BY RANGE COLUMNS (sale_date) (
    PARTITION p2025 VALUES LESS THAN ('2026-01-01'),
    PARTITION p2026_01 VALUES LESS THAN ('2026-02-01'),
    PARTITION p2026_02 VALUES LESS THAN ('2026-03-01'),
    PARTITION p2026_03 VALUES LESS THAN ('2026-04-01'),
    PARTITION p2026_04 VALUES LESS THAN ('2026-05-01'),
    PARTITION p2026_05 VALUES LESS THAN ('2026-06-01'),
    PARTITION p2026_06 VALUES LESS THAN ('2026-07-01'),
    PARTITION p2026_07 VALUES LESS THAN ('2026-08-01'),
    PARTITION p2026_08 VALUES LESS THAN ('2026-09-01'),
    PARTITION p2026_09 VALUES LESS THAN ('2026-10-01'),
    PARTITION p2026_10 VALUES LESS THAN ('2026-11-01'),
    PARTITION p2026_11 VALUES LESS THAN ('2026-12-01'),
    PARTITION p2026_12 VALUES LESS THAN ('2027-01-01'),
    PARTITION p2027 VALUES LESS THAN ('2028-01-01'),
    PARTITION p_future VALUES LESS THAN (MAXVALUE)
);

INSERT INTO FACT_SALESS
(sale_id, customer_id, product_id, sale_date, sales_amount)
VALUES
-- 2025
(1, 101, 201, '2025-01-15', 1500.00),
(2, 102, 202, '2025-06-20', 2500.00),
(3, 103, 203, '2025-12-31', 3000.00),

-- 2026 January
(4, 104, 201, '2026-01-01', 1800.00),
(5, 105, 202, '2026-01-15', 2200.00),

-- 2026 August
(6, 101, 204, '2026-08-01', 3500.00),
(7, 102, 205, '2026-08-10', 4200.00),
(8, 103, 203, '2026-08-15', 2800.00),
(9, 104, 201, '2026-08-31', 5000.00),

-- 2026 December
(10, 105, 202, '2026-12-31', 3200.00),

-- 2027
(11, 101, 203, '2027-01-01', 4500.00),
(12, 102, 204, '2027-04-15', 2700.00),
(13, 103, 205, '2027-12-31', 6000.00);

select * from fact_saless;

-- Index for date-based queries
CREATE INDEX idx_sales_date
ON FACT_SALESS (sale_date);

-- Index for date and customer-based queries
CREATE INDEX idx_sales_date_customer
ON FACT_SALESS (sale_date, customer_id);

-- total sales for August 2026 
SELECT SUM(sales_amount) AS total_sales_august_2026
FROM FACT_SALES
WHERE sale_date >= '2026-08-01'
  AND sale_date <  '2026-09-01';
  
-- using EXPLAIN to identify performance bottlenecks
EXPLAIN SELECT
    SUM(sales_amount) AS total_sales_august_2026
FROM FACT_SALESS
WHERE sale_date >= '2026-08-01'
  AND sale_date <  '2026-09-01';
  
-- verify a specific partition for August 2026
SELECT COUNT(*) AS august_record_count,
       SUM(sales_amount) AS august_sales_total
FROM FACT_SALESS PARTITION (p2026_08);

-- test boundary dates
