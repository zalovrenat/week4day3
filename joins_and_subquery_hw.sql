-- 1. List all customers who live in Texas (use JOINs)

    SELECT c.customer_id, c.first_name, c.last_name, a.district
    FROM customer c
    LEFT OUTER JOIN address a ON c.address_id = a.address_id
    WHERE a.district = 'Texas';

-- 2. Get all payments above $6.99 with the Customer's Full Name

    SELECT c.first_name, c.last_name, p.payment_id, p.amount
    FROM customer c
    LEFT OUTER JOIN payment p ON c.customer_id = p.customer_id
    WHERE p.amount > 6.99;

-- 3. Show all customers names who have made payments over $175 (use subqueries)

    SELECT c.first_name, c.last_name, sub.total_payment
    FROM customer c
    INNER JOIN (
        SELECT customer_id, sum(amount) AS total_payment
        FROM payment
        GROUP BY customer_id
        HAVING sum(amount) > 175
    ) AS sub ON c.customer_id = sub.customer_id;

-- 4. List all customers that live in Nepal (use the city table)

    SELECT c.customer_id, c.first_name, c.last_name, city.city, country.country
    FROM customer c
    LEFT OUTER JOIN address a ON c.address_id = a.address_id
    LEFT OUTER JOIN city ON a.city_id = city.city_id
    LEFT OUTER JOIN country ON city.country_id = country.country_id
    WHERE country.country = 'Nepal';

-- 5. Which staff member had the most transactions? I will define transactions as both rentals and payments

    SELECT s.staff_id, s.first_name, s.last_name, sum(p.payments + r.rentals)
    FROM staff s
    LEFT OUTER JOIN (
        SELECT payment.staff_id AS staff_id, count(payment_id) AS payments
        FROM payment
        GROUP BY payment.staff_id
        ) AS p ON s.staff_id = p.staff_id
    LEFT OUTER JOIN (
        SELECT rental.staff_id AS staff_id, count(rental_id) AS rentals
        FROM rental
        GROUP BY rental.staff_id
        ) AS r ON s.staff_id = r.staff_id
    GROUP BY s.staff_id, s.first_name, s.last_name
    ORDER BY sum(p.payments + r.rentals) DESC;

-- 6. How many movies of each rating are there?

    SELECT f.rating, count(f.film_id)
    FROM film f
    GROUP BY f.rating
    ORDER BY count(f.film_id) DESC;

-- 7.Show all customers who have made a single payment above $6.99 (use subqueries)

    SELECT c.customer_id, c.first_name, c.last_name
    FROM customer c
    INNER JOIN (
        SELECT customer_id, count(payment_id)
        FROM payment
        WHERE amount > 6.00
        GROUP BY customer_id
        HAVING count(payment_id) = 1
        ) AS sub ON c.customer_id = sub.customer_id
    ORDER BY c.customer_id ASC;

-- 8. How many free rentals did our stores give away?

    SELECT count(rental_id)
    FROM payment
    WHERE amount = 0;