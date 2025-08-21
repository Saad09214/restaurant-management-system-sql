--
-- ملف تعبئة البيانات التجريبية
-- هذا الملف يقوم بإضافة بيانات عينة إلى الجداول التي تم إنشاؤها.
--
USE  restaurant_db;
-- إضافة بيانات عينة للعملاء.
INSERT INTO Customers (name, phone_number) VALUES
('علي أحمد', '0501234567'),
('فاطمة خالد', '0559876543'),
('سلطان محمد', '0543210987');

-- إضافة أصناف لقائمة الطعام.
INSERT INTO MenuItems (item_name, price) VALUES
('برجر دجاج', 25.50),
('بطاطس مقلية', 10.00),
('عصير برتقال', 8.00),
('بيتزا مارجريتا', 45.00),
('سلطة سيزر', 30.00);

-- تسجيل بعض الطلبات.
INSERT INTO Orders (customer_id) VALUES (1); -- طلب من علي
INSERT INTO Orders (customer_id) VALUES (2); -- طلب من فاطمة
INSERT INTO Orders (customer_id) VALUES (1); -- طلب آخر من علي

-- تسجيل تفاصيل الأصناف لكل طلب.
-- الطلب الأول (لـ علي)
INSERT INTO OrderItems (order_id, item_id, quantity, subtotal) VALUES
(1, 1, 1, 25.50), -- برجر دجاج
(1, 2, 1, 10.00); -- بطاطس مقلية

-- الطلب الثاني (لـ فاطمة)
INSERT INTO OrderItems (order_id, item_id, quantity, subtotal) VALUES
(2, 3, 2, 16.00); -- عصير برتقال

-- الطلب الثالث (لـ علي)
INSERT INTO OrderItems (order_id, item_id, quantity, subtotal) VALUES
(3, 4, 1, 45.00), -- بيتزا مارجريتا
(3, 5, 1, 30.00); -- سلطة سيزر
