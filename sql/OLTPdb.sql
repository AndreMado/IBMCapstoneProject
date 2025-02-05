CREATE DATABASE IF NOT EXISTS sales;
USE sales;

CREATE TABLE IF NOT EXISTS sales_data(
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    price INT,
    quantity INT,
    time_stamp DATE
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '/var/lib/mysql-files/oltpdata.csv'
INTO TABLE sales_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(product_id, customer_id, price, quantity, time_stamp);

SET @index_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE table_schema = 'sales'
    AND table_name = 'sales_data'
    AND index_name = 'idx_time_stamp'
);

SET @query = IF(@index_exists = 0, 'CREATE INDEX idx_time_stamp ON sales_data(time_stamp);', 'SELECT "Index already exists";');

PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SHOW INDEX FROM sales_data;