# portfolio-projects-
SELECT *
FROM mv_employees.salary
WHERE employee_id = 10001
ORDER BY from_date DESC;

-- What was Georgi’s starting salary at the beginning of 2009?
SELECT *
FROM mv_employees.salary
WHERE employee_id = 10001 and '2009-01-01' between from_date and to_date
ORDER BY from_date DESC;
-- His salary was 66,961 

--What is Georgi’s current salary?
SELECT *
FROM mv_employees.salary
WHERE employee_id = 10001 and current_date  between from_date and to_date;
-- His current salary is 88,958


--Georgi received a raise on 23rd of June in 2014 - how much of a percentage increase was it?
-- by lag function
WITH cte AS (
SELECT
100 * (amount-lag(amount)over(order by from_date))/lag(amount)over(order by from_date) AS percentage_difference
FROM mv_employees.salary
WHERE employee_id = 10001
  AND ( from_date = '2014-06-23' or to_date = '2014-06-23') 
  )
select * 
from cte 
where percentage_difference is not null; 
-- the salary increase was by 4%

--What is the dollar amount difference between Georgi’s salary at date '2012-06-25' and '2020-06-21'
SELECT t2.amount_2020 - t1.amount_2012
FROM 
(
SELECT amount AS amount_2020
FROM mv_employees.salary
WHERE employee_id = 10001
AND '2020-06-21'BETWEEN from_date AND to_date
) AS t2
CROSS JOIN
(
SELECT amount AS amount_2012
FROM mv_employees.salary
WHERE employee_id = 10001
AND '2012-06-25'BETWEEN from_date AND to_date
) AS t1;
--The salary difference is 9,103

-- For each employee who no longer has a valid salary data point - which year had the most employee churn and how many employees left that year?

WITH cte AS (
SELECT 
employee_id,
MAX(to_date) AS final_date
FROM mv_employees.salary
GROUP BY employee_id
)
SELECT
EXTRACT(YEAR FROM final_date) AS churn_year,
count (*) AS employee_count
FROM cte
WHERE final_date != '9999-01-01'
GROUP BY churn_year
ORDER BY employee_count desc;
-- the highest number of employees (7,610) left in the year 2018

-- What is the average latest percentage and dollar amount change in salary for each employee who has a valid current salary record?

WITH CTE_LAG AS (
SELECT 
employee_id,
amount,
to_date,
lag(amount) over (partition by employee_id order by from_date) AS previous_salary
FROM mv_employees.salary
)
SELECT 
AVG(
100*(amount-previous_salary)/previous_salary ::NUMERIC
) AS average_latest_percentage,
AVG(amount - previous_salary) AS average_dollar_change
FROM CTE_LAG
WHERE to_date = '9999-01-01';
--Average latest percentage of salary is 3.02%
-- The averange dollor chance of each employee is 1,996.93
