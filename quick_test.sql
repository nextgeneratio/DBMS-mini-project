-- ============================================================
-- QUICK TEST COMMANDS FOR ALL 14 PROCEDURES
-- ============================================================
-- Usage: mysql -u root -pAmjad@302 StudentManagement < quick_test.sql

-- ============================================================
-- 1. sp_attendance_individual
-- Individual student attendance (by mode: 'theory', 'practical', 'combined')
-- ============================================================
SELECT '1. sp_attendance_individual - Individual Attendance' AS test;
CALL sp_attendance_individual('ICT2023001', NULL, 'combined');

-- ============================================================
-- 2. sp_attendance_summary_by_course
-- Batch attendance report for all students in a course
-- ============================================================
SELECT '2. sp_attendance_summary_by_course - Course Attendance Summary' AS test;
CALL sp_attendance_summary_by_course('ICT1212');

-- ============================================================
-- 3. sp_batch_attendance_summary
-- Attendance statistics (>=80%, <80%, with/without medical)
-- ============================================================
SELECT '3. sp_batch_attendance_summary - Attendance Statistics' AS test;
CALL sp_batch_attendance_summary('ICT1212');

-- ============================================================
-- 4. sp_ca_marks_by_course
-- Batch CA marks for all students in a course
-- ============================================================
SELECT '4. sp_ca_marks_by_course - Batch CA Marks' AS test;
CALL sp_ca_marks_by_course('ICT1212');

-- ============================================================
-- 5. sp_ca_marks_individual
-- Individual CA marks for specific student in a course
-- ============================================================
SELECT '5. sp_ca_marks_individual - Individual CA Marks' AS test;
CALL sp_ca_marks_individual('ICT1212', 'ICT2023002');

-- ============================================================
-- 6. sp_check_eligibility_by_course
-- Combined eligibility check (attendance >= 80% AND CA >= 35)
-- ============================================================
SELECT '6. sp_check_eligibility_by_course - Final Exam Eligibility' AS test;
CALL sp_check_eligibility_by_course('ICT1212');

-- ============================================================
-- 7. sp_compute_grades_for_student
-- Individual grades with repeat rule (cap at C if is_repeat=TRUE)
-- ============================================================
SELECT '7. sp_compute_grades_for_student - Student Grades' AS test;
CALL sp_compute_grades_for_student('ICT2023002');

-- ============================================================
-- 8. sp_compute_sgpa
-- Semester GPA (requires semester code)
-- ============================================================
SELECT '8. sp_compute_sgpa - Semester GPA' AS test;
CALL sp_compute_sgpa('ICT2023002', '02');

-- ============================================================
-- 9. sp_compute_cgpa
-- Cumulative GPA (all courses)
-- ============================================================
SELECT '9. sp_compute_cgpa - Cumulative GPA' AS test;
CALL sp_compute_cgpa('ICT2023002');

-- ============================================================
-- 10. sp_batch_results_summary
-- Returns 3 result sets:
--   1) Grade distribution (A, B, C, D, F, MC, WH counts)
--   2) CA eligibility (eligible, not eligible counts)
--   3) GPA statistics (SGPA/CGPA averages, min, max)
-- ============================================================
SELECT '10. sp_batch_results_summary - Grade Distribution & GPA Stats' AS test;
CALL sp_batch_results_summary('ICT1212', '02');

-- ============================================================
-- 11. sp_exec_sql
-- Helper procedure for dynamic SQL execution
-- ============================================================
SELECT '11. sp_exec_sql - Helper Procedure' AS test;
SELECT ROUTINE_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES 
WHERE ROUTINE_NAME='sp_exec_sql' AND ROUTINE_SCHEMA='StudentManagement';

-- ============================================================
-- 12. sp_assign_role
-- Assign role and privileges to existing user
-- Roles: 'admin', 'dean', 'lecturer', 'technical_officer', 'student'
-- ============================================================
SELECT '12. sp_assign_role - Assign Privileges' AS test;
SELECT 'Example: CALL sp_assign_role("lecturer", "lect1", "localhost", "StudentManagement");' AS command;

-- ============================================================
-- 13. sp_revoke_role
-- Revoke role and privileges from user
-- ============================================================
SELECT '13. sp_revoke_role - Revoke Privileges' AS test;
SELECT 'Example: CALL sp_revoke_role("student", "s2021001", "localhost", "StudentManagement");' AS command;

-- ============================================================
-- 14. sp_create_user_with_role
-- Create new database user and assign role in one step
-- ============================================================
SELECT '14. sp_create_user_with_role - Create User with Role' AS test;
SELECT ROUTINE_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES 
WHERE ROUTINE_NAME='sp_create_user_with_role' AND ROUTINE_SCHEMA='StudentManagement';

-- ============================================================
-- VERIFICATION: List all procedures
-- ============================================================
SELECT '' AS separator;
SELECT '============================================================' AS verification;
SELECT 'ALL PROCEDURES LOADED:' AS status;
SELECT '============================================================' AS verification;
SELECT COUNT(*) as total_procedures FROM information_schema.ROUTINES 
WHERE ROUTINE_SCHEMA='StudentManagement' AND ROUTINE_NAME LIKE 'sp_%';

SELECT ROUTINE_NAME FROM information_schema.ROUTINES 
WHERE ROUTINE_SCHEMA='StudentManagement' AND ROUTINE_NAME LIKE 'sp_%'
ORDER BY ROUTINE_NAME;
