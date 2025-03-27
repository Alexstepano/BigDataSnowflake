select * from mock_data order by source,id;
select count(*) from mock_data; --10000



SELECT source,id, COUNT(*) FROM mock_data GROUP BY id,source HAVING COUNT(*) > 1 order by source,id; --all records are unique for it's PK (sourse(№ of table)+id)

SELECT DISTINCT customer_country  FROM mock_data; --204 countries
SELECT  customer_pet_type FROM mock_data group by customer_pet_type ;--3 pet type


--очевидно, что таблицей фактов будет таблица, содержащая всю информацию о продажах
--Таблицей измерений будут информация о клиентах, поставщиках, продавцах, магазинах,продуктах - первичные
--остальные будут появляться по мере разбора первичных - переход от звезды к снежинке
select sale_customer_id ,sale_date,sale_product_id ,sale_quantity ,sale_seller_id ,sale_total_price  from mock_data where 1=0;--занесем в DDL

select source, id,sale_customer_id    from mock_data where id  != sale_customer_id; --0=> sale_customer_id=customer_id

select seller_email ,supplier_email ,customer_email ,store_email    from mock_data where seller_email !=store_email;-- !=0 suplier,store and seller - differnet in most times

select seller_email,count(*)  from mock_data group by seller_email having count(*) >1;--нет повторяющихся продавцов
select supplier_email,count(*)  from mock_data group by supplier_email having count(*) >1;--нет повторяющихся поставщиков
select store_email,count(*)  from mock_data group by store_email having count(*) >1;--нет повторяющихся магазинов


SELECT DISTINCT store_country  FROM mock_data; --200 countries

SELECT DISTINCT seller_country   FROM mock_data; --206 countries


SELECT DISTINCT supplier_country   FROM mock_data; --201 countries
select distinct store_city from mock_data;
select distinct supplier_city from mock_data;
with  t1 as (select distinct store_city from mock_data order by store_city), t2 as (select distinct supplier_city from mock_data order by supplier_city),
t3 as (select count(*) from t1), t4 as (select count(*) from t2)
select (select * from t3)>(select * from t4) -- стран больше в магазинах 

with  t1 as (select distinct store_city from mock_data order by store_city), t2 as (select distinct supplier_city from mock_data order by supplier_city)
select count(supplier_city) from t2 where supplier_city not in (select * from t1) --5,954 надо объединять
select distinct product_brand from mock_data; --383 - можно выделить отдельно
select distinct product_material  from mock_data; // --11 тем более


SELECT  customer_pet_breed,count(*) FROM mock_data group by customer_pet_breed ; --3 породы - можно вынести
select distinct product_color from mock_data; -- 19 цветов

select distinct pet_category from mock_data; -- 4 категории

select distinct  product_category from mock_data;-- 3 категории

select distinct  product_reviews  from mock_data;--хз, не логично дробить, даже, если их не так уж и много (1001)

with t1 as (select distinct supplier_contact from mock_data)
select  count(supplier_contact) from t1;//--не повторяются

SELECT DISTINCT store_country   FROM mock_data where store_country not in (SELECT DISTINCT seller_country   FROM mock_data) ; 
SELECT DISTINCT customer_country   FROM mock_data where customer_country not in (SELECT DISTINCT seller_country   FROM mock_data) ; 
SELECT DISTINCT supplier_country  FROM mock_data where customer_country not in (SELECT DISTINCT seller_country   FROM mock_data) ; 
select count(*)from dm_pet group by pet_name 
SELECT count(seller_id) FROM dm_sellers group by seller_email having count(seller_id)>1
SELECT product_name,count(product_name) FROM dm_products group by product_name having count(product_name)>1

select distinct  sale_date from mock_data union (select distinct product_release_date from mock_data union select product_expiry_date from mock_data);
select distinct  sale_date as data from mock_data union (select distinct product_release_date as data from mock_data union select product_expiry_date as data from mock_data)--объединение всех дат


SELECT-- вспомогательная вещь при заполнении sales  из mock даты возникшая
    dp.product_id
FROM
    dm_products dp
JOIN
    mock_data md
ON
    dp.product_name = md.product_name
    AND dp.product_category_id = (SELECT product_category_id FROM dm_product_category WHERE product_category_name = md.product_category)
    AND dp.product_price = md.product_price
    AND dp.product_quantity = md.product_quantity
    AND dp.pet_category_id = (SELECT pet_category_id FROM dm_pet_category WHERE pet_category_name = md.pet_category)
    AND dp.product_weight = md.product_weight
    AND dp.product_color_id = (SELECT product_color_id FROM dm_product_color WHERE product_color_name = md.product_color)
    AND dp.product_size = md.product_size
    AND dp.product_brand_id = (SELECT product_brand_id FROM dm_product_brand WHERE product_brand_name = md.product_brand)
    AND dp.product_material_id = (SELECT product_material_id FROM dm_product_material WHERE product_material_name = md.product_material)
    AND dp.product_description = md.product_description
    AND dp.product_rating = md.product_rating
    AND dp.product_reviews = md.product_reviews;
   -- AND dp.product_release_date_id = (SELECT DateID FROM d_time WHERE Date = md.product_release_date)
   -- AND dp.product_expiry_date_id = (SELECT DateID FROM d_time WHERE Date = md.product_expiry_date);



-- проверим на null значения после dml
SELECT *
FROM d_time
WHERE Date IS NULL
    OR DayID IS NULL
    OR MonthID IS NULL
    OR Year IS NULL;


SELECT *
FROM dm_pet_category
WHERE pet_category_name IS NULL;


SELECT *
FROM dm_product_material
WHERE product_material_name IS NULL;


SELECT *
FROM dm_product_brand
WHERE product_brand_name IS NULL;


SELECT *
FROM dm_product_category
WHERE product_category_name IS NULL;


SELECT *
FROM dm_product_color
WHERE product_color_name IS NULL;


SELECT *
FROM dm_country
WHERE country_name IS NULL;


SELECT *
FROM dm_city
WHERE city_name IS NULL;


SELECT *
FROM dm_kind
WHERE kind_name IS NULL;


SELECT *
FROM dm_breed
WHERE breed_name IS NULL;


SELECT *
FROM dm_pet
WHERE type_id IS NULL
    OR breed_id IS NULL
    OR pet_name IS NULL;


SELECT *
FROM dm_customer
WHERE customer_first_name IS NULL
    OR customer_last_name IS NULL
    OR customer_age IS NULL
    OR customer_email IS NULL
    OR customer_country_id IS NULL
    OR customer_postal_code IS NULL
    OR customer_pet_id IS NULL;



SELECT *
FROM dm_sellers
WHERE seller_first_name IS NULL
    OR seller_last_name IS NULL
    OR seller_email IS NULL
    OR seller_country_id IS NULL
    OR seller_postal_code IS NULL;


SELECT *
FROM dm_products
WHERE product_name IS NULL
    OR product_category_id IS NULL
    OR product_price IS NULL
    OR product_quantity IS NULL
    OR pet_category_id IS NULL
    OR product_weight IS NULL
    OR product_color_id IS NULL
    OR product_size IS NULL
    OR product_brand_id IS NULL
    OR product_material_id IS NULL
    OR product_description IS NULL
    OR product_rating IS NULL
    OR product_reviews IS NULL
    OR product_release_date_id IS NULL
    OR product_expiry_date_id IS NULL;


SELECT *
FROM dm_stores
WHERE store_location IS NULL
    OR store_city_id IS NULL
    OR store_state IS NULL
    OR store_country_id IS NULL
    OR store_phone IS NULL
    OR store_email IS NULL;


SELECT *
FROM dm_supplier
WHERE supplier_name IS NULL
    OR supplier_contact IS NULL
    OR supplier_email IS NULL
    OR supplier_phone IS NULL
    OR supplier_address IS NULL
    OR supplier_city_id IS NULL
    OR supplier_country_id IS NULL;


SELECT *
FROM sales
WHERE sale_date_id IS NULL
    OR sale_customer_id IS NULL
    OR sale_customer_source IS NULL
    OR sale_seller_id IS NULL
    OR sale_product_id IS NULL
    OR sales_store_id IS NULL
    OR sales_supplier_id IS NULL
    OR sale_quantity IS NULL
    OR sale_total_price IS NULL;


