---------------------------------
# создала процедуру
-------------------------------------
CREATE DEFINER=`learninguser`@`%` PROCEDURE `read_all_new`(IN include_historical_data TINYINT)
BEGIN
    SET @sql_query = NULL;

    IF include_historical_data = 1 THEN
        SET @sql_query = 'SELECT * FROM learning.orders UNION SELECT * FROM learning.order_history;';
    ELSE
        SET @sql_query = 'SELECT * FROM learning.orders;';
    END IF;

    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;

# вызов 
CALL read_all_new(1);
-----------------------------------
# UPDATE с использованием PREPARE
------------------------------------
CREATE DEFINER=`learninguser`@`%` PROCEDURE `update_orders_new`(IN order_id INT, IN order_details VARCHAR(45))
BEGIN
    SET @sql_query = CONCAT('UPDATE learning.orders SET order_details = "repair", order_costs = 100 WHERE id = 2');
    
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt USING @order_details, @order_id;
    DEALLOCATE PREPARE stmt;
END; 
# вызов 
CALL update_orders_new(2, 'repair');
--------------------------------------------
#  выборка данных из таблицы orders
-------------------------------------------
CREATE DEFINER=`learninguser`@`%` PROCEDURE `select_data`(IN order_details VARCHAR(45))
BEGIN
    SET @sql_query = CONCAT('SELECT * FROM learning.orders WHERE ', oder_details="repair"';');
    
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;
#вызов
CALL select_data('repair');
-------------------------------------
ФИБОНАЧЧИ ПОКАЗАЛА НА ЗАНЯТИИ
CREATE FUNCTION calcuate_fibonacci_number(n INT) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE a INT DEFAULT 0;
    DECLARE b INT DEFAULT 1;
    DECLARE fibonacci INT;

    IF n = 1 THEN
        RETURN n;
    END IF;

    SET n = n - 1;

    WHILE n > 0 DO
        SET fibonacci = a + b;
        SET a = b;
        SET b = fibonacci;
        SET n = n - 1;
    END WHILE;

    RETURN fibonacci;
END; 
-----------------------------
# если через рекурсию:
------------------------------
CREATE FUNCTION calculate_fibonacci_number_recursive(n INT) RETURNS INT
READS SQL DATA
BEGIN
    IF n = 1 THEN
        RETURN n;
    ELSE
        RETURN calculate_fibonacci_number_recursive(n - 1) + calculate_fibonacci_number_recursive(n - 2);
    END IF;
END;
SELECT calculate_fibonacci_number_recursive(5) AS Result;
-------------------------------------------------------------

WITH RECURSIVE folder_paths AS ( SELECT folder_id, `name`, parent_id,
    CAST(`name` AS VARCHAR(45)) AS full_path
  FROM
    learning.folders
  WHERE
    parent_id IS NULL
  UNION ALL
  SELECT
    f.folder_id,
    f.`name`,
    f.parent_id,
    CONCAT(fp.full_path, '/', f.`name`) AS full_path
  FROM
    learning.folders f
  JOIN
    folder_paths fp ON f.parent_id = fp.folder_id
)

SELECT
  folder_id,
  `name`,
  full_path
FROM
  folder_paths;