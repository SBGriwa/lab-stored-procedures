use sakila;

drop procedure if exists customer_action_movies;
drop procedure if exists customer_category_movies;
drop procedure if exists number_of_each_category;

-- Write queries, stored procedures to answer the following questions:
-- In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. Convert the query into a simple stored procedure. Use the following query:
DELIMITER //
create procedure customer_action_movies()
begin
select first_name, last_name, email from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = "Action"
group by first_name, last_name, email;
end //
DELIMITER ;

call customer_action_movies();


-- Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.
DELIMITER //
create procedure customer_category_movies(in _category char(100))
begin
select first_name, last_name, email from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = _category
group by first_name, last_name, email;
end //
DELIMITER ;

call customer_category_movies('animation');

-- Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.
DELIMITER //
create procedure number_of_each_category(in n int)
begin
select c.name, count(f.film_id) as total_number from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
group by c.name
having count(f.film_id) > n;
end //
DELIMITER ;

call number_of_each_category(30);