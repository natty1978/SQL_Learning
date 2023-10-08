ALTER TABLE drivers
ADD contract_nr CHAR(9);

ALTER TABLE drivers
CHANGE contract_nr contract_data DATE;

ALTER TABLE drivers
DROP COLUMN contract_data;

DROP TABLE if exists drivers
CASCADE;

INSERT INTO drivers (full_name)
VALUES ('Mr_Ivan_Ivanych');

DELETE FROM drivers
WHERE full_name = 'Mr_Ivan_Ivanych';

UPDATE drivers
SET full_name = 'Mr_Ivan_Ivanych'
WHERE full_name = 'Mr_Petr_Petrovich';

SELECT * FROM drivers
WHERE status = 'international' ;