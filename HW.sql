  ------------------------------------------------------------------
  # 1 Задача с занятия:
------------------------------------------------------------------
  SELECT master_name, salary,
  `bonus_%`,
  (salary + (salary * (`bonus_%` / 100))) AS total_salary
FROM learning.masters;
  
  -------------------------------------------------------------------
# 2  Простой JOIN 
  -------------------------------------------------------------------
SELECT 
    rq.request_for_quote_id,
    q.amount,
    q.currency
FROM
    learning.`quotation` q
     JOIN
        learning.`request_for_quote` rq
    ON rq.request_for_quote_id = q.request_for_quote_id;
  
  -------------------------------------------------------------------
    # Inner join
    -------------------------------------------------------------------  
    SELECT 
    c. `name`,
    q.amount,
    q.currency
FROM
    learning.`quotation` q
     INNER JOIN
        learning.`client` c
    ON  c.client_id = q.client_id;
    
-------------------------------------------------------------------
    #  LEFT JOIN M-M
------------------------------------------------------------------
SELECT 
    o.order_details, 
    m.master_name, 
    m.`salary`
FROM
    learning.masters m
        LEFT JOIN
    learning.master_order mo ON m.master_id = mo.master_id
        LEFT JOIN
    learning.orders o ON mo.order_id = o.order_id;

-------------------------------------------------------------------
    #  LEFT JOIN 1-M 
------------------------------------------------------------------
SELECT 
c.client_name, 
i.invoice_nr
FROM learning.`client` c
LEFT JOIN 
learning.invoice i ON  i.invoice_nr = c.invoice_nr;

-------------------------------------------------------------------
    #  RIGHT JOIN M-M
------------------------------------------------------------------
SELECT 
    o.order_details, 
    m.master_name, 
    m.`salary`
FROM
    learning.master_order mo
        RIGHT JOIN
    learning.masters m ON m.order_id = mo.order_id
        RIGHT JOIN
    learning.orders o ON mo.master_id = o.master_id;
    
    -------------------------------------------------------------------
    #  RIGHT JOIN 1-M 
------------------------------------------------------------------
SELECT 
c.client_name, 
i.invoice_nr
FROM learning.`invoice` i
LEFT JOIN 
learning. `client`c ON  i.client_id = c.client_id;

-------------------------------------------------------------------
    # UNION JOIN M-M 
------------------------------------------------------------------
SELECT order_details FROM learning.orders
UNION
SELECT master_name FROM learning.masters;

-------------------------------------------------------------------
    # UNION JOIN 1-M 
------------------------------------------------------------------
SELECT invoice_nr FROM learning.invoice
UNION 
SELECT full_name FROM learning.driver;

-------------------------------------------------------------------
    # FULL JOIN 1-M 
------------------------------------------------------------------

SELECT
  m.master_id,
  m.master_name,
  o.order_id,
  o.order_details
FROM
  learning.masters m
LEFT JOIN learning.master_order mo ON m.master_id = mo.master_id
LEFT JOIN learning.orders o ON mo.order_id = o.order_id

UNION

SELECT
  m.master_id,
  m.master_name,
  o.order_id,
  o.order_details
FROM
  learning.masters m
RIGHT JOIN learning.master_order mo ON m.master_id = mo.master_id
RIGHT JOIN learning.orders o ON mo.order_id = o.order_id;

  ------------------------------------------------------------------
  # 3 Задача с занятия - продолжение:
 # добавляем колонку даты выплаты (одна выплата в месяц). Например, Петр 300 20% 12.11.2012, Петр 400 10% 12.12.2012. 
 # Вывести итоговые выплаты по месяцам за последний год. Для каждого работника вывести общую сумму выплат
 # ROLLUP https://dev.mysql.com/doc/refman/8.0/en/group-by-modifiers.html
 
 # выплат может быть несколько в одном месяце
-----------------------------------------------------------------

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
  master_name;


