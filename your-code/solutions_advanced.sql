use publications;
-- Challenge 1:

-- part 1: use select 

select
ta.au_id,
ta.title_id,
(t.advance * ta.royaltyper / 100) as au_advanced ,
(t.price* s.qty*t.royalty/100*ta.royaltyper/100) as sales_royalty
from titles t
left join titleauthor ta on ta.title_id=t.title_id
left join sales s on s.title_id=t.title_id;

-- part 2. use step 1 as a subquery:
select au_id, title_id, au_advanced, sum(sales_royalty) as total_title_sales_royalty
from 
(select ta.au_id,
ta.title_id,
(t.advance * ta.royaltyper / 100) as au_advanced ,
(t.price* s.qty*t.royalty/100*ta.royaltyper/100) as sales_royalty
from titles t
left join titleauthor ta on ta.title_id=t.title_id
left join sales s on s.title_id=t.title_id)t

group by au_id, title_id, au_advanced;

-- part 3.  use step 2 write a query containg two subqueries:
select au_id, sum(total_title_sales_royalty+au_advanced) as total_au_proffit
from
(select au_id, title_id, au_advanced, sum(sales_royalty) as total_title_sales_royalty
from 
(select ta.au_id,
ta.title_id,
(t.advance * ta.royaltyper / 100) as au_advanced ,
(t.price* s.qty*t.royalty/100*ta.royaltyper/100) as sales_royalty
from titles t
left join titleauthor ta on ta.title_id=t.title_id
left join sales s on s.title_id=t.title_id)t

group by au_id, title_id, au_advanced)v

group by au_id
order by total_au_proffit DESC
limit  3;

-- Challenge 2

-- use a temporary table:
-- part 1
DROP TABLE IF EXISTS temp_2;
create temporary table temp_2
select
ta.au_id,
ta.title_id,
(t.advance * ta.royaltyper / 100) as au_advanced ,
(t.price* s.qty*t.royalty/100*ta.royaltyper/100) as sales_royalty
from titles t
left join titleauthor ta on ta.title_id=t.title_id
left join sales s on s.title_id=t.title_id; 
--
select * from temp_2;


-- part 2

select au_id, title_id, au_advanced, sum(sales_royalty) as total_title_sales_royalty
from temp_2
group by au_id, title_id, au_advanced;

-- part 3
select au_id, sum(sales_royalty+au_advanced) as total_au_proffit
from temp_2
group by au_id
order by total_au_proffit DESC
limit  3;

select au_id, sum(total_title_sales_royalty+au_advanced) as total_au_proffit
from 
(select au_id, title_id, au_advanced, sum(sales_royalty) as total_title_sales_royalty
from temp_2
group by au_id, title_id, au_advanced)t

group by au_id
order by total_au_proffit DESC
limit  3;

-- Challenge 3

-- create a permanent table named most_profiting_authors 
-- the table will have two columns, au_id and profits:


DROP TABLE IF EXISTS solutions;
CREATE TABLE solutions (au_id varchar(255), profits int, PRIMARY KEY (au_id) );

INSERT INTO solutions 
SELECT au_id,total_au_proffit 
FROM
-- sol
(select au_id, sum(total_title_sales_royalty+au_advanced) as total_au_proffit
from
-- v
(select au_id, title_id, au_advanced, sum(sales_royalty) as total_title_sales_royalty
from 

-- t
(select ta.au_id,
ta.title_id,
(t.advance * ta.royaltyper / 100) as au_advanced ,
(t.price* s.qty*t.royalty/100*ta.royaltyper/100) as sales_royalty
from titles t
left join titleauthor ta on ta.title_id=t.title_id
left join sales s on s.title_id=t.title_id)t

group by au_id, title_id, au_advanced)v

group by au_id
order by total_au_proffit DESC
limit  3)sol; 

select * from solutions;

