--1. top 5 films with the biggest cast
Select fa.film_id, f.title, count(* /* distinct fa.actor_id */) as actors
From film_actor as fa
inner join film as f on fa.film_id = f.film_id
group by fa.film_id, f.title
order by count(*) desc
limit 5;


--2. top 5 actors with the most number of movies they acted in
select fa.actor_id, a.first_name, a.last_name, count(* /* distinct fa.film_id */) as films
from film_actor as fa
inner join actor as a on fa.actor_id = a.actor_id
group by fa.actor_id, a.first_name, a.last_name
order by count(*) Desc
limit 5;

--3. check if there's any film that has no copy available in the inventory. How many of them are there?
select f.film_id, f.title, count(i.inventory_id)
from film as f
left join inventory as i
on f.film_id = i.film_id
group by f.film_id, f.title
having count(i.inventory_id) = 0
--order by count(*) asc;

--4. top 5 film that have been rented most number of times
select i.film_id, f.title, count(*) as rentals
from rental as r
inner join inventory as i on r.inventory_id = i.inventory_id
inner join film as f on i.film_id = f.film_id
group by i.film_id, f.title
order by count(*) desc
limit 5;

--5.  list the films that are in the inventory but haven't rented out yet.
select f.film_id, f.title
from film as f
inner join inventory as i on i.film_id = f.film_id
left join rental as r on r.inventory_id = i.inventory_id
where r.rental_id is null


--6.  list top three film that has been rented for the longest time in total by all the customers
select f.film_id, f.title, sum(date_part('hour', return_date - rental_date)) as total_hours
from film as f
inner join inventory as i on i.film_id = f.film_id
inner join rental as r on r.inventory_id = i.inventory_id
group by f.film_id, f.title
order by total_hours desc
limit 3

-- 7. list the film categories and the average rental time in days
select c.category_id, c.name, avg(date_part('day', return_date - rental_date)) as avg_days
from film as f
inner join film_category as fc on fc.film_id = f.film_id
inner join category as c on c.category_id = fc.category_id
inner join inventory as i on i.film_id = f.film_id
inner join rental as r on r.inventory_id = i.inventory_id
group by c.category_id, c.name
order by avg_days




-- 8. compare the average rental period and average rental payment amount 
-- for top 10 longest movies vs top 10 shortest movies
select 
	case 
		when fs.film_id is not null then 'short' 
		when fl.film_id is not null then 'long' 
	end as movie_length_catergory
	, avg(date_part('hour', r.return_date - r.rental_date)) as avg_rental_period_hours
	, avg(p.amount) as average_rental_amount
from rental as r 
inner join payment as p on p.rental_id = r.rental_id
inner join inventory as i on r.inventory_id = i.inventory_id
left join	(
	select  *
	from film
	order by length desc
	limit 10
) as fl on fl.film_id = i.film_id
left join	(
	select  *
	from film
	order by length asc
	limit 10
) as fs on fs.film_id = i.film_id
where fl.film_id IS NOT NULL OR fs.film_id IS NOT NULL
group by movie_length_catergory

-- 9.Find the customers that have possibly damaged the inventory:

Select
	  ir.inventory_id
	, ir.rental_id
	, ir.rental_date
	, ir.rental_time
	, avg_i.avg_rental_time
	, prev_r.rental_id as prev_rental_id
	, prev_r.rental_date as prev_rental_date
	, prev_cu.customer_id as prev_customer_id
	, prev_cu.first_name as prev_customer_name
	, prev_cu.last_name as prev_customer_last_name
FROM (
	SELECT *
	FROM
		(
		select 
			  i.inventory_id
			, r.rental_id
			, r.rental_date
			, date_part('hour', r.return_date - r.rental_date) as rental_time
			, row_number() OVER (partition by i.inventory_id order by date_part('hour', r.return_date - r.rental_date) asc) as _rental_time_rank
			, lag(r.rental_id) over(partition by i.inventory_id order by r.rental_date asc) as _prev_rental_id
		from rental as r
			inner join inventory as i on r.inventory_id = i.inventory_id
			inner join film as f on f.film_id = i.film_id
	) as ir
	where ir._rental_time_rank = 1
) AS ir
	inner join rental as prev_r on prev_r.rental_id = ir._prev_rental_id
	inner join customer as prev_cu on prev_cu.customer_id = prev_r.customer_id
	inner join 
	(select 
	 	  r.inventory_id
	 	, avg(date_part('hour', r.return_date - r.rental_date)) as avg_rental_time
	from rental as r
	group by r.inventory_id
	having count(*) > 4
	) as avg_i on avg_i.inventory_id = ir.inventory_id
where
	ir.rental_time / avg_i.avg_rental_time < 0.2
	

