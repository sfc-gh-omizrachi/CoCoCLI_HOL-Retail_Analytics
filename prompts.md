# Cortex Code HOL - Retail Analytics Prompts

Copy and paste each prompt into the Cortex Code panel at the appropriate step.

---

## Part 1 Prompt — Build a Dynamic Table

```
I'm working on the RETAIL_MAX database in Snowflake. It has a schema called SALES_ANALYTICS with the following tables: STORES, PRODUCTS, CUSTOMERS, TRANSACTIONS, and TRANSACTION_ITEMS.

Please:
1. Explore the RETAIL_MAX.SALES_ANALYTICS schema and show me the table structures and row counts
2. Create a Dynamic Table called RETAIL_MONTHLY_SUMMARY that aggregates retail sales data with:
   - STORE_ID, STORE_NAME, and REGION from the STORES table
   - CATEGORY from the PRODUCTS table
   - SALE_MONTH (formatted as YYYY-MM)
   - TOTAL_REVENUE (sum of revenue)
   - TOTAL_UNITS_SOLD (sum of quantity)
   - TOTAL_TRANSACTIONS (count of distinct transactions)
   - AVG_BASKET_SIZE (average transaction value)
   - UNIQUE_CUSTOMERS (count of distinct customers)
3. Set a target lag of 1 hour
4. Show me a preview of the results after creation

Place the Dynamic Table in RETAIL_MAX.SALES_ANALYTICS and show me progress at each step.
```

---

## Part 2 Prompt — Create a Snowflake Intelligence Agent

```
I have a Dynamic Table called RETAIL_MAX.SALES_ANALYTICS.RETAIL_MONTHLY_SUMMARY with retail sales aggregations by store, category, and month.

Please:
1. Create a semantic view called RETAIL_ANALYTICS_SV on top of this Dynamic Table with:
   - Business-friendly labels for all columns (e.g., "Monthly Revenue", "Store Region", "Product Category")
   - At least 5 verified query examples covering common retail questions like top stores by revenue, category performance, regional comparisons, and month-over-month trends
   - Proper time dimension definitions for SALE_MONTH

2. Generate production-quality agent system instructions for a Cortex Agent called RETAIL_AGENT using a seven-layer framework:
   - Identity: A retail analytics assistant for RetailMax store managers and executives
   - User Context: Store managers, regional directors, and C-suite executives
   - Domain: Retail KPIs (revenue, basket size, units sold, customer count, category performance)
   - Style: Concise, data-driven, with actionable insights and comparisons
   - Safeguards: Decline questions about individual customer PII, competitor data, or forecasting beyond the data
   - Orchestration: Use the semantic view for all data questions
   - Response: Handle empty results gracefully, always show time period context

3. Give me step-by-step instructions to create the agent in Snowsight using the generated instructions

Show me the semantic view YAML before creating it so I can review it.
```

---

## Part 3 Prompt — Build a Streamlit Application

```
I have a Cortex Agent called RETAIL_AGENT connected to retail analytics data for RetailMax.

Please build and deploy a Streamlit in Snowflake application called RETAILMAX_INSIGHTS_APP with:

1. A professional RetailMax-branded header with a blue color scheme (#29B5E8) and a subtitle "Retail Analytics Powered by Snowflake Cortex"
2. A clean text input field with placeholder "Ask a question about retail performance..."
3. A response area that displays the agent's answer clearly, with any tables formatted nicely
4. A sidebar with these 5 suggested starter questions:
   - "Which region had the highest revenue last month?"
   - "Show me the top 5 stores by total revenue this year"
   - "Which product category is growing fastest?"
   - "What is the average basket size by store region?"
   - "Compare Electronics vs Clothing revenue this quarter"
5. A loading spinner while the agent is thinking
6. The app should use get_active_session() to connect to Snowflake

Make sure the app works in Streamlit in Snowflake (SiS) — avoid st.rerun(), use df.set_index() for charts, and keep the code SiS-compatible.

Deploy it to Snowflake in the RETAIL_MAX database, PUBLIC schema.
```
