# Cortex Code Hands-On Lab
## Building Retail Analytics with Cortex Code

**Duration:** 90 minutes | **Platform:** Snowflake Snowsight | **Industry:** Retail / E-commerce

---

## What You'll Build

In this lab you will use Cortex Code — Snowflake's AI coding agent — to build a complete retail analytics solution in three steps, using only natural language prompts:

| # | What You'll Build | Time |
|---|---|---|
| 1 | A Dynamic Table aggregating retail sales data by store, category, and time period | ~25 min |
| 2 | A Snowflake Intelligence Agent that answers natural language questions about retail performance | ~25 min |
| 3 | A Streamlit app providing a polished UI for retail insights | ~25 min |

You will write **three prompts**. Cortex Code does the rest.

---

## The Scenario

**RetailMax** is a mid-sized retail chain operating 150+ stores across the country, selling products across categories including Electronics, Clothing, Home & Garden, Sports, and Food & Beverage. Their data team needs to:

- Monitor store performance in real time without running expensive queries
- Let store managers ask natural language questions like "Which stores had the highest revenue last month?"
- Provide executives with a branded analytics app they can bookmark and share

You'll help them build the full solution — from raw data to production app — using only Cortex Code.

---

## Setup (~10 minutes)

### Step 1: Deploy the RetailMax Dataset

Open a SQL worksheet in Snowsight and run the setup script to create the RetailMax database and synthetic data:

1. In Snowsight, click **Projects** → **Worksheets** → **+**
2. Set your role and warehouse
3. Copy and run the contents of `scripts/deploy_retail_dataset.sql`

This creates:
- **Database:** `RETAIL_MAX`
- **Schema:** `SALES_ANALYTICS`
- **Tables:** `STORES`, `PRODUCTS`, `CUSTOMERS`, `TRANSACTIONS`, `TRANSACTION_ITEMS`
- **~500,000** synthetic rows across 5 tables

### Step 2: Open Cortex Code

1. Click the **blue star icon (✦)** in the bottom-right corner of Snowsight
2. Cortex Code opens as a side panel
3. It automatically connects using your current role and warehouse

> You are ready. Everything from here is done by pasting a prompt and reviewing what Cortex Code proposes.

---

## Part 1: Build a Dynamic Table (~25 minutes)

**The story:** RetailMax's raw transaction tables hold millions of rows and grow by thousands daily. Your analytics team needs a clean, always-refreshing aggregated summary by store, product category, and month — so leadership can track performance trends without running expensive joins on raw data every time.

### Instructions

1. Open the Cortex Code panel (blue star, bottom-right)
2. Copy the **Part 1 Prompt** from `prompts.md` and paste it into the Cortex Code input
3. Press **Enter**
4. Cortex Code will:
   - Discover the RetailMax tables and their relationships
   - Propose a Dynamic Table definition
   - Ask for your approval before creating anything
5. Review the proposed SQL. When satisfied, approve each step
6. Verify the table was created:

```sql
SHOW DYNAMIC TABLES LIKE 'RETAIL_MONTHLY_SUMMARY%';
SELECT * FROM RETAIL_MAX.SALES_ANALYTICS.RETAIL_MONTHLY_SUMMARY LIMIT 10;
```

### Expected Output

A Dynamic Table named `RETAIL_MONTHLY_SUMMARY` in `RETAIL_MAX.SALES_ANALYTICS` with columns including:

| Column | Description |
|---|---|
| `STORE_ID` | Store identifier |
| `STORE_NAME` | Store name |
| `REGION` | Geographic region |
| `CATEGORY` | Product category |
| `SALE_MONTH` | Year-month (e.g. 2025-03) |
| `TOTAL_REVENUE` | Total revenue for that store/category/month |
| `TOTAL_UNITS_SOLD` | Total units sold |
| `TOTAL_TRANSACTIONS` | Number of transactions |
| `AVG_BASKET_SIZE` | Average transaction value |
| `UNIQUE_CUSTOMERS` | Distinct customers who purchased |

---

## Part 2: Create a Snowflake Intelligence Agent (~25 minutes)

**The story:** The Dynamic Table is live and refreshing, but store managers and executives can't write SQL. You need a natural language interface so stakeholders can ask questions like "Which stores had declining revenue this quarter?" without touching code.

### Why Agent Instructions Matter

A Cortex Agent without system instructions gives generic, inconsistent answers. Good instructions define who the agent is, who it serves, what it can and cannot do, and how it should behave. The prompt for this part asks Cortex Code to generate production-quality instructions using a seven-layer framework:

| Layer | Purpose |
|---|---|
| Identity & Scope | Agent name, role, business outcome |
| User Context | Store managers, regional directors, executives |
| Domain Background | Retail terminology, KPIs, seasonality |
| Style & Tone | Concise, data-driven, actionable recommendations |
| Safeguards | What the agent must decline or handle carefully |
| Orchestration | Which tool to call for which question type |
| Response Instructions | Temporal rules, empty-result handling |

### Instructions

1. Keep the Cortex Code panel open
2. Copy the **Part 2 Prompt** from `prompts.md` and paste it in
3. Press **Enter**
4. Cortex Code will produce three things:
   - A **semantic view** on `RETAIL_MONTHLY_SUMMARY` with business-friendly labels and verified query examples
   - A **complete set of layered agent system instructions** ready to paste into Snowsight
   - **Step-by-step instructions** for wiring the agent in the UI
5. Review the semantic view YAML and approve it
6. Copy the generated agent instructions
7. Follow Cortex Code's instructions to create the Agent in Snowsight:
   - Navigate to **AI & ML → Agents** in the left nav
   - Click **+ Agent**
   - Name it `RETAIL_AGENT`
   - Paste the generated system instructions into the Instructions field
   - Under **Tools**, add the semantic view as a Cortex Analyst tool
   - Click **Create**
8. Test your agent:

> *"Which region had the highest revenue last month?"*
> *"Show me the top 5 stores by total revenue this year."*
> *"Which product category is growing fastest quarter over quarter?"*
> *"What is the average basket size across all stores?"*
> *"What happens if I ask about something not in the data?"* (tests safeguards)

### Expected Output

- A semantic view named `RETAIL_ANALYTICS_SV` in `RETAIL_MAX.SALES_ANALYTICS`
- A Cortex Agent with production-quality system instructions
- A working agent in Snowsight that answers retail questions accurately

---

## Part 3: Build a Streamlit Application (~25 minutes)

**The story:** Leadership loves the agent, but wants a branded, shareable interface they can bookmark — not a raw chat window. You need a polished Streamlit app deployed inside Snowflake, with a RetailMax brand look and suggested starter questions.

### Instructions

1. Keep the Cortex Code panel open
2. Copy the **Part 3 Prompt** from `prompts.md` and paste it in
3. Press **Enter**
4. Cortex Code will:
   - Generate a complete Streamlit in Snowflake application
   - Include a retail-themed UI with a text input, response display, and suggested questions
   - Create the app file and deploy it
5. When Cortex Code asks for approval, review the app code and approve
6. Open the deployed app:
   - Navigate to **Projects → Streamlit** in the left nav
   - Click your new app to open it
7. Test it by entering a question in the text box

### Expected Output

A deployed Streamlit app named `RETAILMAX_INSIGHTS_APP` featuring:

- A RetailMax-branded header with an analytics subtitle
- A text input field for natural language questions
- A response area displaying the agent's answer
- A sidebar with 5 suggested starter questions
- Clean, professional styling with Snowflake blue accents

---

## Wrap Up

You've built a complete retail analytics solution in 90 minutes using three natural language prompts:

1. **Raw data** → **Governed Dynamic Table** (always fresh, no expensive queries)
2. **Dynamic Table** → **Cortex Agent** with retail semantic understanding
3. **Cortex Agent** → **Polished Streamlit app** for store managers and executives

### Clean Up (Optional)

```sql
DROP DATABASE IF EXISTS RETAIL_MAX;
-- Remove the Streamlit app via Projects > Streamlit > your app > Delete
-- Remove the Agent via AI & ML > Agents > RETAIL_AGENT > Delete
```

---

## Tips & Troubleshooting

| Issue | Cause | Fix |
|---|---|---|
| Cortex Code can't find the tables | Dataset not deployed | Run `scripts/deploy_retail_dataset.sql` first |
| Dynamic Table shows 0 rows | Lag not fired yet | Run `ALTER DYNAMIC TABLE RETAIL_MAX.SALES_ANALYTICS.RETAIL_MONTHLY_SUMMARY REFRESH` |
| Agent gives no results | Semantic view invalid | Ask Cortex Code *"audit my semantic view for issues"* |
| Streamlit app shows an error | Deployment issue | Ask Cortex Code *"fix the error in my Streamlit app"* and paste the error |
| Running low on credits | Large operations | Switch to simpler follow-up prompts |

---

## Reference: Credit Usage

This lab is designed to run within **5 Cortex Code credits** per participant.

| Part | Tool Calls | Estimated Credits |
|---|---|---|
| Setup | 0 | 0 |
| Part 1 | 4–8 | ~0.15–0.25 |
| Part 2 | 5–8 | ~0.15–0.25 |
| Part 3 | 5–10 | ~0.15–0.30 |
| **Total** | **14–26** | **~0.45–0.80** |

---

## Additional Resources

- [Cortex Code CLI Documentation](https://docs.snowflake.com/en/user-guide/cortex-code/cortex-code-cli)
- [Dynamic Tables Documentation](https://docs.snowflake.com/en/user-guide/dynamic-tables-intro)
- [Cortex Agents Documentation](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-agents)
- [Streamlit in Snowflake](https://docs.snowflake.com/en/developer-guide/streamlit/about-streamlit)
- [Semantic Views Documentation](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst)

---

*Lab Version: 1.0 | Last Updated: April 2026 | Author: RetailMax HOL Team*
