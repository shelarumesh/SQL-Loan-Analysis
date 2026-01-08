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

-- Here is the complete End-to-End Implementation of Project 2: Loan Default Prediction & Risk Analysis.

This project is designed to simulate a real-world FinTech environment. It includes the Database Schema, Dummy Data, and 20 Interview Questions (Basic to Advanced) with solutions.

Part 1: The Setup (Schema & Data)
First, you need to build the database. Since you can't access real banking data, we will generate "realistic" dummy data using SQL.

Copy and paste this entire block into your SQL environment (MySQL, PostgreSQL, or SQL Server) to set up the project.

SQL

-- 1. Create Tables
CREATE TABLE Customers (
    cust_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    income DECIMAL(10,2),
    employment_len INT -- in years
);

CREATE TABLE Loans (
    loan_id INT PRIMARY KEY,
    cust_id INT,
    loan_amount DECIMAL(10,2),
    interest_rate DECIMAL(5,2),
    start_date DATE,
    term_months INT,
    FOREIGN KEY (cust_id) REFERENCES Customers(cust_id)
);

CREATE TABLE Repayments (
    pay_id INT PRIMARY KEY,
    loan_id INT,
    payment_date DATE,
    amount_paid DECIMAL(10,2),
    status VARCHAR(20), -- 'On-Time', 'Late', 'Missed'
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
);

-- 2. Insert Dummy Data (Small Sample for Practice)
INSERT INTO Customers VALUES 
(1, 'John Doe', 30, 60000, 5),
(2, 'Jane Smith', 45, 120000, 15),
(3, 'Robert Brown', 28, 45000, 2),
(4, 'Emily White', 35, 85000, 8),
(5, 'Michael Green', 50, 200000, 20);

INSERT INTO Loans VALUES 
(101, 1, 15000, 5.5, '2023-01-01', 24),
(102, 2, 50000, 4.2, '2023-03-15', 60),
(103, 3, 5000, 12.0, '2023-06-10', 12),
(104, 4, 25000, 6.0, '2023-02-20', 36),
(105, 1, 10000, 7.0, '2024-01-01', 24); -- John's 2nd loan

INSERT INTO Repayments VALUES 
(1001, 101, '2023-02-01', 650, 'On-Time'),
(1002, 101, '2023-03-01', 650, 'Late'),
(1003, 102, '2023-04-15', 900, 'On-Time'),
(1004, 103, '2023-07-10', 450, 'Missed'),
(1005, 103, '2023-08-10', 450, 'Missed'), -- Risk: Consecutive miss
(1006, 104, '2023-03-20', 750, 'On-Time'),
(1007, 105, '2024-02-01', 450, 'Late');
Part 2: The Interview Questions (Basic to Advanced)
This section is designed to mimic an interview flow. It starts with simple checks and moves to complex risk analysis.

Category A: Basic Data Retrieval (Sanity Checks)
Q1: List all customers who have taken a loan of more than $20,000.

SQL

SELECT c.name, l.loan_amount 
FROM Customers c 
JOIN Loans l ON c.cust_id = l.cust_id 
WHERE l.loan_amount > 20000;
Q2: Find the total number of loans taken by each customer.

SQL

SELECT cust_id, COUNT(loan_id) AS total_loans 
FROM Loans 
GROUP BY cust_id;
Q3: List the full details of all loans that started in the year 2023.

SQL

SELECT * FROM Loans 
WHERE start_date BETWEEN '2023-01-01' AND '2023-12-31';
-- OR: WHERE YEAR(start_date) = 2023 (database dependent)
Q4: Calculate the total revenue generated from interest so far (Assuming amount_paid includes interest). Note: This is a simplified view; normally you split principal vs interest.

SQL

SELECT SUM(amount_paid) AS total_collected FROM Repayments;
Q5: Find customers who have not made any repayments yet.

SQL

SELECT l.loan_id 
FROM Loans l 
LEFT JOIN Repayments r ON l.loan_id = r.loan_id 
WHERE r.pay_id IS NULL;


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
