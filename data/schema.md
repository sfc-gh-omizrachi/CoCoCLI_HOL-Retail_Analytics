# RetailMax Data Schema

## Overview

The **RetailMax** dataset represents a mid-sized retail chain with 150 stores, 500 products, and 50,000 customers. It contains 24 months of transaction history (~200,000 transactions, ~500,000 line items).

---

## Entity Relationship Diagram

```
STORES (150 rows)
    └── TRANSACTIONS (200,000 rows)
            ├── CUSTOMERS (50,000 rows)
            └── TRANSACTION_ITEMS (500,000 rows)
                    └── PRODUCTS (500 rows)
```

---

## Tables

### STORES
| Column | Type | Description |
|---|---|---|
| STORE_ID | NUMBER | Primary key |
| STORE_NAME | VARCHAR | Full store name |
| REGION | VARCHAR | Geographic region (Northeast, Southeast, Midwest, Southwest, West) |
| CITY | VARCHAR | City name |
| STATE | VARCHAR(2) | State abbreviation |
| STORE_TYPE | VARCHAR | Flagship / Standard / Express / Outlet |
| OPEN_DATE | DATE | Date store opened |
| SQUARE_FOOTAGE | NUMBER | Store size in sq ft |
| MANAGER_NAME | VARCHAR | Store manager name |

### PRODUCTS
| Column | Type | Description |
|---|---|---|
| PRODUCT_ID | NUMBER | Primary key |
| PRODUCT_NAME | VARCHAR | Full product name |
| CATEGORY | VARCHAR | Electronics / Clothing / Home & Garden / Sports / Food & Beverage |
| SUBCATEGORY | VARCHAR | More specific category |
| UNIT_PRICE | NUMBER | Retail price |
| COST | NUMBER | Cost of goods |
| BRAND | VARCHAR | Brand name |

### CUSTOMERS
| Column | Type | Description |
|---|---|---|
| CUSTOMER_ID | NUMBER | Primary key |
| FIRST_NAME | VARCHAR | Customer first name |
| LAST_NAME | VARCHAR | Customer last name |
| EMAIL | VARCHAR | Customer email |
| LOYALTY_TIER | VARCHAR | Platinum / Gold / Silver / Standard |
| SIGNUP_DATE | DATE | Customer signup date |
| PREFERRED_REGION | VARCHAR | Customer's preferred region |

### TRANSACTIONS
| Column | Type | Description |
|---|---|---|
| TRANSACTION_ID | NUMBER | Primary key |
| STORE_ID | NUMBER | FK → STORES |
| CUSTOMER_ID | NUMBER | FK → CUSTOMERS |
| TRANSACTION_DATE | DATE | Date of transaction |
| TRANSACTION_TIME | TIME | Time of transaction |
| PAYMENT_METHOD | VARCHAR | Credit Card / Debit Card / Cash / Mobile Pay |
| STATUS | VARCHAR | Completed / Returned |
| TOTAL_AMOUNT | NUMBER | Total transaction value |

### TRANSACTION_ITEMS
| Column | Type | Description |
|---|---|---|
| ITEM_ID | NUMBER | Primary key |
| TRANSACTION_ID | NUMBER | FK → TRANSACTIONS |
| PRODUCT_ID | NUMBER | FK → PRODUCTS |
| QUANTITY | NUMBER | Units purchased |
| UNIT_PRICE | NUMBER | Price at time of purchase |
| DISCOUNT_PCT | NUMBER | Discount percentage applied |
| LINE_TOTAL | NUMBER | Final line item total |

---

## Key Business Metrics

| Metric | Formula |
|---|---|
| Revenue | SUM(LINE_TOTAL) |
| Gross Margin | (SUM(LINE_TOTAL) - SUM(COST * QUANTITY)) / SUM(LINE_TOTAL) |
| Basket Size | SUM(LINE_TOTAL) / COUNT(DISTINCT TRANSACTION_ID) |
| Units Per Transaction | SUM(QUANTITY) / COUNT(DISTINCT TRANSACTION_ID) |
| Customer Retention | COUNT(DISTINCT customers with 2+ transactions) / COUNT(DISTINCT customers) |

---

## Data Characteristics

- **Time Range:** Last 24 months of daily transactions
- **Seasonality:** Higher sales in Q4 (holiday season)
- **Regions:** 5 geographic regions with ~30 stores each
- **Categories:** 5 product categories with varying margin profiles
- **Fraud/Returns:** ~2% return rate
