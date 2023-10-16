---------------------------
# 3 required corrections :
----------------------------

SELECT 
    c. client_name,
    q.amount,
    q.currency
FROM
    learning.`client` as c
   JOIN
        learning.`quotation` as q
    ON  c.client_id = q.client_id;
    
  ------------------------------------------
  # если  бонус  не внесен NULL
  ------------------------------------------
SELECT 
    master_name, 
    salary, 
    COALESCE(`bonus_%`, 0) AS bonus_percent,
    (salary + (salary * COALESCE(`bonus_%`, 0) / 100)) AS total_salary
FROM learning.masters;

  SELECT 
    master_name, 
    salary, 
    IFNULL(`bonus_%`, 0) AS bonus_percent,
    (salary + (salary * IFNULL(`bonus_%`, 0) / 100)) AS total_salary
FROM learning.masters;

------------------------------------------
  # если использовать ROLLUP
  ------------------------------------------
SELECT
    master_id, 
    master_name,
    SUM(salary) AS total_salary,
    SUM(salary * (`bonus_%` / 100)) AS total_bonus,
    SUM(salary) + SUM(salary * (`bonus_%` / 100)) AS total_income
FROM
    learning.masters
WHERE
    DATE_FORMAT(payment_date, '%Y') 
GROUP BY
    master_name
WITH ROLLUP;