CREATE DATABASE lOAN; 
USE LOAN; 
-- Load data with table data import wizard available in right clicks on table in databse loan
drop table laon.loan;

--  First look on the table data 
select * from loan2; 
select * from customer; 
select * from peyment; 


-- Q1 : List all the customer who has taken loan more than 20000
SELECT name from loan2
join customer using(customer_id)
where loan_amount > 20000; 
-- ANS : 39 Customer


-- Q2 : Find the total number of loans taken by each cutomer
select customer_id , count(loan_id) from loan2 
group by customer_id;

-- Q3 : List out all details of loan taken in year 2023
-- 1. Disable safe mode again
SET SQL_SAFE_UPDATES = 0;

-- 2. Convert the text dates to the correct SQL format (YYYY-MM-DD)
-- We use '%d-%m-%Y' because your error showed '15-01-2023'
UPDATE LOAN2 
SET START_DATE = STR_TO_DATE(START_DATE, '%d-%m-%Y');

-- 3. Now that the data looks like '2023-01-15', change the column type
ALTER TABLE LOAN2 MODIFY START_DATE DATE;


SELECT * FROM LOAN2
WHERE START_DATE BETWEEN '2023-01-01' AND '2023-12-31';


-- Q4 : CALCULATE THE TOTAL AMOUNT PAID / TOTAL REVENUE
SELECT ROUND(SUM(AMOUNT_PAID),2) AS TOTAL_REVENUE FROM PEYMENT;

-- Q5 : FIND CUSTOMERS WHO HAVE NOT MADE ANY PEYMENT YET ?
SELECT CUSTOMER_ID, SUM(AMOUNT_PAID) AS AMOUNT FROM LOAN2 JOIN PEYMENT USING(LOAN_ID)
GROUP BY CUSTOMER_ID
ORDER BY 2 ASC;


-- Category B: Intermediate (Business Logic & Aggregation)
-- Q6: Identify customers who have 'Missed' at least one payment.

-- Q7: Calculate the Debt-to-Income (DTI) ratio for each customer. Formula: (Total Loan Amount / Annual Income) * 100

-- Q8 : Q8: Find the average interest rate for loans with a term longer than 24 months.

-- Q9: Which loan term (duration) is the most popular?
-- Q10: Classify loans into 'High Value' (> 20k) and 'Low Value' (< 20k).

-- *Category C: Advanced (Risk Analysis & Reporting)*
-- Q11: Find the "Default Rate" per month (Percentage of missed payments per month).

-- Q12: Identify "High Risk" customers (Customers with >1 Missed or >2 Late payments).

-- Q13: Find the customer with the highest total loan amount who has NEVER missed a payment. Logic: Filter out anyone who has ever missed, then sort by volume.

-- Q14: Calculate the "Running Total" of repayments for Loan ID 101. Window Function is required here.

-- Q15: Rank customers based on their income within their employment length group. Scenario: Compare people with similar experience.

-- Category D: Expert (Complex Scenarios & Optimization)
-- Q16: Find customers who missed consecutive payments. Uses LAG() to check the previous row's status.

-- Q17: Calculate the percentage of total portfolio value held by the top 10% of borrowers. Requires CTEs and Window Functions.

-- Q18: Identify "Vintage" performance (How do loans from 2023 perform vs 2024?).
-- Q19: Find the "Days Between Payments" for each customer to check for irregular behavior.

-- Q20: Create a View that summarizes Customer Credit Health for the dashboard.
