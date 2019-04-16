Use sakila;

/*1a. Display the first and last names of all actors from the
table actor.*/

select first_name, last_name
from actor;

/*1b. Display the first and last name of each actor 
in a single column in upper case letters. 
Name the column Actor Name.*/

select concat(upper(first_name)," ",upper(last_name)) as Actor_Name
from actor;

/*2a. You need to find the ID number, first name, and last name of an actor,
 of whom you know only the first name, "Joe."*/
 
 select actor_id,first_name,last_name 
 from actor
 where first_name = 'Joe';
 
 /*2b. Find all actors whose last name contain the letters GEN*/
 
 SELECT last_name 
 FROM actor 
 WHERE last_name like '%gen%';
 
 /* 2c. Find all actors whose last names contain the letters LI. 
 This time, order the rows by last name and first name, in that order*/

select last_name, first_name
from actor
where last_name like '%LI%'
order by last_name, first_name;

/*2d. Using IN, display the country_id and country columns of the following countries:
 Afghanistan, Bangladesh, and China:*/
 
SELECT country_id,country
FROM country 
WHERE country 
IN ('Afghanistan', 'Bangladesh', 'China');
 
 /*3a. You want to keep a description of each actor. 
 You don't think you will be performing queries on a description, 
 so create a column in the table actor named description and use the data type BLOB*/
 
ALTER TABLE actor 
ADD COLUMN description BLOB ;

select * from actor;
 
 /*3b. Delete the description column*/
 
 ALTER TABLE actor 
 DROP description;
 
 select * from actor;
 
 /* 4a. List the last names of actors, as well as how many actors have that last name*/
 
 SELECT last_name, COUNT(*) as num_actors
 FROM actor 
 GROUP BY last_name;
 
 /* 4b. List last names of actors and the number of actors who have that last name, 
 but only for names that are shared by at least two actors*/
 
 SELECT last_name, COUNT(*) as num_actors
 FROM actor 
 GROUP BY last_name 
 HAVING count(*) > 1;
 
/*4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
 Write a query to fix the record*/
 
UPDATE actor 
SET first_name = 'HARPO', last_name = 'WILLIAMS' 
WHERE last_name = 'WILLIAMS' and first_name = 'GROUCHO';

select * from actor where last_name = 'WILLIAMS' and first_name = 'GROUCHO';
 
/*4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
It turns out that GROUCHO was the correct name after all! 
In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO*/

SET SQL_SAFE_UPDATES=0; 
UPDATE actor 
SET first_name = 'GROUCHO' 
WHERE first_name = 'HARPO';

select * from actor 
where first_name = 'GROUCHO';
SET SQL_SAFE_UPDATES=1;

/*5a. You cannot locate the schema of the address table. Which query would you use to re-create it?*/

SHOW CREATE Table address;

/*6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
Use the tables staff and address*/

SELECT staff.first_name, staff.last_name, address.address
FROM staff 
join address on staff.address_id = address.address_id;

/* 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005.
 Use tables staff and payment*/
 
SELECT staff.first_name, staff.last_name,sum(payment.amount) as 'Total for August 2005 '
FROM staff 
join payment on staff.staff_id = payment.staff_id and
 payment.payment_date>='2005-08-01' and
 payment.payment_date<='2005-08-31'
group by staff.staff_id;


/*6c. List each film and the number of actors who are listed for that film. 
Use tables film_actor and film. Use inner join*/

SELECT film.title, count(*) as "Number of Actors"
FROM film 
inner join film_actor 
on film.film_id = film_actor.film_id
GROUP BY film.title;

/*6d. How many copies of the film Hunchback Impossible exist in the inventory system?*/

/*Solution-1*/
Select count(*) as 'Total Copies' 
from inventory 
where film_id in
(
SELECT film_id 
from film 
where title = 'Hunchback Impossible'
);

/*Solution-2*/
SELECT film.title, count(*) as "Number of Copies"
FROM film 
inner join inventory 
on film.film_id = inventory.film_id
where film.title = 'Hunchback Impossible';

/*6e. Using the tables payment and customer and the JOIN command, 
list the total paid by each customer*/

SELECT customer.first_name,customer.last_name, sum(amount) as "Total Amount Paid"
FROM customer 
join payment on customer.customer_id = payment.customer_id 
GROUP BY customer.customer_id;

/*7a. Use subqueries to display the titles of movies starting with 
the letters K and Q whose language is English.*/

Select title 
from film 
where language_id IN
(
SELECT language_id 
from language 
where name = 'English'
)
AND (title LIKE 'K%' or title like 'Q%');

/*7b. Use subqueries to display all actors who appear 
in the film Alone Trip.*/

Select first_name,last_name 
from actor 
where actor_id IN
(
Select actor_id 
from film_actor 
where film_id IN
(
Select film_id 
from film 
where title = 'Alone Trip'
));

/*7c. You want to run an email marketing campaign in Canada, 
for which you will need the names and email addresses of all Canadian customers. 
Use joins to retrieve this information.*/

SELECT first_name,last_name, email, country.country
from customer
join address on address.address_id = customer.address_id
join city on address.city_id=city.city_id
join country on city.country_id = country.country_id
WHERE country = 'Canada';

/*7d. Sales have been lagging among young families, and you wish to target all family movies 
for a promotion. Identify all movies categorized as family films.*/

select title, category.name 
from film
join film_category on film.film_id = film_category.film_id
join category on category.category_id = film_category.category_id
where name = 'Family';

 /*7e. Display the most frequently rented movies in descending order.*/
 
select title, count(*) as Frequency 
from film
join inventory on inventory.film_id = film.film_id
join rental on rental.inventory_id = inventory.inventory_id
GROUP BY film.film_id
ORDER BY Frequency desc ;

/*7f. Write a query to display how much business, in dollars, each store brought in.*/

select  staff.store_id, sum(amount) as "Total Business($)" 
from payment 
join staff on staff.staff_id = payment.staff_id
GROUP BY staff.store_id;

/*7g. Write a query to display for each store its store ID, city, and country.*/

SELECT store_id,city.city,country.country
from store
join address on address.address_id = store.address_id
join city on address.city_id=city.city_id
join country on city.country_id = country.country_id;

/*7h. List the top five genres in gross revenue in descending order. 
(Hint: you may need to use the following tables: category, film_category, 
inventory, payment, and rental.)*/

select category.name as 'Top 5 Genres', sum(payment.amount) as 'Gross_Revenue'
from category
join film_category on category.category_id = film_category.category_id
join inventory on inventory.film_id = film_category.film_id
join rental on inventory.inventory_id = rental.inventory_id
join payment on payment.rental_id = rental.rental_id
GROUP BY category.name 
ORDER BY Gross_Revenue desc 
LIMIT 5;


/*8a. In your new role as an executive, you would like to have an easy way of viewing the 
Top five genres by gross revenue. Use the solution from the problem above to create a view. 
If you haven't solved 7h, you can substitute another query to create a view.*/


create view  top_five_genres as 
select category.name as 'Top_five', sum(payment.amount) as 'Gross_Revenue'
from category
join film_category on category.category_id = film_category.category_id
join inventory on inventory.film_id = film_category.film_id
join rental on inventory.inventory_id = rental.inventory_id
join payment on payment.rental_id = rental.rental_id
GROUP BY category.name 
ORDER BY Gross_Revenue desc 
LIMIT 5;

/*How would you display the view that you created in 8a?*/

select * from top_five_genres;

/*You find that you no longer need the view top_five_genres. Write a query to delete it*/

DROP view top_five_geners;


