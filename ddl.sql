CREATE TABLE d_day (
    DayID INT,
    DayName VARCHAR(10) NOT NULL,
    PRIMARY KEY (DayID)
);

CREATE TABLE d_month (
    MonthID INT,
    MonthName VARCHAR(10) NOT NULL,
    PRIMARY KEY (MonthID)
);

CREATE TABLE d_time (
    DateID SERIAL,
    Date DATE NOT NULL,
    DayID INT NOT NULL,
    MonthID INT NOT NULL,
    Year INT NOT NULL,
    PRIMARY KEY (DateID),
    FOREIGN KEY (DayID) REFERENCES d_day(DayID),
    FOREIGN KEY (MonthID) REFERENCES d_month(MonthID)
);

CREATE TABLE dm_pet_category (
    pet_category_id SERIAL,
    pet_category_name VARCHAR(100),
    PRIMARY KEY (pet_category_id)
);

CREATE TABLE dm_product_material (
    product_material_id SERIAL,
    product_material_name VARCHAR(100),
    PRIMARY KEY (product_material_id)
);

CREATE TABLE dm_product_brand (
    product_brand_id SERIAL,
    product_brand_name VARCHAR(100),
    PRIMARY KEY (product_brand_id)
);

CREATE TABLE dm_product_category (
    product_category_id SERIAL,
    product_category_name VARCHAR(100),
    PRIMARY KEY (product_category_id)
);

CREATE TABLE dm_product_color (
    product_color_id SERIAL,
    product_color_name VARCHAR(100),
    PRIMARY KEY (product_color_id)
);

CREATE TABLE dm_country (
    country_id SERIAL,
    country_name VARCHAR(100),
    PRIMARY KEY (country_id)
);

CREATE TABLE dm_city (
    city_id SERIAL,
    city_name VARCHAR(100),
    PRIMARY KEY (city_id)
);

CREATE TABLE dm_kind (
    kind_id SERIAL,
    kind_name VARCHAR(100),
    PRIMARY KEY (kind_id)
);

CREATE TABLE dm_breed (
    breed_id SERIAL,
    breed_name VARCHAR(100),
    PRIMARY KEY (breed_id)
);

CREATE TABLE dm_pet (
    pet_id SERIAL,
    type_id INT,
    breed_id INT,
    pet_name VARCHAR(100),
    PRIMARY KEY (pet_id),
    FOREIGN KEY (type_id) REFERENCES dm_kind(kind_id),
    FOREIGN KEY (breed_id) REFERENCES dm_breed(breed_id)
);

CREATE TABLE dm_customer (
    customer_id SERIAL,
    source INT DEFAULT 0,
    customer_first_name VARCHAR(100),
    customer_last_name VARCHAR(100),
    customer_age INT,
    customer_email VARCHAR(100),
    customer_country_id INT,
    customer_postal_code VARCHAR(20),
    customer_pet_id INT,
    PRIMARY KEY (customer_id, source),
    FOREIGN KEY (customer_country_id) REFERENCES dm_country(country_id),
    FOREIGN KEY (customer_pet_id) REFERENCES dm_pet(pet_id)
);

CREATE TABLE dm_sellers (
    seller_id SERIAL,
    seller_first_name VARCHAR(100),
    seller_last_name VARCHAR(100),
    seller_email VARCHAR(100),
    seller_country_id INT,
    seller_postal_code VARCHAR(20),
    PRIMARY KEY (seller_id),
    FOREIGN KEY (seller_country_id) REFERENCES dm_country(country_id)
);

CREATE TABLE dm_products (
    product_id SERIAL,
    product_name VARCHAR(100),
    product_category_id INT,
    product_price DECIMAL(10, 2),
    product_quantity INT,
    pet_category_id INT,
    product_weight DECIMAL(10, 2),
    product_color_id INT,
    product_size VARCHAR(50),
    product_brand_id INT,
    product_material_id INT,
    product_description TEXT,
    product_rating DECIMAL(3, 1),
    product_reviews INT,
    product_release_date_id INT,
    product_expiry_date_id INT,
    PRIMARY KEY (product_id),
    FOREIGN KEY (product_category_id) REFERENCES dm_product_category(product_category_id),
    FOREIGN KEY (pet_category_id) REFERENCES dm_pet_category(pet_category_id),
    FOREIGN KEY (product_color_id) REFERENCES dm_product_color(product_color_id),
    FOREIGN KEY (product_brand_id) REFERENCES dm_product_brand(product_brand_id),
    FOREIGN KEY (product_material_id) REFERENCES dm_product_material(product_material_id),
    FOREIGN KEY (product_release_date_id) REFERENCES d_time(DateID),
    FOREIGN KEY (product_expiry_date_id) REFERENCES d_time(DateID)
);

CREATE TABLE dm_stores (
    store_id SERIAL,
    store_location VARCHAR(100),
    store_city_id INT,
    store_state VARCHAR(100),
    store_country_id INT,
    store_phone VARCHAR(20),
    store_email VARCHAR(100),
    PRIMARY KEY (store_id),
    FOREIGN KEY (store_country_id) REFERENCES dm_country(country_id),
    FOREIGN KEY (store_city_id) REFERENCES dm_city(city_id)
);

CREATE TABLE dm_supplier (
    supplier_id SERIAL,
    supplier_name VARCHAR(100),
    supplier_contact VARCHAR(100),
    supplier_email VARCHAR(100),
    supplier_phone VARCHAR(20),
    supplier_address VARCHAR(255),
    supplier_city_id INT,
    supplier_country_id INT,
    PRIMARY KEY (supplier_id),
    FOREIGN KEY (supplier_country_id) REFERENCES dm_country(country_id),
    FOREIGN KEY (supplier_city_id) REFERENCES dm_city(city_id)
);

CREATE TABLE sales (
    sale_id SERIAL,
    sale_date_id INT,
    sale_customer_id INT,
    sale_customer_source INT,
    sale_seller_id INT,
    sale_product_id INT,
    sales_store_id INT,
    sales_supplier_id INT,
    sale_quantity INT,
    sale_total_price DECIMAL(10, 2),
    PRIMARY KEY (sale_id),
    FOREIGN KEY (sale_customer_id, sale_customer_source) REFERENCES dm_customer(customer_id, source),
    FOREIGN KEY (sale_seller_id) REFERENCES dm_sellers(seller_id),
    FOREIGN KEY (sale_product_id) REFERENCES dm_products(product_id),
    FOREIGN KEY (sales_store_id) REFERENCES dm_stores(store_id),
    FOREIGN KEY (sales_supplier_id) REFERENCES dm_supplier(supplier_id),
    FOREIGN KEY (sale_date_id) REFERENCES d_time(DateID)
);
 