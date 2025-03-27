-- d_day
INSERT INTO d_day (DayID, DayName)
VALUES
(1, 'Monday'), (2, 'Tuesday'), (3, 'Wednesday'), (4, 'Thursday'),
(5, 'Friday'), (6, 'Saturday'), (7, 'Sunday');

--  d_month
INSERT INTO d_month (MonthID, MonthName)
VALUES
(1, 'January'), (2, 'February'), (3, 'March'), (4, 'April'),
(5, 'May'), (6, 'June'), (7, 'July'), (8, 'August'),
(9, 'September'), (10, 'October'), (11, 'November'), (12, 'December');

--  d_time
INSERT INTO d_time ( Date, DayID, MonthID, Year)
with t1 as (select distinct  sale_date as data from mock_data union (select distinct product_release_date as data from mock_data union select product_expiry_date as data from mock_data))
SELECT DISTINCT
    t1.data,
    EXTRACT(DOW FROM t1.data) + 1,
    EXTRACT(MONTH FROM t1.data),
    EXTRACT(YEAR FROM t1.data)
FROM t1;

INSERT INTO dm_country (country_name)
with t1 as (SELECT DISTINCT seller_country as c
FROM mock_data union (SELECT DISTINCT store_country as c
FROM mock_data union (SELECT DISTINCT customer_country as c
FROM mock_data union SELECT DISTINCT supplier_country as c
FROM mock_data)))
select distinct c from t1
WHERE c IS NOT NULL;

--  dm_city
INSERT INTO dm_city (city_name)
with t1 as (SELECT DISTINCT store_city as city
FROM mock_data),t2 as (select distinct supplier_city as city from mock_data),
t3 as (select city from t1 union select city from t2)
select distinct * from  t3
WHERE city IS NOT null;

--  dm_kind
INSERT INTO dm_kind (kind_name)
SELECT DISTINCT customer_pet_type
FROM mock_data
WHERE customer_pet_type IS NOT NULL;

--  dm_breed
INSERT INTO dm_breed (breed_name)
SELECT DISTINCT customer_pet_breed
FROM mock_data
WHERE customer_pet_breed IS NOT NULL;

--  dm_pet_category
INSERT INTO dm_pet_category (pet_category_name)
SELECT DISTINCT pet_category
FROM mock_data
WHERE pet_category IS NOT NULL;

--  dm_product_category
INSERT INTO dm_product_category (product_category_name)
SELECT DISTINCT product_category
FROM mock_data
WHERE product_category IS NOT NULL;

-- dm_product_color
INSERT INTO dm_product_color (product_color_name)
SELECT DISTINCT product_color
FROM mock_data
WHERE product_color IS NOT NULL;

--  dm_product_brand
INSERT INTO dm_product_brand (product_brand_name)
SELECT DISTINCT product_brand
FROM mock_data
WHERE product_brand IS NOT NULL;

--  dm_product_material
INSERT INTO dm_product_material (product_material_name)
SELECT DISTINCT product_material
FROM mock_data
WHERE product_material IS NOT NULL;

--  dm_pet
INSERT INTO dm_pet (type_id, breed_id, pet_name)
SELECT DISTINCT
    (SELECT kind_id FROM dm_kind WHERE kind_name = md.customer_pet_type),
    (SELECT breed_id FROM dm_breed WHERE breed_name = md.customer_pet_breed),
    md.customer_pet_name
FROM mock_data as md
WHERE md.customer_pet_name IS NOT null;

--  dm_customer
INSERT INTO dm_customer (customer_id ,source ,customer_first_name, customer_last_name, customer_age, customer_email, customer_country_id, customer_postal_code, customer_pet_id)
SELECT distinct
	md.id,
	md.source,
    md.customer_first_name,
    md.customer_last_name,
    md.customer_age,
    md.customer_email,
    (SELECT country_id FROM dm_country WHERE country_name = md.customer_country),
    md.customer_postal_code,
    (
        SELECT pet_id
        FROM dm_pet
        WHERE type_id = (SELECT kind_id FROM dm_kind WHERE kind_name = md.customer_pet_type)
          AND breed_id = (SELECT breed_id FROM dm_breed WHERE breed_name = md.customer_pet_breed)
          AND pet_name = md.customer_pet_name
    )
FROM mock_data AS md
WHERE md.customer_first_name IS NOT NULL;


--  dm_sellers
INSERT INTO dm_sellers (seller_first_name, seller_last_name, seller_email, seller_country_id, seller_postal_code)
SELECT DISTINCT
    md.seller_first_name,
    md.seller_last_name,
    md.seller_email,
    (SELECT country_id FROM dm_country WHERE country_name = md.seller_country),
    md.seller_postal_code
FROM mock_data as  md
WHERE md.seller_first_name IS NOT NULL;

--  dm_products
INSERT INTO dm_products (product_name, product_category_id, product_price, product_quantity, pet_category_id, product_weight, product_color_id, product_size, product_brand_id, product_material_id, product_description, product_rating, product_reviews, product_release_date_id, product_expiry_date_id)
SELECT DISTINCT
    md.product_name,
    (SELECT product_category_id FROM dm_product_category WHERE product_category_name = md.product_category),
    md.product_price,
    md.product_quantity,
    (SELECT pet_category_id FROM dm_pet_category WHERE pet_category_name = md.pet_category),
    md.product_weight,
    (SELECT product_color_id FROM dm_product_color WHERE product_color_name = md.product_color),
    md.product_size,
    (SELECT product_brand_id FROM dm_product_brand WHERE product_brand_name = md.product_brand),
    (SELECT product_material_id FROM dm_product_material WHERE product_material_name = md.product_material),
    md.product_description,
    md.product_rating,
    md.product_reviews,
    (SELECT DateID FROM d_time WHERE Date = md.product_release_date),
    (SELECT DateID FROM d_time WHERE Date = md.product_expiry_date)
FROM mock_data as  md
WHERE md.product_name IS NOT NULL;

--  dm_stores
INSERT INTO dm_stores (store_location, store_city_id, store_state, store_country_id, store_phone, store_email)
SELECT DISTINCT
    md.store_location,
    (SELECT city_id FROM dm_city WHERE city_name = md.store_city),
    md.store_state,
    (SELECT country_id FROM dm_country WHERE country_name = md.store_country),
    md.store_phone,
    md.store_email
FROM mock_data md
WHERE md.store_location IS NOT NULL;

--  dm_supplier
INSERT INTO dm_supplier (supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city_id, supplier_country_id)
SELECT DISTINCT
    md.supplier_name,
    md.supplier_contact,
    md.supplier_email,
    md.supplier_phone,
    md.supplier_address,
    (SELECT city_id FROM dm_city WHERE city_name = md.supplier_city),
    (SELECT country_id FROM dm_country WHERE country_name = md.supplier_country)
FROM mock_data md
WHERE md.supplier_name IS NOT NULL;

--  sales
INSERT INTO sales (sale_date_id, sale_customer_id, sale_customer_source, sale_seller_id, sale_product_id, sales_store_id, sales_supplier_id, sale_quantity, sale_total_price)
SELECT DISTINCT
    (SELECT DateID FROM d_time WHERE Date = md.sale_date),
    (SELECT customer_id FROM dm_customer WHERE customer_email = md.customer_email LIMIT 1),
    md.source, 
    (SELECT seller_id FROM dm_sellers WHERE seller_email = md.seller_email LIMIT 1),
    (
        SELECT product_id
        FROM dm_products
        WHERE product_name = md.product_name
          AND product_category_id = (SELECT product_category_id FROM dm_product_category WHERE product_category_name = md.product_category)
          AND product_price = md.product_price
          AND product_quantity = md.product_quantity
          AND pet_category_id = (SELECT pet_category_id FROM dm_pet_category WHERE pet_category_name = md.pet_category)
          AND product_weight = md.product_weight
          AND product_color_id = (SELECT product_color_id FROM dm_product_color WHERE product_color_name = md.product_color)
          AND product_size = md.product_size
          AND product_brand_id = (SELECT product_brand_id FROM dm_product_brand WHERE product_brand_name = md.product_brand)
          AND product_material_id = (SELECT product_material_id FROM dm_product_material WHERE product_material_name = md.product_material)
          AND product_description = md.product_description
          AND product_rating = md.product_rating
          AND product_reviews = md.product_reviews
          AND product_release_date_id = (SELECT DateID FROM d_time WHERE Date = md.product_release_date)
          AND product_expiry_date_id = (SELECT DateID FROM d_time WHERE Date = md.product_expiry_date)
    ),
    (SELECT store_id FROM dm_stores WHERE store_email = md.store_email ),
    (SELECT supplier_id FROM dm_supplier WHERE supplier_email = md.supplier_email ),
    md.sale_quantity,
    md.sale_total_price
FROM mock_data md
WHERE md.sale_date IS NOT NULL;

