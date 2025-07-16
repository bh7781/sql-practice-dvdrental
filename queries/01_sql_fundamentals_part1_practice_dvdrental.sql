/*---------------------------------------------------------------
  SQL PRACTICE  –  Topic 1: Core SELECT & Basic Filtering
  Problem ID: DVDR-001

  Task:
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

/* ========================== NEXT QUERY ========================== */

/*---------------------------------------------------------------
  SQL PRACTICE  –  Topic 1: Core SELECT & Basic Filtering
  Problem ID: DVDR-002

  Task:
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
  Query Notes & Optimization Tips:

  💡 Why use single quotes with LIKE:
     - In PostgreSQL, string values (like 'A%') must be enclosed in single quotes.
     - Double quotes are reserved for *identifiers* like column or table names.
     - Using "A%" causes an error because PostgreSQL looks for a column named A%.

  🧠 CONCAT vs ||:
     - You can also concatenate strings using the `||` operator:
       Example: first_name || ' ' || last_name
     - CONCAT() is more readable and consistent across dialects.

  ✅ Aliasing best practice:
     - Use AS to rename columns in output, especially when transforming data.
----------------------------------------------------------------*/

/* ========================== NEXT QUERY ========================== */

/*---------------------------------------------------------------
  SQL PRACTICE  –  Topic 1: DISTINCT
  Problem ID: DVDR-003

  Task:
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
  Query Notes & Optimization Tips:

  ⚠️ Remember:
     DISTINCT applies to the entire row. If you select more than one column,
     it will return distinct combinations of those columns.

     Example:
       SELECT DISTINCT first_name, last_name ...
     will only remove exact duplicates of both first and last name together.

  Always choose DISTINCT only when duplicates are expected and meaningful.
----------------------------------------------------------------*/



/*---------------------------------------------------------------
  SQL PRACTICE  –  Bonus Query: DISTINCT ON with Full Row
  Problem ID: DVDR-B001

  Task:
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
  Query Notes & Optimization Tips:

  ✅ DISTINCT ON (column) is a PostgreSQL-specific feature that
     allows you to return only the first row for each unique value
     in that column — based on ORDER BY.

  ✅ ORDER BY determines which row "wins" for each group.
     In this example, the row with the smallest customer_id per first_name is kept.

  ⚠️ Be careful when selecting other columns:
     The non-DISTINCT columns come from whichever row PostgreSQL selects.

  🧠 This technique is great for "first per group" problems,
     but for full portability across SQL dialects, consider using
     ROW_NUMBER() with a window function — which we’ll cover later.
----------------------------------------------------------------*/


