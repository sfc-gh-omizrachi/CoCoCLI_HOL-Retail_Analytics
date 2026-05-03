-- ============================================================
-- RetailMax Hands-on Lab - Dataset Deployment Script
-- Cortex Code CLI HOL - Retail Analytics
-- ============================================================
-- Run this script in a Snowflake SQL worksheet before starting the lab.
-- Estimated run time: 3-5 minutes
-- ============================================================

-- Setup
CREATE DATABASE IF NOT EXISTS RETAIL_MAX;
CREATE SCHEMA IF NOT EXISTS RETAIL_MAX.SALES_ANALYTICS;
USE DATABASE RETAIL_MAX;
USE SCHEMA SALES_ANALYTICS;

-- ============================================================
-- TABLE 1: STORES
-- 150 retail stores across 5 regions
-- ============================================================
CREATE OR REPLACE TABLE STORES (
    STORE_ID        NUMBER(6) PRIMARY KEY,
    STORE_NAME      VARCHAR(100),
    REGION          VARCHAR(50),
    CITY            VARCHAR(100),
    STATE           VARCHAR(2),
    STORE_TYPE      VARCHAR(50),
    OPEN_DATE       DATE,
    SQUARE_FOOTAGE  NUMBER(8),
    MANAGER_NAME    VARCHAR(100)
);

INSERT INTO STORES
WITH regions AS (
    SELECT 'Northeast' AS region, ARRAY_CONSTRUCT('NY','MA','CT','NJ','PA') AS states UNION ALL
    SELECT 'Southeast', ARRAY_CONSTRUCT('FL','GA','NC','SC','VA') UNION ALL
    SELECT 'Midwest',   ARRAY_CONSTRUCT('IL','OH','MI','IN','WI') UNION ALL
    SELECT 'Southwest', ARRAY_CONSTRUCT('TX','AZ','NM','CO','NV') UNION ALL
    SELECT 'West',      ARRAY_CONSTRUCT('CA','WA','OR','UT','ID')
),
store_types AS (
    SELECT 'Flagship'     AS stype UNION ALL
    SELECT 'Standard'     UNION ALL
    SELECT 'Express'      UNION ALL
    SELECT 'Outlet'
),
cities AS (
    SELECT 'New York'     AS city, 'NY' AS state UNION ALL
    SELECT 'Boston',       'MA' UNION ALL
    SELECT 'Hartford',     'CT' UNION ALL
    SELECT 'Newark',       'NJ' UNION ALL
    SELECT 'Philadelphia', 'PA' UNION ALL
    SELECT 'Miami',        'FL' UNION ALL
    SELECT 'Atlanta',      'GA' UNION ALL
    SELECT 'Charlotte',    'NC' UNION ALL
    SELECT 'Columbia',     'SC' UNION ALL
    SELECT 'Richmond',     'VA' UNION ALL
    SELECT 'Chicago',      'IL' UNION ALL
    SELECT 'Columbus',     'OH' UNION ALL
    SELECT 'Detroit',      'MI' UNION ALL
    SELECT 'Indianapolis', 'IN' UNION ALL
    SELECT 'Milwaukee',    'WI' UNION ALL
    SELECT 'Dallas',       'TX' UNION ALL
    SELECT 'Phoenix',      'AZ' UNION ALL
    SELECT 'Albuquerque',  'NM' UNION ALL
    SELECT 'Denver',       'CO' UNION ALL
    SELECT 'Las Vegas',    'NV' UNION ALL
    SELECT 'Los Angeles',  'CA' UNION ALL
    SELECT 'Seattle',      'WA' UNION ALL
    SELECT 'Portland',     'OR' UNION ALL
    SELECT 'Salt Lake City','UT' UNION ALL
    SELECT 'Boise',        'ID'
),
numbered AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY c.city, t.stype) AS rn,
        c.city, c.state, t.stype,
        CASE c.state
            WHEN 'NY' THEN 'Northeast' WHEN 'MA' THEN 'Northeast' WHEN 'CT' THEN 'Northeast'
            WHEN 'NJ' THEN 'Northeast' WHEN 'PA' THEN 'Northeast'
            WHEN 'FL' THEN 'Southeast' WHEN 'GA' THEN 'Southeast' WHEN 'NC' THEN 'Southeast'
            WHEN 'SC' THEN 'Southeast' WHEN 'VA' THEN 'Southeast'
            WHEN 'IL' THEN 'Midwest'   WHEN 'OH' THEN 'Midwest'   WHEN 'MI' THEN 'Midwest'
            WHEN 'IN' THEN 'Midwest'   WHEN 'WI' THEN 'Midwest'
            WHEN 'TX' THEN 'Southwest' WHEN 'AZ' THEN 'Southwest' WHEN 'NM' THEN 'Southwest'
            WHEN 'CO' THEN 'Southwest' WHEN 'NV' THEN 'Southwest'
            ELSE 'West'
        END AS region
    FROM cities c CROSS JOIN store_types t
)
SELECT
    rn AS store_id,
    city || ' ' || stype || ' #' || rn AS store_name,
    region,
    city,
    state,
    stype AS store_type,
    DATEADD(day, -UNIFORM(365, 3650, RANDOM()), CURRENT_DATE()) AS open_date,
    CASE stype
        WHEN 'Flagship' THEN UNIFORM(15000, 30000, RANDOM())
        WHEN 'Standard' THEN UNIFORM(8000, 15000, RANDOM())
        WHEN 'Express'  THEN UNIFORM(2000, 8000, RANDOM())
        ELSE UNIFORM(5000, 12000, RANDOM())
    END AS square_footage,
    'Manager ' || rn AS manager_name
FROM numbered
LIMIT 150;

-- ============================================================
-- TABLE 2: PRODUCTS
-- 500 products across 5 categories
-- ============================================================
CREATE OR REPLACE TABLE PRODUCTS (
    PRODUCT_ID      NUMBER(8) PRIMARY KEY,
    PRODUCT_NAME    VARCHAR(200),
    CATEGORY        VARCHAR(50),
    SUBCATEGORY     VARCHAR(50),
    UNIT_PRICE      NUMBER(10,2),
    COST            NUMBER(10,2),
    BRAND           VARCHAR(100)
);

INSERT INTO PRODUCTS
WITH cats AS (
    SELECT 'Electronics'    AS cat, 'Smartphones'    AS sub, 299.99  AS minp, 899.99  AS maxp, 120.00 AS minc, 500.00 AS maxc UNION ALL
    SELECT 'Electronics',          'Laptops',                 599.99,          1499.99,          300.00,          900.00 UNION ALL
    SELECT 'Electronics',          'Headphones',              29.99,            249.99,           10.00,           100.00 UNION ALL
    SELECT 'Clothing',             'T-Shirts',                9.99,             49.99,            3.00,            15.00 UNION ALL
    SELECT 'Clothing',             'Jeans',                   29.99,            129.99,           12.00,           45.00 UNION ALL
    SELECT 'Clothing',             'Outerwear',               49.99,            299.99,           20.00,           120.00 UNION ALL
    SELECT 'Home & Garden',        'Furniture',               99.99,            999.99,           40.00,           400.00 UNION ALL
    SELECT 'Home & Garden',        'Kitchen',                 19.99,            199.99,            8.00,            80.00 UNION ALL
    SELECT 'Sports',               'Fitness',                 24.99,            499.99,            10.00,           200.00 UNION ALL
    SELECT 'Sports',               'Outdoor',                 39.99,            399.99,            15.00,           160.00 UNION ALL
    SELECT 'Food & Beverage',      'Snacks',                  1.99,             19.99,             0.50,            6.00 UNION ALL
    SELECT 'Food & Beverage',      'Beverages',               2.49,             24.99,             0.80,            8.00
),
nums AS (SELECT SEQ4() + 1 AS n FROM TABLE(GENERATOR(ROWCOUNT => 500)))
SELECT
    n.n AS product_id,
    c.sub || ' Product ' || n.n AS product_name,
    c.cat AS category,
    c.sub AS subcategory,
    ROUND(c.minp + (c.maxp - c.minp) * RANDOM(), 2) AS unit_price,
    ROUND(c.minc + (c.maxc - c.minc) * RANDOM(), 2) AS cost,
    'Brand ' || MOD(n.n, 20) AS brand
FROM nums n
JOIN cats c ON MOD(n.n, 12) = MOD(ROW_NUMBER() OVER (ORDER BY c.cat, c.sub), 12);

-- ============================================================
-- TABLE 3: CUSTOMERS
-- 50,000 customers
-- ============================================================
CREATE OR REPLACE TABLE CUSTOMERS (
    CUSTOMER_ID     NUMBER(10) PRIMARY KEY,
    FIRST_NAME      VARCHAR(50),
    LAST_NAME       VARCHAR(50),
    EMAIL           VARCHAR(150),
    LOYALTY_TIER    VARCHAR(20),
    SIGNUP_DATE     DATE,
    PREFERRED_REGION VARCHAR(50)
);

INSERT INTO CUSTOMERS
WITH nums AS (SELECT SEQ4() + 1 AS n FROM TABLE(GENERATOR(ROWCOUNT => 50000)))
SELECT
    n AS customer_id,
    'First' || n AS first_name,
    'Last' || MOD(n, 1000) AS last_name,
    'customer' || n || '@retailmax.com' AS email,
    CASE MOD(n, 4)
        WHEN 0 THEN 'Platinum'
        WHEN 1 THEN 'Gold'
        WHEN 2 THEN 'Silver'
        ELSE 'Standard'
    END AS loyalty_tier,
    DATEADD(day, -UNIFORM(0, 1825, RANDOM()), CURRENT_DATE()) AS signup_date,
    CASE MOD(n, 5)
        WHEN 0 THEN 'Northeast'
        WHEN 1 THEN 'Southeast'
        WHEN 2 THEN 'Midwest'
        WHEN 3 THEN 'Southwest'
        ELSE 'West'
    END AS preferred_region
FROM nums;

-- ============================================================
-- TABLE 4: TRANSACTIONS
-- ~200,000 transactions over 24 months
-- ============================================================
CREATE OR REPLACE TABLE TRANSACTIONS (
    TRANSACTION_ID      NUMBER(12) PRIMARY KEY,
    STORE_ID            NUMBER(6) REFERENCES STORES(STORE_ID),
    CUSTOMER_ID         NUMBER(10) REFERENCES CUSTOMERS(CUSTOMER_ID),
    TRANSACTION_DATE    DATE,
    TRANSACTION_TIME    TIME,
    PAYMENT_METHOD      VARCHAR(30),
    STATUS              VARCHAR(20),
    TOTAL_AMOUNT        NUMBER(12,2)
);

INSERT INTO TRANSACTIONS
WITH nums AS (SELECT SEQ4() + 1 AS n FROM TABLE(GENERATOR(ROWCOUNT => 200000)))
SELECT
    n AS transaction_id,
    UNIFORM(1, 150, RANDOM()) AS store_id,
    UNIFORM(1, 50000, RANDOM()) AS customer_id,
    DATEADD(day, -UNIFORM(0, 730, RANDOM()), CURRENT_DATE()) AS transaction_date,
    TIMEADD(second, UNIFORM(28800, 75600, RANDOM()), '00:00:00') AS transaction_time,
    CASE MOD(n, 4)
        WHEN 0 THEN 'Credit Card'
        WHEN 1 THEN 'Debit Card'
        WHEN 2 THEN 'Cash'
        ELSE 'Mobile Pay'
    END AS payment_method,
    CASE WHEN MOD(n, 50) = 0 THEN 'Returned' ELSE 'Completed' END AS status,
    0 AS total_amount
FROM nums;

-- ============================================================
-- TABLE 5: TRANSACTION_ITEMS
-- ~500,000 line items
-- ============================================================
CREATE OR REPLACE TABLE TRANSACTION_ITEMS (
    ITEM_ID             NUMBER(14) PRIMARY KEY,
    TRANSACTION_ID      NUMBER(12) REFERENCES TRANSACTIONS(TRANSACTION_ID),
    PRODUCT_ID          NUMBER(8) REFERENCES PRODUCTS(PRODUCT_ID),
    QUANTITY            NUMBER(4),
    UNIT_PRICE          NUMBER(10,2),
    DISCOUNT_PCT        NUMBER(5,2),
    LINE_TOTAL          NUMBER(12,2)
);

INSERT INTO TRANSACTION_ITEMS
WITH nums AS (SELECT SEQ4() + 1 AS n FROM TABLE(GENERATOR(ROWCOUNT => 500000)))
SELECT
    n AS item_id,
    UNIFORM(1, 200000, RANDOM()) AS transaction_id,
    UNIFORM(1, 500, RANDOM()) AS product_id,
    UNIFORM(1, 5, RANDOM()) AS quantity,
    p.unit_price,
    CASE WHEN MOD(n, 10) = 0 THEN UNIFORM(5, 30, RANDOM()) ELSE 0 END AS discount_pct,
    ROUND(
        p.unit_price * UNIFORM(1, 5, RANDOM()) *
        (1 - CASE WHEN MOD(n, 10) = 0 THEN UNIFORM(5, 30, RANDOM()) / 100.0 ELSE 0 END),
        2
    ) AS line_total
FROM nums
JOIN PRODUCTS p ON UNIFORM(1, 500, RANDOM()) = p.product_id;

-- Update transaction totals
UPDATE TRANSACTIONS t
SET total_amount = (
    SELECT COALESCE(SUM(line_total), 0)
    FROM TRANSACTION_ITEMS ti
    WHERE ti.transaction_id = t.transaction_id
);

-- ============================================================
-- Verify deployment
-- ============================================================
SELECT 'STORES' AS tbl, COUNT(*) AS rows FROM STORES UNION ALL
SELECT 'PRODUCTS',      COUNT(*) FROM PRODUCTS UNION ALL
SELECT 'CUSTOMERS',     COUNT(*) FROM CUSTOMERS UNION ALL
SELECT 'TRANSACTIONS',  COUNT(*) FROM TRANSACTIONS UNION ALL
SELECT 'TRANSACTION_ITEMS', COUNT(*) FROM TRANSACTION_ITEMS
ORDER BY tbl;
