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