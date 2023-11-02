# ВЬЮШКИ
# создание c использованием join
-----------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `learninguser`@`%` 
    SQL SECURITY DEFINER
VIEW `learning`.`master_order_view` AS
    SELECT 
        `m`.`master_id` AS `master_id`,
        `m`.`master_name` AS `master_name`,
        `m`.`salary` AS `salary`,
        `o`.`order_id` AS `order_id`,
        `o`.`order_details` AS `order_details`
    FROM
        (`learning`.`masters` `m`
        JOIN `learning`.`orders` `o` ON ((`m`.`master_id` = `o`.`master_id`)))
  
  ------------------------------
  # SELECT
 ------------------------------- 
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `learninguser`@`%` 
    SQL SECURITY DEFINER
VIEW `learning`.`master_select` AS
    SELECT 
        `learning`.`masters`.`master_id` AS `master_ID`,
        `learning`.`masters`.`master_name` AS `master_name`,
        `learning`.`masters`.`salary` AS `salary`
    FROM
        `learning`.`masters`

SELECT * FROM master_select;

------------------------------
  # INSERT
 -----------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `learninguser`@`%` 
    SQL SECURITY DEFINER
VIEW `learning`.`master_insert` AS
    SELECT 
        `learning`.`masters`.`master_id` AS `master_ID`,
        `learning`.`masters`.`master_name` AS `master_name`,
        `learning`.`masters`.`salary` AS `salary`
    FROM
        `learning`.`masters`
  
INSERT INTO master_insert (master_ID, master_name, salary)
VALUES (1, 'Mike', 1000); 
  
------------------------------
  # UPDATE
 -----------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `learninguser`@`%` 
    SQL SECURITY DEFINER
VIEW `learning`.`master_update` AS
    SELECT 
        `learning`.`masters`.`master_id` AS `master_ID`,
        `learning`.`masters`.`master_name` AS `master_name`,
        `learning`.`masters`.`salary` AS `salary`
    FROM
        `learning`.`masters`

UPDATE master_update
SET master_name = 'Nick'
WHERE master_ID = 1;
 
 ------------------------------
  # DELETE
 -----------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `learninguser`@`%` 
    SQL SECURITY DEFINER
VIEW `learning`.`master_delete` AS
    SELECT 
        `learning`.`masters`.`master_id` AS `master_ID`,
        `learning`.`masters`.`master_name` AS `master_name`,
        `learning`.`masters`.`salary` AS `salary`
    FROM
        `learning`.`masters`
 
DELETE FROM master_delete
WHERE master_ID = 1;

  --------------------------------------------------
 Задание 2  - процедура (показать отсутствие заказа)
 ----------------------------------------------------
CREATE DEFINER=`learninguser`@`%` PROCEDURE `order_status`()
BEGIN
    SELECT
        o.order_id,
        o.order_description,
        CASE
            WHEN o.status IN ('urgent', 'active') THEN m.master_name
            WHEN o.status IN ('pending', 'canceled') THEN o.status_timestamp
        END AS worker_or_status
    FROM
        Learning.orders o
    LEFT JOIN
        Learning.masters m ON o.master_id = m.master_id;

    IF NOT EXISTS (SELECT 1 FROM learning.orders) THEN
        SELECT 'No_orders';
    END IF;
END
    
    CALL learning.order_status();

    ----------------------
   # ПОЕЗДА
    ----------------------
   таблица для станций
CREATE TABLE IF NOT EXISTS learning.stations (
    station_id INT AUTO_INCREMENT PRIMARY KEY,
    station_name VARCHAR(255) NOT NULL
);

#  поезда
CREATE TABLE IF NOT EXISTS learning.trains (
    train_id INT AUTO_INCREMENT PRIMARY KEY,
    train_number INT NOT NULL,
    train_name VARCHAR(255) NOT NULL
);

#  расписание поездов
CREATE TABLE IF NOT EXISTS learning.trains_schedules (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    station_name VARCHAR(255) NOT NULL,
    arrival_time TIME NOT NULL,
    train_id INT NOT NULL,
    FOREIGN KEY (station_name) REFERENCES stations(station_name),
    FOREIGN KEY (train_id) REFERENCES trains(train_id)
);
    #  через join 
    SELECT
    CONCAT_WS(' - ', s1.station_name, s2.station_name) AS route,
    TIMEDIFF(s2.arrival_time, s1.arrival_time) AS time_spent,
    ts.train_id AS train_number
FROM
    learning.trains_schedules AS ts
JOIN
    learning.trains_schedules AS s1 ON ts.train_id = s1.train_id
JOIN
    learning.trains_schedules AS s2 ON ts.train_id = s2.train_id
    AND s1.arrival_time = (SELECT MIN(arrival_time) FROM learning.trains_schedules WHERE train_id = ts.train_id)
    AND s2.arrival_time = (SELECT MAX(arrival_time) FROM learning.trains_schedules WHERE train_id = ts.train_id)
GROUP BY
    ts.train_id;
    