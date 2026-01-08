# SQL-Loan-Analysis
# Loan Default Prediction & Risk Analysis - SQL Project

## 📌 Project Overview

**Domain:** FinTech / Banking

**Role:** Data Analyst / Risk Analyst

**Tools:** SQL (MySQL/PostgreSQL/SQL Server)

This project simulates a real-world **Credit Risk Analysis** environment. The goal was to analyze a dataset of customers, loans, and repayment history to identify **high-risk borrowers** and calculate key financial metrics like **Debt-to-Income (DTI) Ratios** and **Default Rates**.

The project moves beyond basic CRUD operations to demonstrate **complex business logic**, including **Vintage Analysis**, **Cohort Retention**, and **Window Functions** for trend analysis.

---

## 📂 Database Schema

The database consists of three relational tables designed to mimic a banking schema:

1. **`Customers`**: Stores demographic and income details (`cust_id`, `income`, `employment_len`).
2. **`Loans`**: Details of loan terms, interest rates, and amounts (`loan_id`, `loan_amount`, `term_months`).
3. **`Repayments`**: Transactional data tracking payment status (`pay_id`, `amount_paid`, `status` [Late/On-Time/Missed]).

---

## 🚀 Key Problems Solved

This project addresses specific business questions required for risk mitigation:

### 1. Risk Assessment & Classification

* **Default Flagging:** Identified customers who have 'Missed' payments to flag them as potential defaulters.
* **High-Risk Profiling:** Isolated customers with >1 missed payment or >2 late payments using `HAVING` clauses.
* **Consecutive Misses:** Used **Window Functions (`LAG`)** to find customers who missed two payments in a row (a critical risk indicator).

### 2. Financial Health Analysis

* **DTI Ratio Calculation:** Calculated the **Debt-to-Income Ratio** for every customer to determine loan eligibility.
* **Portfolio Concentration:** Calculated what percentage of the total loan portfolio is held by the top 10% of borrowers using `NTILE()`.

### 3. Temporal & Vintage Analysis

* **Default Rate over Time:** Calculated the monthly default rate percentage.
* **Vintage Analysis:** Compared the performance of loans issued in 2023 vs. 2024 to see if loan quality is improving or deteriorating.

---

## 💻 Technical Skills Demonstrated

* **Advanced Aggregation:** `GROUP BY`, `HAVING` for customer segmentation.
* **Joins:** Complex multi-table joins (3+ tables) to link customers to repayment behaviors.
* **Window Functions:** `RANK()`, `LAG()`, `OVER()`, and `NTILE()` for running totals and previous-row comparisons.
* **CTEs (Common Table Expressions):** Used for breaking down complex queries like consecutive default detection.
* **Data Cleaning:** Handling NULL values and creating conditional flags using `CASE WHEN`.

---

## 🔧 Setup & Installation

To replicate this analysis, follow these steps:

**Step 1: Database Initialization**
Run the `schema.sql` script (included in repo) to create the tables and insert the dummy dataset.

**Step 2: Run Analysis**
Execute the `analysis_queries.sql` file to generate the insights.

**Step 3: Key Query Example (Consecutive Defaults)**

```sql
/* Identifying customers who missed two consecutive payments 
   using Window Functions (LAG).
*/
WITH PaymentHistory AS (
    SELECT cust_id, payment_date, status,
           LAG(status) OVER (PARTITION BY cust_id ORDER BY payment_date) AS prev_status
    FROM Repayments r
    JOIN Loans l ON r.loan_id = l.loan_id
)
SELECT DISTINCT cust_id 
FROM PaymentHistory
WHERE status = 'Missed' AND prev_status = 'Missed';

```

---

## 📊 Sample Insights

* **Default Rate:** The highest default rate was observed in **August 2023** (Approx 12%).
* **DTI Analysis:** Customers with a DTI ratio > 40% accounted for 60% of all late payments.
* **Loan Terms:** 60-month loans have a 15% higher default risk compared to 24-month loans.

---

## 👤 Author
**Umesh Prakash Shelar**
