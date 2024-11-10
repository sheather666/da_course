/*
  1.По каждому сотруднику компании предоставьте следующую информацию: 
 	 id сотрудника, 
 	 полное имя, 
 	 позиция (title), 
 	 id менеджера (reports_to), 
 	 полное имя менеджера и через запятую его позиция.
*/
select 
   x.employee_id
 , x.employee_name
 , x.title
 , e.employee_id as manager_id
 , e.first_name || ' ' || last_name || ', ' || e.title as manager_name_and_title
from 
(
select
 reports_to 
 , first_name || ' ' || last_name as employee_name
 , employee_id 
 , title 
from 
 employee 
)x, employee e
where 
 x.reports_to = e.employee_id;

/*2. Вытащите список чеков, сумма которых была больше среднего чека за 2023 год. 
	 Итоговая таблица должна содержать следующие поля:
	  invoice_id, 
	  invoice_date, 
	  monthkey (цифровой код состоящий из года и месяца), 
	  customer_id, 
	  total
*/

select 
 invoice_id 
 , invoice_date 
 , to_char (invoice_date, 'yyyymm') as month_key
 , customer_id 
 , total 
from 
 invoice i
where 
  i.total  > (select avg(total) from invoice i2 where date_trunc('year', invoice_date) = '2023-01-01');
 
--3. Дополнить предыдущую информацию e-mail-ом клиента.
select 
 q.*
 , c.email 
from 
( 
select 
   invoice_id 
 , invoice_date 
 , to_char (invoice_date, 'yyyymm') as month_key
 , customer_id 
 , total 
from 
 invoice i
where 
  i.total  > (select avg(total) from invoice i2 where date_trunc('year', invoice_date) = '2023-01-01')
 )q, 
  customer c
where
 q.customer_id = c.customer_id;

-- Отфильтровать запрос так чтобы в нем небыло клиентов имеющих почтовый ящик в домене gmail.


select 
 q.*
 , c.email 
from 
( 
select 
   invoice_id 
 , invoice_date 
 , to_char (invoice_date, 'yyyymm') as month_key
 , customer_id 
 , total 
from 
 invoice i
where 
  i.total  > (select avg(total) from invoice i2 where date_trunc('year', invoice_date) = '2023-01-01')
 )q, 
  customer c
where
 q.customer_id = c.customer_id
 and q.customer_id not in (select customer_id from customer c2 where c2.email like '%gmail%');


--Посчитайте какой процент от общей выручки за 2024 год принёс каждый чек

select 
i2.invoice_id
, i2.invoice_date
, i2.total
,round((i2.total / ( select sum(total) 
		 from invoice i  
		 where  date_trunc('year', invoice_date) = '2024-01-01')) * 100, 2)
from 
 invoice i2 
where 
 date_trunc('year', invoice_date) = '2024-01-01' ;



--Посчитайте какой процент от общей выручки за 2024 год принёс каждый клиент компании.

select 
 x.customer_id
 , round((x.customer_total / (select sum(total) from invoice i where date_trunc('year', i.invoice_date) = '2024-01-01') * 100), 2) as percentage_of_revenue 
from (
 select 
  n.customer_id
  , sum(n.total) as customer_total
 from 
  invoice n
 where 
  date_trunc('year', n.invoice_date) = '2024-01-01'
 group by 
  n.customer_id
  )x
group by 
 x.customer_id
 , x.customer_total ;



