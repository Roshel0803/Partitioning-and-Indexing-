create database indexing;
use indexing;

CREATE TABLE FACT_SALES (
    sale_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    sale_date DATE NOT NULL,
    sales_amount DECIMAL(10,2) NOT NULL);
    
INSERT INTO FACT_SALES
(sale_id, customer_id, product_id, sale_date, sales_amount)
VALUES
(1, 101, 201, '2026-01-10', 1500.00),
(2, 102, 202, '2026-01-10', 2500.00),
(3, 101, 203, '2026-01-15', 1200.00),
(4, 103, 201, '2026-02-01', 3000.00),
(5, 104, 204, '2026-02-01', 1800.00),
(6, 102, 205, '2026-02-10', 2200.00),
(7, 101, 202, '2026-03-05', 3500.00),
(8, 105, 203, '2026-03-05', 2700.00),
(9, 103, 204, '2026-03-15', 1600.00),
(10, 104, 201, '2026-04-01', 4000.00),
(11, 102, 203, '2026-04-01', 1900.00),
(12, 105, 205, '2026-04-15', 3200.00);

select * from FACT_SALES;

-- single column index on sale_date
create index idx_sale_date
on FACT_SALES (sale_date);

select * from FACT_SALES
where sale_date = '2026-01-10';

-- composite index on (sale_date, customer_id)
CREATE INDEX idx_date_customer
ON FACT_SALES (sale_date, customer_id);

select * from FACT_SALES
WHERE sale_date = '2026-01-10'
  AND customer_id = 101;

-- Retrieve sales for a specific date
select * from FACT_SALES
WHERE sale_date = '2026-01-10';

-- Retrieve sales for a specific date and customer
select * from FACT_SALES
WHERE sale_date = '2026-01-10'
  AND customer_id = 101;
  
-- Retrieve sales using only customer_id
select * from FACT_SALES
WHERE customer_id = 102;

create index idx_customer_id
on FACT_SALES (customer_id);

-- Explain Date filter
explain select * from FACT_SALES
WHERE sale_date = '2026-01-10';

-- Explain Date and customer filter
explain select * from FACT_SALES
WHERE sale_date = '2026-01-10'
  AND customer_id = 101;
  
-- Explain Customer only filter
explain select * from FACT_SALES
WHERE customer_id = 102;
