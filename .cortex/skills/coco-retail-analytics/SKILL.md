name: coco-retail-analytics
description: >
  Retail analytics skill for RetailMax. Analyzes store performance,
  product category trends, regional comparisons, and customer basket metrics
  using the RETAIL_MAX.SALES_ANALYTICS schema.
triggers:
  - retail analytics
  - store performance
  - category analysis
  - regional revenue
  - basket size
  - RetailMax

---

# RetailMax Retail Analytics Skill

## Purpose
This skill provides structured workflows for analyzing RetailMax retail data, including store performance, product category trends, regional comparisons, and customer behavior metrics.

## Data Context

**Database:** RETAIL_MAX  
**Schema:** SALES_ANALYTICS  
**Key Tables:** STORES, PRODUCTS, CUSTOMERS, TRANSACTIONS, TRANSACTION_ITEMS  
**Aggregation Layer:** RETAIL_MONTHLY_SUMMARY (Dynamic Table)

## Workflow

### Step 1: Identify the Analysis Request
Determine what the user wants to analyze:
- **Store Performance:** Revenue, transactions, basket size by store
- **Category Trends:** Revenue and units by product category over time
- **Regional Analysis:** Performance comparison across Northeast, Southeast, Midwest, Southwest, West
- **Customer Metrics:** Loyalty tier distribution, repeat purchase rates

### Step 2: Choose the Right Data Source
- For **aggregated monthly analysis**: Use `RETAIL_MONTHLY_SUMMARY`
- For **individual transaction details**: Join TRANSACTIONS + TRANSACTION_ITEMS + PRODUCTS + STORES
- For **customer segmentation**: Use CUSTOMERS joined to TRANSACTIONS

### Step 3: Apply Retail Business Logic
Always consider:
- **Exclude returned transactions** (STATUS = 'Completed' only)
- **Gross margin** = (LINE_TOTAL - COST * QUANTITY) / LINE_TOTAL
- **Comparable periods** when doing YoY or QoQ comparisons
- **Seasonality** — Q4 is always highest due to holiday sales

### Step 4: Present Results
Structure output as:
1. **Headline metric** — the direct answer
2. **Supporting breakdown** — table or chart
3. **Insight** — 1-2 sentence business interpretation
4. **Next question** — suggest a logical follow-up

## Example Analyses

### Top Stores by Revenue
```sql
SELECT 
    s.store_name,
    s.region,
    s.store_type,
    SUM(ti.line_total) AS total_revenue,
    COUNT(DISTINCT t.transaction_id) AS transactions,
    ROUND(SUM(ti.line_total) / COUNT(DISTINCT t.transaction_id), 2) AS avg_basket
FROM RETAIL_MAX.SALES_ANALYTICS.TRANSACTIONS t
JOIN RETAIL_MAX.SALES_ANALYTICS.TRANSACTION_ITEMS ti ON t.transaction_id = ti.transaction_id
JOIN RETAIL_MAX.SALES_ANALYTICS.STORES s ON t.store_id = s.store_id
WHERE t.status = 'Completed'
GROUP BY 1, 2, 3
ORDER BY total_revenue DESC
LIMIT 10;
```

### Category Performance by Month
```sql
SELECT
    TO_CHAR(t.transaction_date, 'YYYY-MM') AS sale_month,
    p.category,
    SUM(ti.line_total) AS revenue,
    SUM(ti.quantity) AS units_sold
FROM RETAIL_MAX.SALES_ANALYTICS.TRANSACTIONS t
JOIN RETAIL_MAX.SALES_ANALYTICS.TRANSACTION_ITEMS ti ON t.transaction_id = ti.transaction_id
JOIN RETAIL_MAX.SALES_ANALYTICS.PRODUCTS p ON ti.product_id = p.product_id
WHERE t.status = 'Completed'
GROUP BY 1, 2
ORDER BY 1, 3 DESC;
```

### Regional Comparison
```sql
SELECT
    s.region,
    SUM(ti.line_total) AS total_revenue,
    COUNT(DISTINCT t.store_id) AS store_count,
    ROUND(SUM(ti.line_total) / COUNT(DISTINCT t.store_id), 2) AS revenue_per_store
FROM RETAIL_MAX.SALES_ANALYTICS.TRANSACTIONS t
JOIN RETAIL_MAX.SALES_ANALYTICS.TRANSACTION_ITEMS ti ON t.transaction_id = ti.transaction_id
JOIN RETAIL_MAX.SALES_ANALYTICS.STORES s ON t.store_id = s.store_id
WHERE t.status = 'Completed'
GROUP BY 1
ORDER BY total_revenue DESC;
```

## Output Format
Always present retail analyses with:
- Monetary values formatted as `$X,XXX,XXX`
- Percentages with one decimal place
- Time periods clearly labeled (e.g., "Q1 2025", "March 2025")
- Rankings for comparative analyses

## Stopping Points
- **Before running expensive queries**: Ask if the user wants to filter by date range or specific region
- **When results are ambiguous**: Clarify whether they mean current month, last 30 days, or YTD
- **For large exports**: Confirm before generating full data dumps
