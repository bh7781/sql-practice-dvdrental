/*---------------------------------------------------------------
DVDR-P1-001: Core SELECT & Basic Filtering
List the first name, last name, and email of every *active*
customer who belongs to *store 1*.
Sort the results alphabetically by last_name, then first_name.

Table reference:
customer(first_name, last_name, email, active, store_id)
----------------------------------------------------------------*/

SELECT first_name, last_name, email
FROM dvdrental.customer
WHERE store_id = 1 AND activebool IS TRUE
ORDER BY last_name, first_name;

/*---------------------------------------------------------------
Optimization Tip:

PostgreSQL allows multiple ways to write boolean conditions.
These are all equivalent and valid:
    activebool
    activebool = TRUE
    activebool IS TRUE

Similarly, for false conditions:
    NOT activebool
    activebool = FALSE
    activebool IS FALSE

Prefer using the shortest form (e.g., "activebool" or "NOT activebool")
for readability and conciseness.
----------------------------------------------------------------*/

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-002: Core SELECT & Basic Filtering
Show the full name (first_name + last_name), email, and
active status of all customers whose first name starts with 'A'.

Sort results by first name, then last name.

Table reference:
dvdrental.customer(first_name, last_name, email, activebool)
----------------------------------------------------------------*/

SELECT 
	concat(first_name, ' ', last_name) AS full_name,
	email,
	activebool AS active_status
FROM dvdrental.customer
WHERE first_name LIKE 'A%'
ORDER BY first_name, last_name;

/*---------------------------------------------------------------
Notes:
Why use single quotes with LIKE:
	- In PostgreSQL, string values (like 'A%') must be enclosed in single quotes.
	- Double quotes are reserved for *identifiers* like column or table names.
	- Using "A%" causes an error because PostgreSQL looks for a column named A%.

CONCAT vs ||:
	- You can also concatenate strings using the `||` operator:
	  Example: first_name || ' ' || last_name
	- CONCAT() is more readable and consistent across dialects.

Aliasing best practice:
	- Use AS to rename columns in output, especially when transforming data.
----------------------------------------------------------------*/

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-003: DISTINCT
Find all unique first names of customers who have an
active account (activebool = true).

Sort the names alphabetically.

Table reference:
dvdrental.customer(first_name, activebool)
----------------------------------------------------------------*/

SELECT DISTINCT first_name
FROM dvdrental.customer
WHERE activebool
ORDER BY first_name;

/*---------------------------------------------------------------
Notes:

- Remember:
	DISTINCT applies to the entire row. If you select more than one column,
    it will return distinct combinations of those columns.

Example:
	SELECT DISTINCT first_name, last_name ...
will only remove exact duplicates of both first and last name together.

Always choose DISTINCT only when duplicates are expected and meaningful.
----------------------------------------------------------------*/

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-B001: Bonus Query: DISTINCT ON with Full Row
Retrieve only one row per unique first_name from the customer table,
but include all other customer details in the result.

Keep only the first matching record (based on customer_id),
and filter for only active customers.

Sort the result by first_name for readability.

Table reference:
dvdrental.customer(first_name, last_name, email, customer_id, activebool)
----------------------------------------------------------------*/

SELECT DISTINCT ON (first_name)
       first_name, last_name, email, activebool
FROM dvdrental.customer
WHERE activebool
ORDER BY first_name, customer_id;

/*---------------------------------------------------------------
Notes:

- DISTINCT ON (column) is a PostgreSQL-specific feature that
	allows you to return only the first row for each unique value
	in that column — based on ORDER BY.

- ORDER BY determines which row "wins" for each group.
	In this example, the row with the smallest customer_id per first_name is kept.

- Be careful when selecting other columns:
	The non-DISTINCT columns come from whichever row PostgreSQL selects.

- This technique is great for "first per group" problems,
	but for full portability across SQL dialects, consider using
	ROW_NUMBER() with a window function — which we’ll cover later.
----------------------------------------------------------------*/

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-004 (LIMIT)
Retrieve the first 10 customers from the customer table.
Show first name, last name, email, and active status.

Sort them alphabetically by last name, then first name.

Table reference:
dvdrental.customer(first_name, last_name, email, activebool)
----------------------------------------------------------------*/

SELECT first_name, last_name, email, activebool
FROM dvdrental.customer
ORDER BY last_name, first_name
LIMIT 10;

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-005: Aliasing Columns
Show the full name (first_name + last_name) of all customers,
and alias it as "customer_name".

Also include their email, and show their active status as "is_active".

Sort by customer_name alphabetically.

Table reference:
dvdrental.customer(first_name, last_name, email, activebool)
----------------------------------------------------------------*/

SELECT 
	concat(first_name, ' ', last_name) AS customer_name,
	email,
	activebool AS is_active
FROM dvdrental.customer
ORDER BY customer_name;

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-006: Basic Aggregation with COUNT
Count how many customers are currently active (activebool = true).

Return a single column and alias it as "active_customer_count".

Table reference:
dvdrental.customer(activebool)
----------------------------------------------------------------*/

SELECT count(*) AS active_customer_count
FROM dvdrental.customer
WHERE activebool;

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-007: Grouping & HAVING
From the rental table, list each customer_id and count how many times
that customer has rented.

Return these columns:
    • customer_id
    • rental_count – total rentals for each customer_id

Show only customers who have rented more than 30 times.

Sort the results by rental_count in descending order and, in case of
tie, by customer_id ascending.

Table reference:
dvdrental.rental(rental_id, rental_date, inventory_id, customer_id)
----------------------------------------------------------------*/


SELECT customer_id, count(*) AS rental_count
FROM dvdrental.rental
GROUP BY customer_id
HAVING count(*) > 30
ORDER BY rental_count DESC, customer_id;

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-008: Using IN and ORDER BY
From the payment table, list all payments made by staff members 
with staff_id values 1 or 2.

Return these columns:
    • payment_id
    • staff_id
    • amount
    • payment_date

Sort the results by payment_date in descending order.

Table reference:
dvdrental.payment(payment_id, customer_id, staff_id, rental_id, amount, payment_date)
----------------------------------------------------------------*/

SELECT payment_id, staff_id, amount, payment_date
FROM dvdrental.payment
WHERE staff_id IN (1, 2)
ORDER BY payment_date DESC;

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-009: Using BETWEEN and ORDER BY
From the payment table, list all payments where the amount is 
between 5 and 7 (inclusive).

Return these columns:
    • payment_id
    • customer_id
    • amount
    • payment_date

Sort the results by amount in ascending order and, for payments 
with the same amount, sort by payment_date descending.

Table reference:
dvdrental.payment(payment_id, customer_id, staff_id, rental_id, amount, payment_date)
----------------------------------------------------------------*/

SELECT payment_id, customer_id, amount, payment_date
FROM dvdrental.payment
WHERE amount between 5 AND 7
ORDER BY amount, payment_date DESC;

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-010: Handling NULL values
From the customer table, list all customers who do not have an 
email address (i.e., where email is NULL).

Return these columns:
    • customer_id
    • first_name
    • last_name
    • email

Sort the results by last_name ascending, then first_name ascending.

Table reference:
dvdrental.customer(customer_id, store_id, first_name, last_name, email, address_id, active, create_date, last_update)
----------------------------------------------------------------*/

SELECT customer_Id, first_name, last_name, email
FROM dvdrental.customer
WHERE email IS NULL
ORDER BY last_name, first_name;

-- 0 results returned

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-011: Handling NULL values
From the address table, list all addresses where address2 is NULL.

Return these columns:
    • address_id
    • address
    • address2
    • district
    • postal_code

Sort the results by district ascending, then address ascending.

Table reference:
dvdrental.address(address_id, address, address2, district, city_id, postal_code, phone, last_update)
----------------------------------------------------------------*/

SELECT address_id, address, address2, district, city_id, postal_code
FROM dvdrental.address
WHERE address2 IS NULL
ORDER BY district, address;

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-012: Using arithmetic in SELECT
From the payment table, list each payment_id and amount, along with 
a new column showing the amount increased by 10 percent.

Return these columns:
    • payment_id
    • amount
    • amount_with_increase – amount + (amount * 0.10)

Sort the results by amount_with_increase in descending order.

Table reference:
dvdrental.payment(payment_id, customer_id, staff_id, rental_id, amount, payment_date)
----------------------------------------------------------------*/

SELECT 
	payment_id, 
	amount, 
	amount + (amount * 0.10) AS amount_with_increase
FROM dvdrental.payment
ORDER BY amount_with_increase DESC;

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-013: Using ROUND with arithmetic
From the payment table, list each payment_id and amount, along with 
a new column showing the amount increased by 18 percent and rounded 
to 2 decimal places.

Return these columns:
    • payment_id
    • amount
    • amount_with_tax – amount increased by 18 percent and rounded

Sort the results by amount_with_tax in descending order.

Table reference:
dvdrental.payment(payment_id, customer_id, staff_id, rental_id, amount, payment_date)
----------------------------------------------------------------*/

SELECT
	payment_id,
	amount,
	round(amount + (amount * 0.18), 2) AS amount_with_tax
FROM dvdrental.payment
ORDER BY amount_with_tax DESC;

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-014: Using ORDER BY with multiple columns and directions
From the customer table, list all customers and sort the results 
by active status in descending order, then by last_name in ascending 
order, and finally by first_name in ascending order.

Return these columns:
    • customer_id
    • first_name
    • last_name
    • active

Table reference:
dvdrental.customer(customer_id, store_id, first_name, last_name, email, address_id, active, create_date, last_update)
----------------------------------------------------------------*/

SELECT
	customer_id,
	first_name,
	last_name,
	active
FROM dvdrental.customer
ORDER BY 
	active DESC,
	last_name, first_name;

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-015: Using LIMIT
From the film table, list the first 7 films based on their title 
in alphabetical order.

Return these columns:
    • film_id
    • title
    • release_year
    • rental_rate

Table reference:
dvdrental.film(film_id, title, description, release_year, language_id, 
original_language_id, rental_duration, rental_rate, length, replacement_cost, 
rating, last_update, special_features, fulltext)
----------------------------------------------------------------*/

SELECT film_id, title, release_year, rental_rate
FROM dvdrental.film
ORDER BY title
LIMIT 7;

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-016: Using DISTINCT
From the film table, list all unique rental durations available.

Return these columns:
    • rental_duration

Sort the results in ascending order.

Table reference:
dvdrental.film(film_id, title, description, release_year, language_id, 
original_language_id, rental_duration, rental_rate, length, replacement_cost, 
rating, last_update, special_features, fulltext)
----------------------------------------------------------------*/

SELECT DISTINCT(rental_duration)
FROM dvdrental.film
ORDER BY rental_duration;

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-017: Using DISTINCT ON
From the customer table, retrieve only the first customer record 
for each unique first_name, based on the lowest customer_id.

Return these columns:
    • first_name
    • customer_id
    • last_name
    • email

Sort the results by first_name ascending, then customer_id ascending.

Table reference:
dvdrental.customer(customer_id, store_id, first_name, last_name, email, 
address_id, active, create_date, last_update)
----------------------------------------------------------------*/

SELECT
	DISTINCT ON (first_name)
	first_name,
	customer_id,
	last_name,
	email
FROM dvdrental.customer
ORDER BY first_name, customer_id;

/*---------------------------------------------------------------
NOTE:
DISTINCT ON is a PostgreSQL-specific feature used to return the first row
for each unique value of one or more columns.

Syntax:
    SELECT DISTINCT ON (column_name) col1, col2, ...
    FROM table
    ORDER BY column_name, another_column;

There is no comma after DISTINCT ON (column_name) because it is part of the
SELECT clause itself, not a separate column.

Other SQL dialects (like MySQL, SQL Server, Oracle) do not support DISTINCT ON.
Instead, they achieve similar results using:
    • ROW_NUMBER() window function inside a CTE or subquery
    • GROUP BY with MIN/MAX and a join back to the table
---------------------------------------------------------------*/

SELECT version();

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-018: GROUP BY with multiple columns
From the payment table, group the data by staff_id and customer_id 
and find the total amount paid by each customer for each staff member.

Return these columns:
    • staff_id
    • customer_id
    • total_amount – sum of amount for each staff-customer combination

Sort the results by staff_id ascending, then total_amount descending.

Table reference:
dvdrental.payment(payment_id, customer_id, staff_id, rental_id, amount, payment_date)
----------------------------------------------------------------*/

SELECT staff_id, customer_id, SUM(amount) AS total_amount
FROM dvdrental.payment
GROUP BY staff_id, customer_id
ORDER BY staff_id, total_amount DESC;

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-019: Using aggregate functions (AVG, MIN, MAX)
From the payment table, find the minimum, maximum, and average payment 
amounts for each staff member.

Return these columns:
    • staff_id
    • min_amount – minimum payment amount
    • max_amount – maximum payment amount
    • avg_amount – average payment amount

Sort the results by staff_id ascending.

Table reference:
dvdrental.payment(payment_id, customer_id, staff_id, rental_id, amount, payment_date)
----------------------------------------------------------------*/

SELECT
	staff_id,
	MIN(amount) AS min_amount,
	MAX(amount) AS max_amount,
	ROUND(AVG(amount), 2) AS avg_amount
FROM dvdrental.payment
GROUP BY staff_id
ORDER BY staff_id;

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-020: Using HAVING with multiple conditions
From the payment table, find each customer’s total payment amount 
and total number of payments. Show only those customers who have 
made more than 10 payments and whose total payment amount exceeds 100.

Return these columns:
    • customer_id
    • total_amount – sum of amount
    • total_payments – count of payments

Sort the results by total_amount in descending order.

Table reference:
dvdrental.payment(payment_id, customer_id, staff_id, rental_id, amount, payment_date)
----------------------------------------------------------------*/

SELECT
	customer_id,
	SUM(amount) AS total_amount,
	COUNT(*) AS total_payments
FROM dvdrental.payment
GROUP BY customer_id
HAVING 
	COUNT(*) > 10
	AND SUM(amount) > 100
ORDER BY total_amount DESC;

/* ================================================= NEXT QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-021: Creating and querying a VIEW
Create a view named high_value_customers that shows each customer_id 
and the total amount they have paid across all rentals. Then, query 
the view to return only those customers who have paid more than 150.

For the final result, return:
    • customer_id
    • total_amount

Sort the results by total_amount in descending order.

Table reference:
dvdrental.payment(payment_id, customer_id, staff_id, rental_id, amount, payment_date)
----------------------------------------------------------------*/

CREATE OR REPLACE VIEW dvdrental.high_value_customers AS
SELECT
	customer_id,
	SUM(amount) AS total_amount
FROM dvdrental.payment
GROUP BY customer_id;

SELECT customer_id, total_amount
FROM dvdrental.high_value_customers
WHERE total_amount > 150
ORDER BY total_amount DESC;

/* ================================================= FINAL QUERY ================================================= */

/*---------------------------------------------------------------
DVDR-P1-FINAL: Combining multiple SQL concepts
From the payment table, analyze payments processed by staff members 1 
and 2, where payment amounts are between 5 and 10 (inclusive).

Return the following:
    • staff_id
    • customer_id
    • payment_count: number of payments made by each customer for each staff member
    • total_amount: total payment amount
    • avg_amount_rounded: average payment amount rounded to 2 decimals

Only include results where payment_count is greater than 5 and total_amount is greater than 40.

Sort the results by total_amount in descending order, then by customer_id.
Limit the output to the top 10 rows.

Table reference:
dvdrental.payment(payment_id, customer_id, staff_id, rental_id, amount, payment_date)
----------------------------------------------------------------*/

SELECT 
	staff_id,
	customer_id,
	COUNT(*) AS payment_count,
	SUM(amount) AS total_amount,
	ROUND(AVG(amount), 2) AS avg_amount_rounded
FROM dvdrental.payment
WHERE 
	staff_id IN (1, 2)
	AND amount BETWEEN 5 AND 10
GROUP BY staff_id, customer_id
HAVING 
	COUNT(*) > 5
	AND SUM(amount) > 40
ORDER BY 
	total_amount DESC,
	customer_id
LIMIT 10;