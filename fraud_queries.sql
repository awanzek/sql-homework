--JOIN DATA FROM THE TABLES TO VIEW TRANSACTION DATA GROUPED BY CARDHOLDER
SELECT cardholder.cardholder_id,cardholder.name,date,amount,transactions.card,category 
FROM cardholder INNER JOIN
creditcard ON cardholder.cardholder_id=creditcard.cardholder_id
INNER JOIN transactions ON creditcard.card=transactions.card
INNER JOIN merchant ON transactions.merchant_id=merchant.merchant_id
INNER JOIN merchantcategory ON merchant.category_id=merchantcategory.category_id
ORDER BY cardholder.cardholder_id;


--SORT THE JOINED DATA SHOWING TRANSACTIONS FOR EACH CARDHOLDER
--SORT THE DATA BY VALUE OF THE AMOUNT FROM HIGHEST TO LOWEST AND LIMIT TO TOP 100 ROWS
SELECT cardholder.cardholder_id,cardholder.name,date,amount,transactions.card,category,merchant_name 
FROM cardholder INNER JOIN 
creditcard ON cardholder.cardholder_id=creditcard.cardholder_id
INNER JOIN transactions ON creditcard.card=transactions.card
INNER JOIN merchant ON transactions.merchant_id=merchant.merchant_id
INNER JOIN merchantcategory ON merchant.category_id=merchantcategory.category_id
WHERE date::date BETWEEN date '2018-01-01' AND date '2018-12-31'
  AND date::time BETWEEN time '07:00:00' AND time '09:00:00'
ORDER BY amount DESC
LIMIT(100);


--SORT THE JOINED DATA SHOWING TRANSACTIONS FOR EACH CARDHOLDER
--SORT THE DATA BY VALUE OF THE AMOUNT FROM HIGHEST TO LOWEST AND LIMIT TO TOP 100 ROWS
--SEEMS THAT THERE ARE MANY CHARGES IN THE TOP 100 THAT ARE ODDLY HIGH FOR 7-9AM 
--THE ODD CHARGES ARE ALSO FROM ODD CATEGORIES SUCH AS BAR/PUB FOR 7-9AM 
--OR THE CHARGES ARE ALSO ODDLY HIGH FOR ANY COFFEE OR BREAKFAST BILL THAT MAY SEEM TYPICAL FOR 7-9AM
SELECT cardholder.cardholder_id,cardholder.name,date,amount,transactions.card,category,merchant_name  
FROM cardholder INNER JOIN 
creditcard ON cardholder.cardholder_id=creditcard.cardholder_id
INNER JOIN transactions ON creditcard.card=transactions.card
INNER JOIN merchant ON transactions.merchant_id=merchant.merchant_id
INNER JOIN merchantcategory ON merchant.category_id=merchantcategory.category_id
WHERE date::date BETWEEN date '2018-01-01' AND date '2018-12-31'
  AND date::time BETWEEN time '07:00:00' AND time '09:00:00'
  AND amount::money > '100.00'
ORDER BY amount DESC
LIMIT(100);

--SORT THE DATA TO FIND CHARGES UNDER $2.00 FROM "MICRO HACKERS"
SELECT cardholder.cardholder_id,cardholder.name,date,amount,transactions.card,category AS microhacks
FROM cardholder INNER JOIN
creditcard ON cardholder.cardholder_id=creditcard.cardholder_id
INNER JOIN transactions ON creditcard.card=transactions.card
INNER JOIN merchant ON transactions.merchant_id=merchant.merchant_id
INNER JOIN merchantcategory ON merchant.category_id=merchantcategory.category_id
WHERE amount::money < '2.00' 
ORDER BY amount ASC;
--Yes there is evidence of card hacking on micro scale. Some transactions form restaurants are only cents which is abnormal.


--Top 5 Merchants in prone to Micro Hacking with small Transactions
SELECT merchant_name, COUNT(*) AS possible_fraud_charges
FROM(
	SELECT cardholder.cardholder_id,cardholder.name,date,amount,transactions.card,category,merchant_name  
	FROM cardholder INNER JOIN 
	creditcard ON cardholder.cardholder_id=creditcard.cardholder_id
	INNER JOIN transactions ON creditcard.card=transactions.card
	INNER JOIN merchant ON transactions.merchant_id=merchant.merchant_id
	INNER JOIN merchantcategory ON merchant.category_id=merchantcategory.category_id
	WHERE amount::money < '2.00') AS microhacks
GROUP BY merchant_name
ORDER BY possible_fraud_charges DESC
LIMIT(5);