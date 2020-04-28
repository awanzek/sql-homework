DROP TABLE IF EXISTS cardholder;
DROP TABLE IF EXISTS creditcard;
DROP TABLE IF EXISTS merchantcategory;
DROP TABLE IF EXISTS merchant;
DROP TABLE IF EXISTS transactions;

CREATE TABLE cardholder (
	cardholder_id INT PRIMARY KEY,
	name VARCHAR(255)
);

CREATE TABLE creditcard
(
	card BIGINT PRIMARY KEY,
	cardholder_id INT REFERENCES cardholder(cardholder_id)
);

CREATE TABLE merchantcategory
(
	category_id INT PRIMARY KEY,
	category varchar(255)
);

CREATE TABLE merchant
(
	merchant_id INT PRIMARY KEY,
	merchant_name VARCHAR(255),
	category_id INT REFERENCES merchantcategory(category_id)
);

CREATE TABLE transactions
(
	transaction_id INT PRIMARY KEY,
	date TIMESTAMP,
	Amount MONEY,
	card BIGINT REFERENCES creditcard(card),
	merchant_id INT REFERENCES merchant(merchant_id)
);
