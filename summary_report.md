
# Аналитическая записка по Case Study SQL

### ФИО: Абдуллаев Сайидазизхон Шухратович  
**Дата**: 14.11.2024  

## Введение
Этот кейс-стади выполнен в Python с использованием SQLAlchemy и Pandas для анализа данных из базы PostgreSQL. Основные задачи включают создание схемы базы данных, загрузку данных и выполнение аналитических запросов для получения бизнес-инсайтов.

---

## Блок 1: Создание схемы и таблиц
Первым шагом было создание структуры базы данных и загрузка данных из Excel-файла в PostgreSQL. Таблицы включают информацию о клиентах, продуктах, продажах, территориях и категориях продуктов.

---

## Блок 2: Аналитические задачи

### Секция 1: Анализ клиентов
1. **Сегментация по доходу**: Определены профессии клиентов и их средний доход для целевых маркетинговых кампаний.
2. **Семейный профиль**: Вычислен процент клиентов с детьми, что даёт представление о семейном профиле клиентской базы.
3. **Высокодоходные клиенты**: Определены Топ 10 самых высокодоходных клиентов.
4. **Влияние семейного положения**: Вычислена средняя сумма продаж по семейному положению клиентов, из вычислений видно, что семейное положение не влияет на среднюю сумму продаж 
### Секция 2: Анализ продаж
1. **Анализ по категориям продуктов**: Выявлены категории продуктов с наибольшими продажами.
2. **Анализ территорий продаж**: Определены наиболее прибыльные регионы для оптимизации маркетинговых ресурсов.
### Секция 3: Анализ продуктов

1. **Доля продаж по категориям продуктов**  
   **Цель**: Определить вклад каждой категории продуктов в общие продажи за год.
   
   <details>
   
   <summary>Показать запрос SQL</summary>

   ```sql
   SELECT
       EXTRACT(YEAR FROM s.order_date) AS year,
       p.product_key,
       pc.product_category_key,
       pc.english_product_category_name,
       SUM(s.sales_amount) AS sales_amount,
       ROUND(SUM(s.sales_amount)::numeric * 100. / total_sales.total_sales_amount::numeric, 2) AS pct_of_total_sales
   FROM 
       adv_works.sales s
   JOIN 
       adv_works.products p ON s.product_key = p.product_key
   JOIN 
       adv_works.product_category pc ON p.product_category_key = pc.product_category_key
   GROUP BY 
       year, p.product_key, pc.product_category_key, pc.english_product_category_name
   ORDER BY year, pc.product_category_key;
   ```

   </details>

   **Результат**: Итоговые данные показывают вклад продаж каждой категории продуктов в общую выручку, что позволяет сосредоточить усилия на наиболее прибыльных категориях.

2. **Самые продаваемые продукты**  
   **Цель**: Определить топ-5 продуктов с наибольшей суммой продаж.
   
   <details>

   <summary>Показать запрос SQL</summary>

   ```sql
   SELECT
       p.product_key,
       p.product_name,
       pc.english_product_category_name,
       SUM(s.sales_amount) AS sales_amount
   FROM 
       adv_works.sales s
   JOIN 
       adv_works.products p ON s.product_key = p.product_key
   GROUP BY 
       p.product_key, p.product_name, pc.english_product_category_name
   ORDER BY sales_amount DESC
   LIMIT 5;
   ```

   </details>

   **Результат**: Список топ-5 продуктов по продажам позволяет сосредоточить маркетинг на наиболее популярных позициях.

3. **Маржа от продаж**  
    **Цель**:  Посчитать разницу между суммой продаж за минусом себестоимости, налогов и расходов на доставку по каждому продукту в разбивке по годам и месяцам..

    <details>

    <summary>Показать запрос SQL </summary>

    ```sql
    SELECT
        EXTRACT(YEAR FROM s.order_date) AS year,
        EXTRACT(MONTH FROM s.order_date) AS monthkey,
        TO_CHAR(s.order_date, 'FMMonth') AS month_name,
        p.product_key,
        p.product_name,
        SUM(s.sales_amount) AS sales_amount,
        SUM(s.total_product_cost) AS total_product_cost,
        SUM(s.tax_amt) AS tax_amt,
        SUM(s.freight) AS freight,
        SUM(s.sales_amount) - SUM(s.total_product_cost) - SUM(s.tax_amt) - SUM(s.freight) AS margin,
        ROUND((SUM(s.sales_amount)::numeric - SUM(s.total_product_cost)::numeric - SUM(s.tax_amt)::numeric - SUM(s.freight))::numeric * 100.0 / SUM(s.sales_amount)::numeric, 2) AS margin_pct
    FROM
        adv_works.sales s
    JOIN 
        adv_works.products p ON s.product_key = p.product_key
    GROUP BY
        EXTRACT(YEAR FROM s.order_date),
        EXTRACT(MONTH FROM s.order_date),
        TO_CHAR(s.order_date, 'FMMonth'),
        p.product_key,
        p.product_name
    ORDER BY year, monthkey, p.product_key;
    ``` 
</details>

**Результат**: Анализ позволяет выявить сезонные тенденции в продажах и прибыльности продуктов, а также оценить эффективность каждого продукта в разрезе доходов и затрат.  

### Секция 4: Анализ трендов

1. **Квартальный рост продаж**  
   **Цель**: Определить рост продаж по кварталам для двух наиболее продаваемых категорий продуктов.
   
   <details>
   <summary>Показать запрос SQL</summary>

   ```sql
   SELECT
       t.year,
       t.quarter_id,
       t.product_category_key,
       t.english_product_category_name,
       ROUND(SUM(t.quarter_sales_amount)::numeric) AS quarter_sales_amount,
       ROUND(
           (SUM(t.quarter_sales_amount)::numeric - LAG(SUM(t.quarter_sales_amount)::numeric) OVER (PARTITION BY t.product_category_key ORDER BY t.year, t.quarter_id)) * 100.0 / 
           NULLIF(LAG(SUM(t.quarter_sales_amount)::numeric) OVER (PARTITION BY t.product_category_key ORDER BY t.year, t.quarter_id), 0),
           2
       ) AS quarter_over_quarter_growth_pct
   FROM top_categories t
   WHERE t.product_category_key IN (SELECT product_category_key FROM top_2_categories)
   GROUP BY t.year, t.quarter_id, t.product_category_key, t.english_product_category_name;
   ```

   </details>

   **Результат**: Таблица с квартальными продажами и процентным изменением по сравнению с предыдущим кварталом. Эти данные помогают оценить стабильность роста и выявить сезонные пики.

2. **Сравнение продаж по дням недели**  
   **Цель**: Сравнить продажи в будние и выходные дни.
   
   <details>
   <summary>Показать запрос SQL</summary>

   ```sql
   SELECT
       EXTRACT(YEAR FROM s.order_date) AS year,
       TO_CHAR(s.order_date, 'FMDay') AS day_name,
       CASE WHEN EXTRACT(DOW FROM s.order_date) IN (0, 6) THEN 1 ELSE 0 END AS is_weekend,
       ROUND(SUM(s.sales_amount)::numeric, 2) AS sales_amount
   FROM 
       adv_works.sales s
   GROUP BY 
       year, day_name, is_weekend
   ORDER BY year, is_weekend DESC, day_name;
   ```

   </details>

   **Результат**: Анализ продаж по будням и выходным выявляет предпочтительные дни для проведения акций и маркетинговых активностей.

---

## Выводы и рекомендации

- **Продуктовые категории**: Наиболее популярные категории должны стать приоритетными для рекламных кампаний.
- **Рост продаж по кварталам**: Анализ роста может служить ориентиром для планирования продаж.
- **Дни с наибольшими продажами**: Рекомендовано проводить акции в наиболее активные дни для увеличения выручки.

**Заключение**  
Данный анализ предоставляет ценные инсайты для улучшения маркетинговых и операционных стратегий, фокусируясь на ключевых продуктах и потребительских привычках.
