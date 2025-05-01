CREATE DATABASE Banking_Data;
USE Banking_Data;
SELECT * FROM bank_data_analystics;
SELECT * FROM debit_and_credit_banking_data;


/*KPI 1-Total Credit Amount*/

SELECT `Transaction Type`,
ROUND(SUM(Amount),2) AS Total_Credit_Amount
FROM debit_and_credit_banking_data
WHERE `Transaction Type` = 'Credit';

/*KPI 2-Total Debit Amount*/

SELECT `Transaction Type`,
ROUND(SUM(Amount),2) AS Total_Debit_Amount
FROM debit_and_credit_banking_data
WHERE `Transaction Type` = 'Debit';

/*KPI 3-Credit to Debit Ratio*/

SELECT 
CONCAT(ROUND(
SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END) /
SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END), 
3),':1') AS Credit_to_Debit_Ratio
FROM debit_and_credit_banking_data;

/*KPI 4-Net Transaction Amount*/

SELECT 
ROUND(
SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END) -
SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END),
2) AS Net_Transaction_Amount
FROM debit_and_credit_banking_data;

/*KPI 5-Account Activity Ratio*/

SELECT `Customer ID`,`Customer Name`,
COUNT(*) AS Total_Transactions,
SUM(Balance) AS Sum_Balance,
CONCAT(ROUND(COUNT(*)/SUM(Balance), 4),':1') AS Account_Activity_Ratio
FROM debit_and_credit_banking_data
GROUP BY `Customer ID`, `Customer Name`
ORDER BY Account_Activity_Ratio DESC;

SELECT 
COUNT(*) AS Total_Transactions,
ROUND(SUM(Balance),2) AS Total_Balance,
CONCAT(ROUND(COUNT(*) /SUM(Balance),4),':1') AS Account_Activity_Ratio
FROM debit_and_credit_banking_data;

/*KPI 6-Transactions per Day/Week/Month*/

SELECT `Day`,
COUNT(*) AS transactions_per_day
FROM debit_and_credit_banking_data
GROUP BY `Day`
ORDER BY FIELD(`Day`, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

SELECT `Week no`,
COUNT(*) AS transactions_per_week
FROM debit_and_credit_banking_data
GROUP BY `Week no`
ORDER BY `Week no`;

SELECT `Month`,
COUNT(*) AS transactions_per_month
FROM debit_and_credit_banking_data
GROUP BY `Month`
ORDER BY transactions_per_month DESC;

/*KPI 7-Total Transaction Amount by Branch*/

SELECT Branch,
ROUND(SUM(Amount),2) AS Total_Transaction_Amount
FROM debit_and_credit_banking_data
GROUP BY Branch
ORDER BY Total_Transaction_Amount DESC;

/*KPI 8-Transaction Volume by Bank*/

SELECT `Bank Name`, 
ROUND(SUM(Amount),2) AS Total_Transaction_Amount,
CONCAT(ROUND(SUM(Amount) * 100.0 / (SELECT SUM(Amount) FROM debit_and_credit_banking_data), 2),' %') AS Transaction_Percentage
FROM debit_and_credit_banking_data
GROUP BY `Bank Name`
ORDER BY Total_Transaction_Amount DESC;

/*KPI 9-Transaction Method Distribution*/

SELECT `Transaction Method`, 
COUNT(*) AS Transaction_Count,
CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM debit_and_credit_banking_data), 2),' %') AS Transaction_Percentage
FROM debit_and_credit_banking_data
GROUP BY `Transaction Method`
ORDER BY Transaction_Count DESC;

/*KPI 10-Branch Transaction Growth*/

SELECT Branch, 
YEAR(`Transaction Date`) AS Transaction_Year,
COUNT(*) AS Transaction_count,
CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM debit_and_credit_banking_data), 2),' %') AS Transaction_Percentage
FROM debit_and_credit_banking_data
GROUP BY Branch, Transaction_Year;

/*11-High-Risk Transaction Flag*/

SELECT `Customer ID`, `Customer Name`, `Account Number`, `Transaction Type`, Amount, 
CASE WHEN Amount > 3500 THEN 'High-Risk' ELSE 'Normal' 
END AS Risk_Flag
FROM debit_and_credit_banking_data;

/*12-Suspicious Transaction Frequency*/

SELECT `Transaction Date`, 
COUNT(*) AS Suspicious_Transaction_Count
FROM debit_and_credit_banking_data
WHERE Amount > 3500
GROUP BY `Transaction Date`
ORDER BY Suspicious_Transaction_Count DESC;















