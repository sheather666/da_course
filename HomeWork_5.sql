-- 1. Из таблицы customer вытащите список телефонных номеров, не содержащих скобок
SELECT phone
FROM customer
WHERE phone NOT LIKE '%(%' AND phone NOT LIKE '%)%';

-- 2. Измените текст 'lorem ipsum' так, чтобы только первая буква первого слова была в верхнем регистре, а всё остальное в нижнем
SELECT initcap(lower('lorem ipsum'));

-- 3. Из таблицы track вытащите список названий песен, которые содержат слово 'run'
SELECT name
FROM track
WHERE name ILIKE '%run%';

-- 4. Вытащите список клиентов с почтовым ящиком в 'gmail'
SELECT email
FROM customer
WHERE email ILIKE '%@gmail.com';

-- 5. Из таблицы track найдите произведение с самым длинным названием
SELECT name
FROM track
ORDER BY LENGTH(name) DESC
LIMIT 1;

-- 6. Посчитайте общую сумму продаж за 2021 год, в разбивке по месяцам. Итоговая таблица должна содержать следующие поля: month_id, sales_sum
SELECT EXTRACT(MONTH FROM invoice_date) AS month_id, SUM(total) AS sales_sum
FROM invoice i 
WHERE EXTRACT(YEAR FROM invoice_date) = 2021
GROUP BY month_id
ORDER BY month_id;


-- 7. К предыдущему запросу добавьте также поле с названием месяца. Итоговая таблица должна содержать следующие поля: month_id, month_name, sales_sum. Результат должен быть отсортирован по номеру месяца.
SELECT 
  EXTRACT(MONTH FROM invoice_date) AS month_id,
  TO_CHAR(invoice_date, 'Month') AS month_name,
  SUM(total) AS sales_sum
FROM invoice
WHERE EXTRACT(YEAR FROM invoice_date) = 2021
GROUP BY month_id, month_name
ORDER BY month_id;

-- 8. Вытащите список 3 самых возрастных сотрудников компании. Итоговая таблица должна содержать следующие поля: full_name (имя и фамилия), birth_date, age_now (возраст в годах в числовом формате)
SELECT 
  first_name || ' ' || last_name AS full_name,
  birth_date,
  EXTRACT(YEAR FROM AGE(birth_date)) AS age_now
FROM employee
ORDER BY age_now DESC
LIMIT 3;

-- 9. Посчитайте каков будет средний возраст сотрудников через 3 года и 4 месяца
SELECT AVG(EXTRACT(YEAR FROM AGE(birth_date + INTERVAL '3 years 4 months'))) AS average_age_in_future
FROM employee;

-- 10. Посчитайте сумму продаж в разбивке по годам и странам. Оставьте только те строки, где сумма продажи больше 20. Результат отсортируйте по году продажи (по возрастанию) и сумме продажи (по убыванию).
SELECT 
  EXTRACT(YEAR FROM invoice_date) AS sales_year,
  billing_country,
  SUM(total) AS sales_sum
FROM invoice
GROUP BY sales_year, billing_country
HAVING SUM(total) > 20
ORDER BY sales_year ASC, sales_sum DESC;
