CREATE DATABASE transport_company;

CREATE TABLE if not exists drivers
 (
    driver_id INT, auto_increment INT primary key unique, 
    full_name VARCHAR(120), 
    license_nr VARCHAR(50), 
    status enum ('domestic', 'international'),
    phone VARCHAR(50),
    FOREIGN KEY (truck_nr) REFERENCES trucks(truck_nr) on delete cascade );
RENAME TABLE drivers TO staff;

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






