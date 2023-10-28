---------------------------------------------------------------
# без промежуточной таблицы - триггер для  удаление мастера
--------------------------------------------------------------
CREATE DEFINER = CURRENT_USER TRIGGER `learning`.`Masters_AFTER_DELETE` AFTER DELETE ON `Masters` FOR EACH ROW
BEGIN
    DECLARE minimum_work_master_id INT;

    # ищу мастера с мин. количеством заказов
    SELECT IFNULL ( (SELECT fk_master_id FROM Orders
         WHERE fk_master_id <> OLD.master_id
         GROUP BY fk_master_id
         ORDER BY COUNT(*) 
         LIMIT 1), 0) INTO minimum_work_master_id;

   # Переназначаю заказы
    UPDATE Orders
    SET fk_master_id = minimum_work_master_id
    WHERE fk_master_id = OLD.master_id;
END;
-----------------------------------
# Триггер для добавления заказа
------------------------------------
CREATE DEFINER = CURRENT_USER TRIGGER `learning`.`Orders_AFTER_INSERT` AFTER INSERT ON `Orders` FOR EACH ROW
BEGIN
    DECLARE minimum_work_master_id INT;

    SELECT IFNULL(
        (SELECT fk_master_id
         FROM Orders
         GROUP BY fk_master_id
         ORDER BY COUNT(*) 
         LIMIT 1), 0) INTO minimum_work_master_id;

    UPDATE Orders
    SET fk_master_id = minimum_work_master_id
    WHERE order_id = NEW.order_id;
END;

--------------------------------
# теперь c промежуточной таблицей
--------------------------------
# триггер  для мастеров при удалении - переназначение заказа

CREATE DEFINER = CURRENT_USER TRIGGER `learning`.`masters_AFTER_DELETE` AFTER DELETE ON `masters` FOR EACH ROW
BEGIN
DECLARE minimum_work_master_id INT;

    SELECT IFNULL(
        (SELECT mo.master_id
         FROM master_orders mo
         WHERE mo.master_id != OLD.master_id
         GROUP BY mo.master_id
         ORDER BY COUNT(mo.order_id)
         LIMIT 1), 0) INTO minimum_work_master_id;

   # Переназнааю заказы на мастера с минимальной загрузкой
    UPDATE master_orders
    SET master_id = minimum_work_master_id
    WHERE master_id = OLD.master_id;
END; 
---------------------------------------------------
# триггер для ордеров  при создании нового заказа - переназначение
-----------------------------------------------------
CREATE DEFINER = CURRENT_USER TRIGGER `learning`.`orders_AFTER_INSERT` AFTER INSERT ON `orders` FOR EACH ROW
BEGIN
DECLARE least_loaded_master_id INT;

    SELECT IFNULL(
        (SELECT mo.master_id
         FROM master_orders mo
         GROUP BY mo.master_id
         ORDER BY COUNT(mo.order_id)
         LIMIT 1), 0) INTO minimum_work_master_id;

    INSERT INTO master_orders (order_id, master_id)
    VALUES (NEW.order_id, minimum_work_master_id);
    END;


