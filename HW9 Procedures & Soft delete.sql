# ПРОЦЕДУРЫ (5)

# 1 CREATE USER:

CREATE DEFINER=`learninguser`@`%` PROCEDURE `create_user`(
    IN p_name VARCHAR(255),
    IN p_id INT,
    IN p_birthday DATE
)
BEGIN
    INSERT INTO users (`name`, id, birthday)
    VALUES (p_name, p_id, p_birthdate);

    SELECT LAST_INSERT_ID() as new_user_id;
END

CALL create_user_new ('Nick', 4, '1991-01-01');


# 2 READ - вывод пользователей с д.р. позже 1990 г.

CREATE DEFINER=`learninguser`@`%` PROCEDURE `users_after_1990`()
BEGIN
    SELECT id, user_name
    FROM users
    WHERE date (birthday) > 1990 AND is_deleted is null;
END

CALL users_after_1990 ();


# 3 READALL  -  возврат только ВСЕХ не удаленных через soft delete пользователей

CREATE DEFINER=`learninguser`@`%` PROCEDURE `read_undeleted_user`()
BEGIN
    SELECT id, user_name , birthday
    FROM users
    WHERE is_deleted is NULL;
END

CALL read_undeleted_user ();


# 4 UPDATE USER PHONE

CREATE DEFINER=`learninguser`@`%` PROCEDURE `update_user_phone`(IN p_id INT, IN p_new_phone varchar (45))
BEGIN
    UPDATE users
    SET  phone = p_new_phone
    WHERE id = p_id;
END

CALL update_user_phone (1, 37533445920);


# 5 DELETE USER:

CREATE DEFINER=`learninguser`@`%` PROCEDURE `usp_user_delete`(IN id_to_delete INT)
BEGIN 
UPDATE users u SET u.is_deleted = 1
WHERE u.id = id_to_delete;
END

CALL usp_user_delete(4);


# Перемещение в архив

# Шаг 1 - создание таблицы  архива

CREATE TABLE users_archive (
    id INT NOT NULL PRIMARY KEY,
    user_name VARCHAR(50),
    birthday DATE,
    is_deleted TINYINT
);

# Шаг 2 - назначение процедуры для перемещения, указывая данные для перемещения

CREATE DEFINER=`learninguser`@`%` PROCEDURE `user_archivate`(IN p_id INT)
BEGIN
    INSERT INTO users_archive (id, user_name, birthday, is_deleted)
    SELECT id, user_name, birthday, is_deleted
    FROM users
    WHERE id = p_id;

    DELETE FROM users
    WHERE id = p_id;
END

# Шаг 3 - вызов процедуры

CALL user_archivate (4);

