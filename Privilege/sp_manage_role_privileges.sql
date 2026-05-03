-- Dynamic procedures to assign and revoke role-based privileges.
-- These procedures build one SQL statement at a time and execute it using prepared statements.
-- Must be run by a MySQL account with sufficient privilege to GRANT/REVOKE (e.g., root).

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_exec_sql$$
CREATE PROCEDURE sp_exec_sql(IN in_sql LONGTEXT)
BEGIN
    SET @sql_text = in_sql;
    PREPARE stmt FROM @sql_text;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS sp_assign_role$$
CREATE PROCEDURE sp_assign_role(
    IN in_role VARCHAR(50),
    IN in_db_user VARCHAR(100),
    IN in_db_host VARCHAR(100),
    IN in_db_name VARCHAR(100)
)
BEGIN
    DECLARE user_ref VARCHAR(255);
    DECLARE grant_sql LONGTEXT;

    SET user_ref = CONCAT("'", REPLACE(in_db_user, "'", "''"), "'@'", REPLACE(in_db_host, "'", "''"), "'");

    IF LOWER(in_role) = 'student' THEN
        CALL sp_exec_sql(CONCAT('GRANT SELECT ON ', in_db_name, '.Final_Marks TO ', user_ref));
        CALL sp_exec_sql(CONCAT('GRANT SELECT ON ', in_db_name, '.Attendance TO ', user_ref));
    ELSEIF LOWER(in_role) = 'admin' THEN
        SET grant_sql = CONCAT('GRANT ALL PRIVILEGES ON ', in_db_name, '.* TO ', user_ref, ' WITH GRANT OPTION');
        CALL sp_exec_sql(grant_sql);
    ELSEIF LOWER(in_role) = 'dean' THEN
        SET grant_sql = CONCAT('GRANT ALL PRIVILEGES ON ', in_db_name, '.* TO ', user_ref);
        CALL sp_exec_sql(grant_sql);
    ELSEIF LOWER(in_role) = 'lecturer' THEN
        SET grant_sql = CONCAT('GRANT ALL PRIVILEGES ON ', in_db_name, '.* TO ', user_ref);
        CALL sp_exec_sql(grant_sql);
    ELSEIF LOWER(in_role) = 'technical_officer' THEN
        SET grant_sql = CONCAT('GRANT SELECT, INSERT, UPDATE ON ', in_db_name, '.Attendance TO ', user_ref);
        CALL sp_exec_sql(grant_sql);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Unknown role';
    END IF;
END$$

DROP PROCEDURE IF EXISTS sp_revoke_role$$
CREATE PROCEDURE sp_revoke_role(
    IN in_role VARCHAR(50),
    IN in_db_user VARCHAR(100),
    IN in_db_host VARCHAR(100),
    IN in_db_name VARCHAR(100)
)
BEGIN
    DECLARE user_ref VARCHAR(255);
    DECLARE revoke_sql LONGTEXT;

    SET user_ref = CONCAT("'", REPLACE(in_db_user, "'", "''"), "'@'", REPLACE(in_db_host, "'", "''"), "'");

    IF LOWER(in_role) = 'student' THEN
        CALL sp_exec_sql(CONCAT('REVOKE SELECT ON ', in_db_name, '.Final_Marks FROM ', user_ref));
        CALL sp_exec_sql(CONCAT('REVOKE SELECT ON ', in_db_name, '.Attendance FROM ', user_ref));
    ELSEIF LOWER(in_role) = 'admin' THEN
        SET revoke_sql = CONCAT('REVOKE ALL PRIVILEGES, GRANT OPTION FROM ', user_ref);
        CALL sp_exec_sql(revoke_sql);
    ELSEIF LOWER(in_role) = 'dean' THEN
        SET revoke_sql = CONCAT('REVOKE ALL PRIVILEGES FROM ', user_ref);
        CALL sp_exec_sql(revoke_sql);
    ELSEIF LOWER(in_role) = 'lecturer' THEN
        SET revoke_sql = CONCAT('REVOKE ALL PRIVILEGES ON ', in_db_name, '.* FROM ', user_ref);
        CALL sp_exec_sql(revoke_sql);
    ELSEIF LOWER(in_role) = 'technical_officer' THEN
        SET revoke_sql = CONCAT('REVOKE SELECT, INSERT, UPDATE ON ', in_db_name, '.Attendance FROM ', user_ref);
        CALL sp_exec_sql(revoke_sql);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Unknown role';
    END IF;
END$$

DELIMITER ;

-- Safety notes:
-- 1) Procedures use simple string concatenation. Ensure input values are trusted or sanitized.
-- 2) To remove a user's account entirely, use DROP USER (requires higher privileges).
-- 3) After GRANT/REVOKE, MySQL applies changes immediately; FLUSH PRIVILEGES is usually not needed for GRANT/REVOKE.
