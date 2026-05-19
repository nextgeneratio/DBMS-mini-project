-- Static GRANT statements for reference (run as MySQL root or a user with GRANT OPTION)
-- Replace 'username'@'host' with actual DB user and host (e.g., 'lecturer1'@'localhost')

-- Admin: All privileges WITH GRANT OPTION on the whole database
-- GRANT ALL PRIVILEGES ON StudentManagement.* TO 'admin_user'@'localhost' WITH GRANT OPTION;

-- Dean: All privileges without GRANT OPTION
-- GRANT ALL PRIVILEGES ON StudentManagement.* TO 'dean_user'@'localhost';

-- Lecturer: All privileges on tables (no user creation / no grant option)
-- GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, EXECUTE ON StudentManagement.* TO 'lecturer_user'@'localhost';

-- Technical Officer: read/write/update for attendance related tables/views
-- GRANT SELECT, INSERT, UPDATE, DELETE ON StudentManagement.Attendance TO 'to_user'@'localhost';
-- GRANT SELECT ON StudentManagement.Attendance TO 'to_user'@'localhost';

-- Student: read permission for final attendance and final marks/Grades tables/views
-- GRANT SELECT ON StudentManagement.Final_Marks TO 'student_user'@'localhost';
-- GRANT SELECT ON StudentManagement.Attendance TO 'student_user'@'localhost';

-- Note: Use the dynamic stored procedures in sp_manage_role_privileges.sql for safer programmatic assignment.
