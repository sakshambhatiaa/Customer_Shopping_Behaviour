--Ques1. What is the total revenue genereated by male and female customers?

select gender, sum(purchase_Amount) as revenue
from customer
group by gender

--Ques.2 Which customers used a discount butstill spent more than the average purchase amount?
select customer_id, purchase_amount
from customer
where discount_applied = 'yes' and purchase_amount >= (select avg(purchase_amount) from customer)

--Ques.3 Which are the top 5 products with the highest average review rating?

select top 5 item_purchased, avg(review_rating) as Average_Product_Rating
from customer
group by item_purchased
order by avg(review_rating) desc

--Ques.4 Compare the average purchase amounts between standard and express shipping

select shipping_type, avg(purchase_amount) as avg_purchase
from customer
where shipping_type in ('Express' , 'standard')
group by shipping_type

--Ques5.) Do subscribed customer spend more? Compare average spend and total revenue between subscriber and non-subscriber.

select subscription_status, count(customer_id) as tot_customers, round(avg(purchase_amount), 2) as avg_spend, sum(purchase_amount) as tot_spend
from customer
group by subscription_status

--Ques6.) Which 5 products have the highest percentage of purchases with discount applied?

select top 5 item_purchased, 100*sum(case when discount_applied = 'yes' then 1 else 0 end)/count(*) as disc_perc
from customer
group by item_purchased
order by disc_perc desc

--Ques7.) Segment customers into new, returning, and loyal based on their total number of previous purchases and show the count of each segment.

with customer_type as (
select customer_id, previous_purchases,
case
	when previous_purchases = 1 then 'NEW'
	when previous_purchases between 2 and 10 then 'Returning'
	else 'Loyal'
	end as customer_segment
from customer
)
select customer_segment, count(*) as 'number of customers'
from customer_type 
group by customer_segment

--Ques.8) What are the top 3 most purchased products withing wach category?
 
 with category_count as (
 select category, item_purchased, count(customer_id) as total_orders,
 row_number() over(partition by category order by count(customer_id) desc) as item_rank
 from customer
 group by category, item_purchased
 )
 select item_rank, category, item_purchased, total_orders
 from category_count
 where item_rank <=3

 --Ques.9) Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?

 select subscription_status, count(customer_id) as repeat_buyers
 from customer
 where previous_purchases > 5
 group by subscription_status

 --Ques.10) What is the revenue contribution of each age group?

select age_group, sum(purchase_amount) as tot_revenue
from customer
group by age_group
order by tot_revenue desc