select * from customer;

--1.what is the total revenue generatedby male and female
select gender,sum(purchase_amount) from customer group by gender;

--2.which customers used a discount but still spend more than avg purchase_amount
select customer_id,purchase_amount from customer where discount_applied='Yes' and purchase_amount>=(select avg(purchase_amount) from customer);

--3.which are top 5 products with highest avg review rating
select item_purchased,round(avg(review_rating)::numeric,2) from customer group by item_purchased order by avg(review_rating) desc limit 5;

--4.compare average purchase amount between standard and express shipping
select shipping_type,round(avg(purchase_amount),2) from Customer where shipping_type in ('Express','Standard') group by shipping_type;

--5.do subscribed customers spend more?compare average spent and total revenue between subscribers and non-subscribers
select subscription_status,count(customer_id),round(avg(purchase_amount),2) as avg_spend,sum(purchase_amount) as total_revenue from Customer group by subscription_status order by total_revenue,avg_spend desc;

--6.which 5 products have highest percentage of purchases with discount_applied
select item_purchased,
ROUND(100*SUM (
	CASE 
		WHEN discount_applied='Yes' THEN 1 
		ELSE 0 
	END	
	)/COUNT(*),2) as discount_percentage
	from Customer group by item_purchased order by discount_percentage desc limit 5 ;

--7.segment customers into new,returning and loyal based on prev_purchases and show the count of each segment
select 
	CASE
		WHEN previous_purchases=1 THEN 'New'
		WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
		ELSE 'Loyal'
	END as customer_segment,count(*)
	from Customer group by customer_segment;

--8.what are the top 3 most purchased product within each category	
with item_counts as (
select category,item_purchased,count(customer_id) as total_order,ROW_NUMBER() over(
partition by category
order by count(customer_id) desc
) as item_rank
from Customer group by category,item_purchased)

select category,item_purchased,total_order from item_counts where item_rank<=3;


--9.are customers who are repeat buyers (more than 5 purchase) also likely to subscribe
select subscription_status,count(customer_id) as repeat_buyers from Customer where previous_purchases>5 group by subscription_status;

--10.what is the revenue contribution of each group
select age_group,sum(purchase_amount) as total_revenue from Customer group by age_group order by total_revenue desc;





