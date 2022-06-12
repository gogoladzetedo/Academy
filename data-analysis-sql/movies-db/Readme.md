# Additional SQL exercise

## Step 1: Get environment ready:

### Download and install PostgreSQL 
https://www.postgresql.org/download/

### Download and install pgAdmin (or any other browser/management tool software for PostgreSQL)
https://www.pgadmin.org/download/

## Step 2: create a database

### run the following script in PostgreSQL server:
```
CREATE DATABASE DA_db;
```
### Create tables
run the attached script tables.sql content into PostgreSQL database that you just created

### Insert data into tables
run the attached script insert-data.sql content into PostgreSQL database that you just created



## Step 3: Write the SQL queries
#### Explore the datasets, try to see the relation between the tables and then do the following tasks:
1) Get top 5 films with the biggest cast - most number of actors.

2) Get top 5 actors with the most number of movies they acted in.

3) Check if there's any film that has no copy available in the inventory. How many of such films are there?

4) Get top 5 film that have been rented most number of times.

5) Get the list of the films that are in the inventory but haven't rented out yet.

6) Get top three film that have been rented for the longest time in total by all the customers

7) List all the film categories and their average rental time in days

8) Compare the average rental period and average rental payment amount for top 10 longest movies vs top 10 shortest movies

9) Find the customers that have possibly damaged the inventory:
    - find the shortest rental period for each of the film inventory. (hint: use [ROW_NUMBER()](https://www.postgresqltutorial.com/postgresql-row_number/) window function with inventory identificator as the partition and rental period as the ordering option) 
    - compare that shortest rental period to the average rental period of the given inventory, considering that the given inventory has been rented at least 5 times. From these short-rented inventories, only keep the ones that have rental period less than 20% of the average rental period of the given inventory, filter out the rest.
    - find one previous rental of those inventories (previous than the shortest rental of each inventory) and ge the customer identification - name and email, who rented it previously. (hint: use [LAG()](https://www.postgresqltutorial.com/postgresql-lag-function/) window function to take the previous rental identificator, add partition with inventory, and order the rentals by descending rental date. This way, you get the previous rental of the given inventory)



```
reference of the data:
https://github.com/devrimgunduz/pagila
```
