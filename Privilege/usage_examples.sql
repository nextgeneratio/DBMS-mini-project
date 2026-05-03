-- Usage examples for role assignment procedures
-- Load this file as root or a superuser with GRANT privileges

-- Example: assign admin role to user 'admin1'@'localhost'
-- CALL sp_assign_role('admin','admin1','localhost','StudentManagement');

-- Example: assign dean role
-- CALL sp_assign_role('dean','dean1','localhost','StudentManagement');

-- Example: assign lecturer role
-- CALL sp_assign_role('lecturer','lect1','localhost','StudentManagement');

-- Example: assign technical officer role
-- CALL sp_assign_role('technical_officer','to1','localhost','StudentManagement');

-- Example: assign student read-only role
-- CALL sp_assign_role('student','s2021001','localhost','StudentManagement');

-- Revoke examples:
-- CALL sp_revoke_role('lecturer','lect1','localhost','StudentManagement');

-- Note: replace usernames and hosts as per your MySQL user accounts.
