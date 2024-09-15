Cкрипты на редактирование схемы:

На создание БД
CREATE DATABASE transport_company;

создание таблицы
CREATE TABLE if not exists drivers
 (
    driver_id INT, auto_increment INT primary key unique, 
    full_name VARCHAR(120), 
    license_nr VARCHAR(50), 
    status enum ('domestic', 'international'),
    phone VARCHAR(50),
    FOREIGN KEY (truck_nr) REFERENCES trucks(truck_nr) on delete cascade );
    
    переименование таблицы 
RENAME TABLE drivers TO staff;

связь M-M (через доп. таблицу driver-truck - то есть в дополнение к первой drivers еще + 2 таблицы создаю: trucks 3) driver_truck)
CREATE TABLE if not exists trucks
 (
    truck_nr INT,  primary key
    model_truck VARCHAR(50),
    truck_type enum ('tent', 'frigo'),
    insurance_nr VARCHAR(50), unique not null, 
    year INT unique not null, 
FOREIGN KEY (truck_nr) REFERENCES trucks(truck_nr) on delete cascade
);

CREATE TABLE driver_truck (
    driver_id INT,
    truck_nr CHAR(12),
    PRIMARY KEY (driver_id, truck_nr),
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
    FOREIGN KEY (truck_nr) REFERENCES trucks(truck_nr)
);
добавление колонки в таблицу
ALTER TABLE drivers
ADD contract_nr INT;

переименование колонки
ALTER TABLE drivers
CHANGE contract_nr contract_data INT;

удаление колонки
ALTER TABLE drivers
DROP COLUMN contract_data;

удаление таблицы

DROP TABLE drivers;





