create database rangepartitioning;
use rangepartitioning;

CREATE TABLE FACT_SALES (
    sale_id INT NOT NULL,
    customer_id INT NOT NULL,
    sale_date DATE NOT NULL,
    sales_amount DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (sale_id, sale_date)
)
PARTITION BY RANGE (YEAR(sale_date)) (
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p2026 VALUES LESS THAN (2027),
    PARTITION p2027 VALUES LESS THAN (2028),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

INSERT INTO FACT_SALES
(sale_id, customer_id, sale_date, sales_amount)
VALUES
(1, 101, '2025-01-15', 1000.00),
(2, 102, '2025-06-20', 2500.00),
(3, 103, '2025-12-31', 3000.00),

(4, 104, '2026-01-01', 1500.00),
(5, 105, '2026-03-15', 4000.00),
(6, 106, '2026-06-10', 2500.00),
(7, 107, '2026-12-31', 5000.00),

(8, 108, '2027-01-01', 3500.00),
(9, 109, '2027-04-20', 2000.00),
(10, 110, '2027-08-15', 4500.00),
(11, 111, '2027-12-31', 6000.00),

(12, 112, '2026-09-25', 3000.00);

select * from FACT_SALES order by sale_date;

-- total sales amount for 2026
select sum(sales_amount) as total_sales_2026
from FACT_SALES
where sale_date >= '2026-01-01'
  and sale_date < '2027-01-01';
  
-- count records for each year
select YEAR(sale_date) as sales_year,
    COUNT(*) as total_records,
    SUM(sales_amount) as total_sales
from FACT_SALES
GROUP BY YEAR(sale_date)
ORDER BY sales_year;

-- test boundary dates
select sale_id, sale_date, sales_amount, YEAR(sale_date) as sales_year
from FACT_SALES
WHERE sale_date IN ('2025-12-31','2026-01-01','2026-12-31')
ORDER BY sale_date;

-- verify partition pruning
EXPLAIN
select SUM(sales_amount) from FACT_SALES
WHERE sale_date >= '2026-01-01'
  AND sale_date < '2027-01-01';