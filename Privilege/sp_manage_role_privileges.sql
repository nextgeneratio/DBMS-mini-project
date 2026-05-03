-- Dynamic procedures to assign and revoke role-based privileges
-- These procedures construct GRANT/REVOKE statements and execute them via prepared statements.
-- Must be run by a MySQL account with sufficient privilege to GRANT/REVOKE (e.g., root)

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_assign_role$$
CREATE PROCEDURE sp_assign_role(
    IN in_role VARCHAR(50),
    IN in_db_user VARCHAR(100),
    IN in_db_host VARCHAR(100),
    IN in_db_name VARCHAR(100)
)
BEGIN
    DECLARE stm TEXT;
    SET @user = CONCAT("'", REPLACE(in_db_user, "'", "''"), "'@'", REPLACE(in_db_host, "'", "''"), "'");

    CASE LOWER(in_role)
        WHEN 'admin' THEN
            SET stm = CONCAT('GRANT ALL PRIVILEGES ON ', in_db_name, '.* TO ', @user, ' WITH GRANT OPTION');
        WHEN 'dean' THEN
            SET stm = CONCAT('GRANT ALL PRIVILEGES ON ', in_db_name, '.* TO ', @user);
        WHEN 'lecturer' THEN
            SET stm = CONCAT('GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, EXECUTE ON ', in_db_name, '.* TO ', @user);
        WHEN 'technical_officer' THEN
            SET stm = CONCAT('GRANT SELECT, INSERT, UPDATE, DELETE ON ', in_db_name, '.Attendance TO ', @user);
        WHEN 'student' THEN
            SET stm = CONCAT('GRANT SELECT ON ', in_db_name, '.Final_Marks TO ', @user, '; GRANT SELECT ON ', in_db_name, '.Attendance TO ', @user);
        ELSE
            SET stm = CONCAT('-- Unknown role: ', in_role);
    END CASE;

    IF LEFT(stm,2) <> '--' THEN
        PREPARE ps FROM stm;
        EXECUTE ps;
        DEALLOCATE PREPARE ps;
    ELSE
        SELECT stm AS message;
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
    DECLARE stm TEXT;
    SET @user = CONCAT("'", REPLACE(in_db_user, "'", "''"), "'@'", REPLACE(in_db_host, "'", "''"), "'");

    CASE LOWER(in_role)
        WHEN 'admin' THEN
            SET stm = CONCAT('REVOKE ALL PRIVILEGES, GRANT OPTION FROM ', @user);
        WHEN 'dean' THEN
            SET stm = CONCAT('REVOKE ALL PRIVILEGES FROM ', @user);
        WHEN 'lecturer' THEN
            SET stm = CONCAT('REVOKE SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, EXECUTE ON ', in_db_name, '.* FROM ', @user);
        WHEN 'technical_officer' THEN
            SET stm = CONCAT('REVOKE SELECT, INSERT, UPDATE, DELETE ON ', in_db_name, '.Attendance FROM ', @user);
        WHEN 'student' THEN
            SET stm = CONCAT('REVOKE SELECT ON ', in_db_name, '.Final_Marks FROM ', @user, '; REVOKE SELECT ON ', in_db_name, '.Attendance FROM ', @user);
        ELSE
            SET stm = CONCAT('-- Unknown role: ', in_role);
    END CASE;

    IF LEFT(stm,2) <> '--' THEN
        PREPARE ps FROM stm;
        EXECUTE ps;
        DEALLOCATE PREPARE ps;
    ELSE
        SELECT stm AS message;
    END IF;
END$$

DELIMITER ;

-- Safety notes:
-- 1) Procedures use simple string concatenation. Ensure input values are trusted or sanitized.
-- 2) To remove a user's account entirely, use DROP USER (requires higher privileges).
-- 3) After GRANT/REVOKE, consider running FLUSH PRIVILEGES if needed (MySQL usually applies GRANT immediately).
