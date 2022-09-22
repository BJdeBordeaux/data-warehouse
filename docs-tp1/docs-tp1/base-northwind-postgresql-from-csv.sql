CREATE TABLE CATEGORIES
(
    CATEGORY_ID INT NOT NULL,
    CATEGORY_NAME VARCHAR(15) NOT NULL,
    DESCRIPTION VARCHAR(2000),
    PICTURE VARCHAR(255),
    CONSTRAINT PK_CATEGORIES PRIMARY KEY (CATEGORY_ID)
);

CREATE UNIQUE INDEX UIDX_CATEGORY_NAME ON CATEGORIES(CATEGORY_NAME);


-- COMMENT ON COLUMN CATEGORIES.CATEGORY_ID IS 'Number automatically assigned to a new category.';
-- COMMENT ON COLUMN CATEGORIES.CATEGORY_NAME IS 'Name of food category.';
-- COMMENT ON COLUMN CATEGORIES.PICTURE IS 'A picture representing the food category.';


CREATE TABLE CUSTOMERS
(
    CUSTOMER_ID INT NOT NULL,
    CUSTOMER_CODE VARCHAR(5) NOT NULL,
    COMPANY_NAME VARCHAR(40) NOT NULL,
    CONTACT_NAME VARCHAR(30),
    CONTACT_TITLE VARCHAR(30),
    ADDREss VARCHAR(60),
    CITY VARCHAR(15),
    REGION VARCHAR(15),
    POSTAL_CODE VARCHAR(10),
    COUNTRY VARCHAR(15),
    PHONE VARCHAR(24),
    FAX VARCHAR(24),
    CONSTRAINT PK_CUSTOMERS PRIMARY KEY (CUSTOMER_ID)
);

CREATE UNIQUE INDEX UIDX_CUSTOMERS_CODE ON CUSTOMERS(CUSTOMER_CODE);

CREATE INDEX IDX_CUSTOMERS_CITY ON CUSTOMERS(CITY);

CREATE INDEX IDX_CUSTOMERS_COMPANY_NAME ON CUSTOMERS(COMPANY_NAME);

CREATE INDEX IDX_CUSTOMERS_POSTAL_CODE ON CUSTOMERS(POSTAL_CODE);

CREATE INDEX IDX_CUSTOMERS_REGION ON CUSTOMERS(REGION);


-- COMMENT ON COLUMN CUSTOMERS.CUSTOMER_ID IS 'Unique five-character code based on customer name.';
-- COMMENT ON COLUMN CUSTOMERS.ADDREss IS 'Street or post-office box.';
-- COMMENT ON COLUMN CUSTOMERS.REGION IS 'State or province.';
-- COMMENT ON COLUMN CUSTOMERS.PHONE IS 'Phone number includes country code or area code.';
-- COMMENT ON COLUMN CUSTOMERS.FAX IS 'Phone number includes country code or area code.';


CREATE TABLE EMPLOYEES
(
    EMPLOYEE_ID INT NOT NULL,
    LASTNAME VARCHAR(20) NOT NULL,
    FIRSTNAME VARCHAR(10) NOT NULL,
    TITLE VARCHAR(30),
    TITLE_OF_COURTESY VARCHAR(25),
    BIRTHDATE DATE,
    HIREDATE DATE,
    ADDREss VARCHAR(60),
    CITY VARCHAR(15),
    REGION VARCHAR(15),
    POSTAL_CODE VARCHAR(10),
    COUNTRY VARCHAR(15),
    HOME_PHONE VARCHAR(24),
    EXTENSION VARCHAR(4),
    PHOTO VARCHAR(255),
    NOTES VARCHAR(2000),
    REPORTS_TO INT,
    CONSTRAINT PK_EMPLOYEES PRIMARY KEY (EMPLOYEE_ID)
);

CREATE INDEX IDX_EMPLOYEES_LASTNAME ON EMPLOYEES(LASTNAME);

CREATE INDEX IDX_EMPLOYEES_POSTAL_CODE ON EMPLOYEES(POSTAL_CODE);

-- COMMENT ON COLUMN EMPLOYEES.EMPLOYEE_ID IS 'Number automatically assigned to new employee.';
-- COMMENT ON COLUMN EMPLOYEES.TITLE IS 'Employee''s title.';
-- COMMENT ON COLUMN EMPLOYEES.TITLE_OF_COURTESY IS 'Title used in salutations.';
-- COMMENT ON COLUMN EMPLOYEES.ADDREss IS 'Street or post-office box.';
-- COMMENT ON COLUMN EMPLOYEES.REGION IS 'State or province.';
-- COMMENT ON COLUMN EMPLOYEES.HOME_PHONE IS 'Phone number includes country code or area code.';
-- COMMENT ON COLUMN EMPLOYEES.EXTENSION IS 'Internal telephone extension number.';
-- COMMENT ON COLUMN EMPLOYEES.PHOTO IS 'Picture of employee.';
-- COMMENT ON COLUMN EMPLOYEES.NOTES IS 'General information about employee''s background.';
-- COMMENT ON COLUMN EMPLOYEES.REPORTS_TO IS 'Employee''s supervisor.';



ALTER TABLE EMPLOYEES
ADD CONSTRAINT FK_REPORTS_TO FOREIGN KEY (REPORTS_TO) REFERENCES EMPLOYEES(EMPLOYEE_ID);

CREATE TABLE SUPPLIERS
(
    SUPPLIER_ID INT NOT NULL,
    COMPANY_NAME VARCHAR(40) NOT NULL,
    CONTACT_NAME VARCHAR(30),
    CONTACT_TITLE VARCHAR(30),
    ADDREss VARCHAR(60),
    CITY VARCHAR(15),
    REGION VARCHAR(15),
    POSTAL_CODE VARCHAR(10),
    COUNTRY VARCHAR(15),
    PHONE VARCHAR(24),
    FAX VARCHAR(24),
    HOME_PAGE VARCHAR(500),
    CONSTRAINT PK_SUPPLIERS PRIMARY KEY (SUPPLIER_ID)  
);

CREATE INDEX IDX_SUPPLIERS_COMPANY_NAME ON SUPPLIERS(COMPANY_NAME);

CREATE INDEX IDX_SUPPLIERS_POSTAL_CODE ON SUPPLIERS(POSTAL_CODE);


-- COMMENT ON COLUMN SUPPLIERS.SUPPLIER_ID IS 'Number automatically assigned to new supplier.';
-- COMMENT ON COLUMN SUPPLIERS.ADDREss IS 'Street or post-office box.';
-- COMMENT ON COLUMN SUPPLIERS.REGION IS 'State or province.';
-- COMMENT ON COLUMN SUPPLIERS.PHONE IS 'Phone number includes country code or area code.';
-- COMMENT ON COLUMN SUPPLIERS.FAX IS 'Phone number includes country code or area code.';
-- COMMENT ON COLUMN SUPPLIERS.HOME_PAGE IS 'Supplier''s home page on World Wide Web.';



CREATE TABLE SHIPPERS
(
    SHIPPER_ID INT NOT NULL,
    COMPANY_NAME VARCHAR(40) NOT NULL,
    PHONE VARCHAR(24),
    CONSTRAINT PK_SHIPPERS PRIMARY KEY (SHIPPER_ID)
);



-- COMMENT ON COLUMN SHIPPERS.SHIPPER_ID IS 'Number automatically assigned to new shipper.';
-- COMMENT ON COLUMN SHIPPERS.COMPANY_NAME IS 'Name of shipping company.';
-- COMMENT ON COLUMN SHIPPERS.PHONE IS 'Phone number includes country code or area code.';





CREATE TABLE PRODUCTS
(
    PRODUCT_ID INT NOT NULL,
    PRODUCT_NAME VARCHAR(40) NOT NULL,
    SUPPLIER_ID INT NOT NULL,
    CATEGORY_ID INT NOT NULL,
    QUANTITY_PER_UNIT VARCHAR(20),
    UNIT_PRICE DECIMAL(10,2) DEFAULT 0 NOT NULL CONSTRAINT CK_PRODUCTS_UNIT_PRICE CHECK (Unit_Price>=0),
    UNITS_IN_STOCK INT DEFAULT 0 NOT NULL CONSTRAINT CK_PRODUCTS_UNITS_IN_STOCK CHECK (Units_In_Stock>=0),
    UNITS_ON_ORDER INT DEFAULT 0 NOT NULL CONSTRAINT CK_PRODUCTS_UNITS_ON_ORDER CHECK (Units_On_Order>=0),
    REORDER_LEVEL INT DEFAULT 0 NOT NULL CONSTRAINT CK_PRODUCTS_REORDER_LEVEL CHECK (Reorder_Level>=0),
    DISCONTINUED CHAR(1) DEFAULT 'N' NOT NULL CONSTRAINT CK_PRODUCTS_DISCONTINUED CHECK (Discontinued in ('Y','N')),
    CONSTRAINT PK_PRODUCTS PRIMARY KEY (PRODUCT_ID),
    CONSTRAINT FK_CATEGORY_ID FOREIGN KEY (CATEGORY_ID) REFERENCES CATEGORIES(CATEGORY_ID),
    CONSTRAINT FK_SUPPLIER_ID FOREIGN KEY (SUPPLIER_ID) REFERENCES SUPPLIERS(SUPPLIER_ID)  
);
  
CREATE INDEX IDX_PRODUCTS_CATEGORY_ID ON PRODUCTS(CATEGORY_ID);

CREATE INDEX IDX_PRODUCTS_SUPPLIER_ID ON PRODUCTS(SUPPLIER_ID);


  
-- COMMENT ON COLUMN PRODUCTS.PRODUCT_ID IS 'Number automatically assigned to new product.';
-- COMMENT ON COLUMN PRODUCTS.SUPPLIER_ID IS 'Same entry as in Suppliers table.';
-- COMMENT ON COLUMN PRODUCTS.CATEGORY_ID IS 'Same entry as in Categories table.';
-- COMMENT ON COLUMN PRODUCTS.QUANTITY_PER_UNIT IS '(e.g., 24-count case, 1-liter bottle).';
-- COMMENT ON COLUMN PRODUCTS.REORDER_LEVEL IS 'Minimum units to maintain in stock.';
-- COMMENT ON COLUMN PRODUCTS.DISCONTINUED IS 'Yes means item is no longer available.';


CREATE TABLE ORDERS
(
    ORDER_ID INT NOT NULL,
    CUSTOMER_ID INT NOT NULL,
    EMPLOYEE_ID INT NOT NULL,
    ORDER_DATE DATE NOT NULL,
    REQUIRED_DATE DATE,
    SHIPPED_DATE DATE,
    SHIP_VIA INT,
    FREIGHT DECIMAL(10,2) DEFAULT 0,
    SHIP_NAME VARCHAR(40),
    SHIP_ADDREss VARCHAR(60),
    SHIP_CITY VARCHAR(15),
    SHIP_REGION VARCHAR(15),
    SHIP_POSTAL_CODE VARCHAR(10),
    SHIP_COUNTRY VARCHAR(15),
    CONSTRAINT PK_ORDERS PRIMARY KEY (ORDER_ID),
    CONSTRAINT FK_CUSTOMER_ID FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID),  
    CONSTRAINT FK_EMPLOYEE_ID FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID),  
    CONSTRAINT FK_SHIPPER_ID FOREIGN KEY (SHIP_VIA) REFERENCES SHIPPERS(SHIPPER_ID)  
);

CREATE INDEX IDX_ORDERS_CUSTOMER_ID ON ORDERS(CUSTOMER_ID);

CREATE INDEX IDX_ORDERS_EMPLOYEE_ID ON ORDERS(EMPLOYEE_ID);

CREATE INDEX IDX_ORDERS_SHIPPER_ID ON ORDERS(SHIP_VIA);

CREATE INDEX IDX_ORDERS_ORDER_DATE ON ORDERS(ORDER_DATE);

CREATE INDEX IDX_ORDERS_SHIPPED_DATE ON ORDERS(SHIPPED_DATE);

CREATE INDEX IDX_ORDERS_SHIP_POSTAL_CODE ON ORDERS(SHIP_POSTAL_CODE);


-- COMMENT ON COLUMN ORDERS.ORDER_ID IS 'Unique order number.';
-- COMMENT ON COLUMN ORDERS.CUSTOMER_ID IS 'Same entry as in Customers table.';
-- COMMENT ON COLUMN ORDERS.EMPLOYEE_ID IS 'Same entry as in Employees table.';
-- COMMENT ON COLUMN ORDERS.SHIP_VIA IS 'Same as Shipper ID in Shippers table.';
-- COMMENT ON COLUMN ORDERS.SHIP_NAME IS 'Name of person or company to receive the shipment.';
-- COMMENT ON COLUMN ORDERS.SHIP_ADDREss IS 'Street address only -- no post-office box allowed.';
-- COMMENT ON COLUMN ORDERS.SHIP_REGION IS 'State or province.';




CREATE TABLE ORDER_DETAILS
(
    ORDER_ID INT NOT NULL,
    PRODUCT_ID INT NOT NULL,
    UNIT_PRICE DECIMAL(10,2) DEFAULT 0 NOT NULL CONSTRAINT CK_ORDER_DETAILS_UNIT_PRICE CHECK (Unit_Price>=0),
    QUANTITY INT DEFAULT 1 NOT NULL CONSTRAINT CK_ORDER_DETAILS_QUANTITY CHECK (Quantity>0),
    DISCOUNT DECIMAL(4,2) DEFAULT 0 NOT NULL CONSTRAINT CK_ORDER_DETAILS_DISCOUNT CHECK (Discount between 0 and 1),
    CONSTRAINT PK_ORDER_DETAILS PRIMARY KEY (ORDER_ID, PRODUCT_ID),
    CONSTRAINT FK_ORDER_ID FOREIGN KEY (ORDER_ID) REFERENCES ORDERS (ORDER_ID),
    CONSTRAINT FK_PRODUCT_ID FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS (PRODUCT_ID)
);

CREATE INDEX IDX_ORDER_DETAILS_ORDER_ID ON ORDER_DETAILS(ORDER_ID);

CREATE INDEX IDX_ORDER_DETAILS_PRODUCT_ID ON ORDER_DETAILS(PRODUCT_ID);

-- COMMENT ON COLUMN ORDER_DETAILS.ORDER_ID IS 'Same as Order ID in Orders table.';
-- COMMENT ON COLUMN ORDER_DETAILS.PRODUCT_ID IS 'Same as Product ID in Products table.';






\copy categories from 'northwind_csv/categories.csv' delimiter ';' csv header;
\copy customers from 'northwind_csv/customers.csv' delimiter ';' csv header;
\copy employees from 'northwind_csv/employees.csv' delimiter ';' csv header;
\copy shippers from 'northwind_csv/shippers.csv' delimiter ';' csv header;
\copy suppliers from 'northwind_csv/suppliers.csv' delimiter ';' csv header;
\copy products from 'northwind_csv/products.csv' delimiter ';' csv header;
\copy orders from 'northwind_csv/orders.csv' delimiter ';' csv header;
\copy order_details from 'northwind_csv/order_details.csv' delimiter ';' csv header;
