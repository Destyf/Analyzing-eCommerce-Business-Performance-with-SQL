-- Data Preparation
create table customers_dataset (
	customer_id varchar,
	customer_unique_id varchar,
	customer_zip_code_prefix varchar,
	customer_city varchar,
	customer_state varchar);

create table geolocation_dataset (
	geolocation_zip_code_prefix varchar,
	geolocation_lat float8,
	geolocation_lng float8,
	geolocation_city varchar,
	geolocation_state varchar);

create table order_item_dataset (
	order_id varchar,
	order_item_id int,
	product_id varchar,
	seller_id varchar,
	shipping_limit_date timestamp,
	price float8,
	freight_value float8);
	
create table order_payments_detail (
	order_id varchar,
	payment_sequential int,
	payment_type varchar,
	payment_installments int,
	payment_value float8);

create table order_reviews_dataset (
	review_id varchar,
	order_id varchar,
	review_score int,
	review_comment_title varchar,
	review_comment_message varchar,
	review_creation_date timestamp,
	review_answer_timestamp timestamp);
	
create table orders_dataset (
	order_id varchar,
	customer_id varchar,
	order_status varchar,
	order_purchase_timestamp timestamp,
	order_approved_at timestamp,
	order_delivered_carrier_date timestamp,
	order_delivered_customer_date timestamp,
	order_estimated_delivery_date timestamp);
	
create table product_dataset (
	product_id varchar,
	product_category_name varchar,
	product_name_lenght int,
	product_description_lenght int,
	product_photos_qty int,
	product_weight_g int,
	product_length_cm int,
	product_height_cm int,
	product_width_cm int);

create table sellers_dataset (
	seller_id varchar,
	seller_zip_code_prefix varchar,
	seller_city varchar,
	eller_state varchar);
	
--Rename Column
ALTER TABLE geolocation_dataset
RENAME COLUMN geolocation_zip_code_prefix TO zip_code_prefix;

ALTER TABLE sellers_dataset
RENAME COLUMN seller_zip_code_prefix TO zip_code_prefix;

ALTER TABLE customers_dataset
RENAME COLUMN customer_zip_code_prefix TO zip_code_prefix;

--Primary Key
ALTER TABLE customers_dataset ADD PRIMARY KEY(customer_id);
ALTER TABLE orders_dataset ADD PRIMARY KEY(order_id);
ALTER TABLE product_dataset ADD PRIMARY KEY(product_id);
ALTER TABLE sellers_dataset ADD PRIMARY KEY(seller_id);
ALTER TABLE geolocation_dataset ADD PRIMARY KEY (zip_code_prefix);

--Foreign Key
ALTER TABLE order_item_dataset ADD FOREIGN KEY(order_id) REFERENCES orders_dataset;
ALTER TABLE order_item_dataset ADD FOREIGN KEY(product_id) REFERENCES product_dataset;
ALTER TABLE order_item_dataset	ADD FOREIGN KEY(seller_id) REFERENCES sellers_dataset;
ALTER TABLE order_payments_detail ADD FOREIGN KEY(order_id) REFERENCES orders_dataset;
ALTER TABLE order_reviews_dataset ADD FOREIGN KEY(order_id) REFERENCES orders_dataset;
ALTER TABLE orders_dataset ADD FOREIGN KEY(customer_id) REFERENCES customers_dataset;
ALTER TABLE sellers_dataset ADD FOREIGN KEY (zip_code_prefix) REFERENCES geolocation_dataset;
ALTER TABLE customers_dataset ADD FOREIGN KEY (zip_code_prefix) REFERENCES geolocation_dataset;
