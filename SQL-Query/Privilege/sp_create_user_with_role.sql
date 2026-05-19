-- Combined procedure to CREATE USER (if not exists) and ASSIGN ROLE in one call
-- This simplifies the two-step process and reduces manual work
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_create_user_with_role$$
CREATE PROCEDURE sp_create_user_with_role(
    IN in_role VARCHAR(50),
    IN in_db_user VARCHAR(100),
    IN in_db_host VARCHAR(100),
    IN in_password VARCHAR(100),
    IN in_db_name VARCHAR(100)
)
BEGIN
    DECLARE user_ref VARCHAR(255);
    DECLARE create_sql LONGTEXT;
    DECLARE user_exists INT DEFAULT 0;

    SET user_ref = CONCAT("'", REPLACE(in_db_user, "'", "''"), "'@'", REPLACE(in_db_host, "'", "''"), "'");

    -- Check if user already exists
    SELECT COUNT(*) INTO user_exists FROM mysql.user WHERE user = in_db_user AND host = in_db_host;

    -- Create user if not exists
    IF user_exists = 0 THEN
        SET create_sql = CONCAT('CREATE USER ', user_ref, ' IDENTIFIED BY ''', REPLACE(in_password, "'", "''"), '''');
        CALL sp_exec_sql(create_sql);
    END IF;

    -- Assign role
    CALL sp_assign_role(in_role, in_db_user, in_db_host, in_db_name);

END$$
DELIMITER ;
