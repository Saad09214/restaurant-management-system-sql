--
-- ملف استعلامات التحليل واستخلاص الرؤى
-- هذا الملف يحتوي على استعلامات تحليلية لاستخلاص معلومات قيمة من البيانات.
--
use restaurant_db;
-- استخراج إجمالي المبيعات اليومية.
SELECT
    DATE(O.order_date) AS order_day,
    SUM(OI.subtotal) AS total_daily_sales
FROM
    Orders O
JOIN
    OrderItems OI ON O.order_id = OI.order_id
GROUP BY
    DATE(O.order_date);

-- تحديد أكثر صنف مبيعًا.
SELECT
    MI.item_name,
    SUM(OI.quantity) AS total_quantity_sold
FROM
    OrderItems OI
JOIN
    MenuItems MI ON OI.item_id = MI.item_id
GROUP BY
    MI.item_name
ORDER BY
    total_quantity_sold DESC
LIMIT 1;

-- تحديد العملاء الأكثر إنفاقًا.
SELECT
    C.name,
    COUNT(O.order_id) AS number_of_orders,
    SUM(OI.subtotal) AS total_spent
FROM
    Customers C
JOIN
    Orders O ON C.customer_id = O.customer_id
JOIN
    OrderItems OI ON O.order_id = OI.order_id
GROUP BY
    C.name
ORDER BY
    total_spent DESC
LIMIT 3;
