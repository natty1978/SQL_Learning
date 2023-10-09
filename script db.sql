 скрипты для работы с данными:


добавление данных в таблицу
ALTER TABLE drivers
ADD contract_nr CHAR(9);

удаление данных
ALTER TABLE drivers
DROP COLUMN contract_data;

удаление таблицы
DROP TABLE if exists drivers
CASCADE;

добавление данных
INSERT INTO drivers (full_name)
VALUES ('Mr_Ivan_Ivanych');

удаление с условием
DELETE FROM drivers
WHERE full_name = 'Mr_Ivan_Ivanych';

редактировать данные
UPDATE drivers
SET full_name = 'Mr_Ivan_Ivanych'
WHERE full_name = 'Mr_Petr_Petrovich';

выбор с условием / сортировкой
SELECT * FROM drivers
WHERE status = 'international' 
ORDER BY full_name;
