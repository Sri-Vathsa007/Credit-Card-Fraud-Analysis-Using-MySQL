-- CASE STATEMENT ANALYSIS

-- 1. Categorize transactions as "High", "Medium", or "Low" based on the Amount column, where "High" is greater than 3000, 
  -- "Medium" is between 1000 and 3000, and "Low" is less than 1000.
  
select *, 
CASE 
WHEN Amount > 3000 THEN "High"
WHEN Amount BETWEEN 1000 AND 3000 THEN "Medium"
ELSE "Low"
END as "Transaction Types" from credit_card_fraud_dataset;

-- 2. Create a column IsSuspicious to identify transactions where the TransactionType is "refund" 
  -- and the Amount is greater than 4000.

SELECT *, 
CASE 
WHEN TransactionType = "refund" and Amount > 4000 THEN "Suspicious"
ELSE "Not Suspicious"
END AS "IsSuspicious"
FROM credit_card_fraud_dataset;

-- 3. Add a column to classify transactions by location: "Major City" for "New York", 
 -- "Philadelphia", and "Dallas"; otherwise, classify them as "Other".
 
SELECT *, 
CASE 
WHEN Location IN ("New York","Philadelphia", "Dallas") THEN "Major City"
ELSE "Other"
END AS "City"
FROM credit_card_fraud_dataset;

-- Determine if a transaction occurred in Q1 (January to March), Q2 (April to June), 
-- Q3 (July to September), or Q4 (October to December) based on the TransactionDate column.

SELECT *,
CASE 
WHEN Month(TransactionDate) IN (1,2,3) THEN "Q1"
WHEN Month(TransactionDate) IN (4,5,6) THEN "Q2"
WHEN Month(TransactionDate) IN (7,8,9) THEN "Q3"
ELSE "Q4" END AS "Transaction Qtr"
FROM credit_card_fraud_dataset;

-- The Amount of Transactions that happended in each quarters
WITH TransactionQ as (
SELECT *,
CASE 
WHEN Month(TransactionDate) IN (1,2,3) THEN "Q1"
WHEN Month(TransactionDate) IN (4,5,6) THEN "Q2"
WHEN Month(TransactionDate) IN (7,8,9) THEN "Q3"
ELSE "Q4" END AS "Transaction Qtr"
FROM credit_card_fraud_dataset
)

SELECT SUM(Amount), `Transaction Qtr` FROM TransactionQ
WHERE TransactionType = "refund"
GROUP BY `Transaction Qtr`;

-- Rank Transactions by Amount Within Each Quarter
WITH TransactionQtrs as (
SELECT *,
CASE 
WHEN Month(TransactionDate) IN (1,2,3) THEN "Q1"
WHEN Month(TransactionDate) IN (4,5,6) THEN "Q2"
WHEN Month(TransactionDate) IN (7,8,9) THEN "Q3"
ELSE "Q4" END AS TransactionQtr
FROM credit_card_fraud_dataset
),
RankedTransactions AS (
SELECT TransactionID, TransactionQtr, Amount, RANK() Over (Partition By TransactionQtr ORDER BY Amount DESC) as R
FROM TransactionQtrs
)

SELECT * FROM RankedTransactions
ORDER BY TransactionQtr,R;

-- List Merchants with Multiple Refunds
WITH Merchants AS (
SELECT MerchantID, COUNT(*) As RefundCount
FROM credit_card_fraud_dataset
WHERE TransactionType = 'refund'
GROUP BY MerchantID
)
SELECT * FROM Merchants
WHERE RefundCount > 1;

-- Find Transactions with the Highest Amount Per Location
WITH MaxAmountPerLocation AS (
    SELECT 
        Location,
        MAX(Amount) AS MaxAmount
    FROM credit_card_fraud_dataset
    GROUP BY Location
)
SELECT 
    t.TransactionID,
    t.Location,
    t.Amount
FROM credit_card_fraud_dataset t
JOIN MaxAmountPerLocation m
ON t.Location = m.Location AND t.Amount = m.MaxAmount;

--  Calculate the Difference in Days Between Transactions
WITH OrderedTransactions AS (
    SELECT 
        TransactionID,
        TransactionDate,
        LAG(TransactionDate) OVER (ORDER BY TransactionDate) AS PreviousTransactionDate
    FROM credit_card_fraud_dataset
)	
SELECT 
    TransactionID,
    TransactionDate,
    PreviousTransactionDate,
    DATEDIFF(TransactionDate, PreviousTransactionDate) AS DaysDifference
FROM OrderedTransactions;

--  Filter Transactions That Occurred on Weekends
SELECT 
    TransactionID,
    TransactionDate,
    DAYOFWEEK(TransactionDate) AS DayOfWeek
FROM credit_card_fraud_dataset
WHERE DAYOFWEEK(TransactionDate) IN (1, 7);





 
