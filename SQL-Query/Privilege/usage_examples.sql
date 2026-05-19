-- Usage examples for role and user management procedures
-- Load all procedure files BEFORE running these examples:
--   mysql -u root -p StudentManagement < "Privilege/sp_manage_role_privileges.sql"
--   mysql -u root -p StudentManagement < "Privilege/sp_create_user_with_role.sql"

-- =============================================================================
-- OPTION 1: Create users and assign roles in one call (RECOMMENDED)
-- =============================================================================

-- Create ADMIN user and assign admin role
-- CALL sp_create_user_with_role('admin','admin1','localhost','admin_password_123','StudentManagement');

-- Create DEAN user and assign dean role
-- CALL sp_create_user_with_role('dean','dean1','localhost','dean_password_456','StudentManagement');

-- Create multiple LECTURER users
-- CALL sp_create_user_with_role('lecturer','lect1','localhost','lect1_pass','StudentManagement');
-- CALL sp_create_user_with_role('lecturer','lect2','localhost','lect2_pass','StudentManagement');
-- CALL sp_create_user_with_role('lecturer','lect3','localhost','lect3_pass','StudentManagement');

-- Create multiple TECHNICAL OFFICER users
-- CALL sp_create_user_with_role('technical_officer','to1','localhost','to1_pass','StudentManagement');
-- CALL sp_create_user_with_role('technical_officer','to2','localhost','to2_pass','StudentManagement');

-- Create multiple STUDENT users (read-only on final marks and attendance)
-- CALL sp_create_user_with_role('student','s2021001','localhost','student_pass','StudentManagement');
-- CALL sp_create_user_with_role('student','s2021002','localhost','student_pass','StudentManagement');
-- CALL sp_create_user_with_role('student','s2021003','localhost','student_pass','StudentManagement');

-- =============================================================================
-- OPTION 2: Two-step process (create user manually, then assign role)
-- =============================================================================

-- Step 1: Create user first (only run once per user)
-- CREATE USER 'lecturer_new'@'localhost' IDENTIFIED BY 'secure_password';

-- Step 2: Assign role
-- CALL sp_assign_role('lecturer','lecturer_new','localhost','StudentManagement');

-- =============================================================================
-- REVOKING ROLES (remove all privileges)
-- =============================================================================

-- Revoke lecturer role
-- CALL sp_revoke_role('lecturer','lect1','localhost','StudentManagement');

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================

-- View all database users
-- SELECT user, host FROM mysql.user WHERE host != 'localhost' OR user != 'root';

-- Check privileges for a specific user
-- SHOW GRANTS FOR 'lect1'@'localhost';
-- SHOW GRANTS FOR 'to1'@'localhost';
-- SHOW GRANTS FOR 's2021001'@'localhost';

-- =============================================================================
-- NOTES
-- =============================================================================
-- 1. All procedures must be run as root or a user with GRANT privileges.
-- 2. Passwords should be strong and never shared in plain text.
-- 3. After creating users and assigning roles, test login:
--    mysql -u lect1 -p StudentManagement  (and enter password)
-- 4. If you need to change a password:
--    ALTER USER 'username'@'localhost' IDENTIFIED BY 'new_password';
-- 5. To drop a user entirely:
--    DROP USER 'username'@'localhost';
