create database db;
use db;
-- 1. Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
select if(weekday(order_purchase_timestamp)<5,"Weekday","Weekend") days , sum(payment_value) from olist_orders_dataset
inner join
olist_order_payments_dataset
using(order_id)
group by days;

-- 2. Number of Orders with review score 5 and payment type as credit card.
select count(p.order_id), p.payment_type, r.review_score
from olist_order_payments_dataset as p inner join olist_order_reviews_dataset as r
on p.order_id = r.order_id
and p.payment_type = 'credit_card' and r.review_score = 5 ;

-- 3. Average number of days taken for order_delivered_customer_date for pet_shop

with t1 as(
select order_purchase_timestamp,order_delivered_customer_date,product_id from olist_orders_dataset
inner join
olist_order_items_dataset
using(order_id)
)
select avg(datediff(order_delivered_customer_date,order_purchase_timestamp)) from t1
inner join olist_products_dataset
using(product_id)
where product_category_name = 'pet_shop';

-- 4. Average price and payment values from customers of sao paulo city
with t3 as(
with t2 as ( 
select order_id, customer_city from olist_customers_dataset 
 join
olist_orders_dataset
using (customer_id)
)
select order_id ,customer_city, price from t2 
join 
olist_order_items_dataset 
using (order_id)
)
select avg(price), avg(payment_value) from t3 join olist_order_payments_dataset using (order_id)
where customer_city = 'sao paulo';

-- 5. Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.
select o.order_id, r.review_score , avg(datediff(o.order_delivered_customer_date, o.order_purchase_timestamp)) Shipping_days
from olist_orders_dataset as o inner join olist_order_reviews_dataset as r
on o.order_id = r.order_id;

