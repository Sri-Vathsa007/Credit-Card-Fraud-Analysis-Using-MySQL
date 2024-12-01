# Credit Card Fraud Analysis

### 📊 Overview

This repository contains an SQL-based analysis of a credit card fraud dataset. The dataset includes details of transactions, such as TransactionID, TransactionDate, Amount, MerchantID, TransactionType, Location, and whether the transaction was fraudulent (IsFraud). The analysis explores patterns, trends, and insights using SQL queries, including advanced techniques like window functions, CTEs, and conditional statements.

The dataset includes the following columns:

TransactionID: Unique identifier for each transaction.
TransactionDate: Date when the transaction occurred.
Amount: Transaction amount.
MerchantID: Identifier of the merchant associated with the transaction.
TransactionType: Type of transaction (refund, purchase).
Location: City where the transaction occurred.
IsFraud: Binary flag indicating if the transaction is fraudulent (1 for fraud, 0 otherwise).

### 🛠️ Features

This repository demonstrates:

Basic SQL Queries: Extracting, filtering, and grouping data.
CASE Statements: Creating conditional logic within queries.
Common Table Expressions (CTEs): Simplifying complex queries for better readability.
Window Functions: Using LEAD and LAG for sequential row comparisons.
Date Analysis: Manipulating and analyzing the TransactionDate column for insights.
