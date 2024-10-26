/*
Автор: Сайидазизхон Абдуллаев
Задача: Выполнение различных SQL-запросов для работы с таблицами track и invoice в PostgreSQL ДЗ №4
*/

-- 1. Вернуть из таблицы track поля name и genreid
SELECT name, genre_id 
FROM track t;

-- 2. Вернуть из таблицы track поля name, composer, unitprice, переименованные на song, author и price. Поля расположены в порядке: название произведения, цена, автор.
SELECT name AS song, unit_price AS price, composer AS author
FROM track;

-- 3. Вернуть из таблицы track название произведения и его длительность в минутах, отсортировав по длительности по убыванию
SELECT name, milliseconds / 60000.0 AS duration_in_minutes
FROM track
ORDER BY duration_in_minutes DESC;

-- 4. Вернуть из таблицы track поля name и genreid, и только первые 15 строк
SELECT name, genre_id 
FROM track
LIMIT 15;

-- 5. Вернуть из таблицы track все поля и все строки, начиная с 50-й строки
SELECT *
FROM track
OFFSET 49;

-- 6. Вернуть из таблицы track названия всех произведений, чей объём больше 100 мегабайт
SELECT name
FROM track
WHERE bytes > 100 * 1024 * 1024;

-- 7. Вернуть из таблицы track поля name и composer, где composer не равен 'U2'. Вернуть записи с 10 по 20-ю включительно
SELECT name, composer
FROM track
WHERE composer != 'U2'
ORDER BY name
LIMIT 11 OFFSET 9;

-- 8. Вернуть из таблицы invoice дату самой первой и самой последней покупки
SELECT MIN(invoice_date) AS first_purchase, MAX(invoice_date) AS last_purchase
FROM invoice;

-- 9. Вернуть размер среднего чека для покупок из США
SELECT AVG(total) AS average_check
FROM invoice
WHERE billing_country = 'USA';

-- 10. Вернуть список городов, в которых имеется более одного клиента
SELECT billing_city, COUNT(customer_id) AS customer_count
FROM invoice
GROUP BY billing_city
HAVING COUNT(customer_id) > 1;
