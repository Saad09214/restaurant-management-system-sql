--
-- ملف إعداد قاعدة بيانات المطعم
-- هذا الملف يقوم بإنشاء هيكل قاعدة البيانات والجداول والإجراءات المخزنة.
--
-- إنشاء قاعدة البيانات الخاصة بالمشروع إذا لم تكن موجودة.
CREATE DATABASE IF NOT EXISTS restaurant_db;
USE restaurant_db;

-- حذف الجداول إذا كانت موجودة لتجنب الأخطاء عند إعادة التشغيل.
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS MenuItems;
DROP TABLE IF EXISTS Customers;

-- إنشاء جدول العملاء (Customers) لتخزين بيانات الزبائن.
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) UNIQUE
);

-- إنشاء جدول قائمة الطعام (MenuItems) لتخزين الأصناف المتاحة وأسعارها.
CREATE TABLE MenuItems (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- إنشاء جدول الطلبات (Orders) لتسجيل كل طلب، مع ربطه بالعميل.
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- إنشاء جدول تفاصيل الطلبات (OrderItems) لتحديد الأصناف الموجودة في كل طلب.
CREATE TABLE OrderItems (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES MenuItems(item_id)
);

-- -----------------------------------------------------
-- الإجراءات المخزنة (Stored Procedures)
-- -----------------------------------------------------

-- حذف الإجراءات المخزنة إذا كانت موجودة لتجنب الأخطاء.
DROP PROCEDURE IF EXISTS calculateTotal;
DROP PROCEDURE IF EXISTS placeOrder;

-- الإجراء calculateTotal
-- يحسب الإجمالي النهائي لطلب معين.
DELIMITER $$
CREATE PROCEDURE calculateTotal(IN p_order_id INT, OUT p_total DECIMAL(10, 2))
BEGIN
    SELECT SUM(subtotal) INTO p_total FROM OrderItems WHERE order_id = p_order_id;
END$$
DELIMITER ;

-- الإجراء placeOrder
-- يقوم بإنشاء طلب جديد وإضافة الأصناف المحددة إليه.
DELIMITER $$
CREATE PROCEDURE placeOrder(IN p_customer_id INT, IN p_items JSON)
BEGIN
    DECLARE v_order_id INT;
    DECLARE v_item_id INT;
    DECLARE v_quantity INT;
    DECLARE v_price DECIMAL(10, 2);
    
    INSERT INTO Orders (customer_id) VALUES (p_customer_id);
    SET v_order_id = LAST_INSERT_ID();

    BEGIN
        DECLARE i INT DEFAULT 0;
        WHILE i < JSON_LENGTH(p_items) DO
            SET v_item_id = JSON_EXTRACT(p_items, CONCAT('$[', i, '].item_id'));
            SET v_quantity = JSON_EXTRACT(p_items, CONCAT('$[', i, '].quantity'));

            SELECT price INTO v_price FROM MenuItems WHERE item_id = v_item_id;

            INSERT INTO OrderItems (order_id, item_id, quantity, subtotal)
            VALUES (v_order_id, v_item_id, v_quantity, v_price * v_quantity);

            SET i = i + 1;
        END WHILE;
    END;

    SELECT CONCAT('تم إنشاء الطلب رقم ', v_order_id, ' بنجاح!') AS message;
END$$
DELIMITER ;
