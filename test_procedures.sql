-- Comprehensive test file for all 14 stored procedures

-- Get a sample student and course ID first
SELECT @student_id := Std_Reg FROM Student LIMIT 1;
SELECT @course_id := Course_ID FROM Course LIMIT 1;
SELECT @semester := Semester FROM Course LIMIT 1;

-- ============================================================
-- TEST 1: sp_attendance_individual
-- ============================================================
SELECT '=== TEST 1: sp_attendance_individual ===' AS test;
CALL sp_attendance_individual('2021001', NULL, 'combined');

-- ============================================================
-- TEST 2: sp_attendance_summary_by_course
-- ============================================================
SELECT '=== TEST 2: sp_attendance_summary_by_course ===' AS test;
CALL sp_attendance_summary_by_course('ICT1211');

-- ============================================================
-- TEST 3: sp_batch_attendance_summary
-- ============================================================
SELECT '=== TEST 3: sp_batch_attendance_summary ===' AS test;
CALL sp_batch_attendance_summary('ICT1211');

-- ============================================================
-- TEST 4: sp_ca_marks_by_course
-- ============================================================
SELECT '=== TEST 4: sp_ca_marks_by_course ===' AS test;
CALL sp_ca_marks_by_course('ICT1211');

-- ============================================================
-- TEST 5: sp_ca_marks_individual
-- ============================================================
SELECT '=== TEST 5: sp_ca_marks_individual ===' AS test;
CALL sp_ca_marks_individual('ICT1211', '2021001');

-- ============================================================
-- TEST 6: sp_check_eligibility_by_course
-- ============================================================
SELECT '=== TEST 6: sp_check_eligibility_by_course ===' AS test;
CALL sp_check_eligibility_by_course('ICT1211');

-- ============================================================
-- TEST 7: sp_compute_grades_for_student
-- ============================================================
SELECT '=== TEST 7: sp_compute_grades_for_student ===' AS test;
CALL sp_compute_grades_for_student('2021001');

-- ============================================================
-- TEST 8: sp_compute_sgpa
-- ============================================================
SELECT '=== TEST 8: sp_compute_sgpa ===' AS test;
CALL sp_compute_sgpa('2021001', '02');

-- ============================================================
-- TEST 9: sp_compute_cgpa
-- ============================================================
SELECT '=== TEST 9: sp_compute_cgpa ===' AS test;
CALL sp_compute_cgpa('2021001');

-- ============================================================
-- TEST 10: sp_batch_results_summary
-- ============================================================
SELECT '=== TEST 10: sp_batch_results_summary ===' AS test;
CALL sp_batch_results_summary('ICT1211', '02');

-- ============================================================
-- TEST 11: sp_exec_sql (helper procedure)
-- ============================================================
SELECT '=== TEST 11: sp_exec_sql (helper) ===' AS test;
-- This is a helper procedure - verify it exists
SELECT ROUTINE_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES 
WHERE ROUTINE_NAME = 'sp_exec_sql' AND ROUTINE_SCHEMA = 'StudentManagement';

-- ============================================================
-- TEST 12: sp_assign_role
-- ============================================================
SELECT '=== TEST 12: sp_assign_role ===' AS test;
-- This procedure modifies user privileges - display helper info
SELECT ROUTINE_NAME FROM information_schema.ROUTINES 
WHERE ROUTINE_NAME = 'sp_assign_role' AND ROUTINE_SCHEMA = 'StudentManagement';

-- ============================================================
-- TEST 13: sp_revoke_role
-- ============================================================
SELECT '=== TEST 13: sp_revoke_role ===' AS test;
SELECT ROUTINE_NAME FROM information_schema.ROUTINES 
WHERE ROUTINE_NAME = 'sp_revoke_role' AND ROUTINE_SCHEMA = 'StudentManagement';

-- ============================================================
-- TEST 14: sp_create_user_with_role
-- ============================================================
SELECT '=== TEST 14: sp_create_user_with_role ===' AS test;
SELECT ROUTINE_NAME FROM information_schema.ROUTINES 
WHERE ROUTINE_NAME = 'sp_create_user_with_role' AND ROUTINE_SCHEMA = 'StudentManagement';

-- ============================================================
-- Summary of all procedures loaded
-- ============================================================
SELECT '=== SUMMARY: All Procedures Loaded ===' AS test;
SELECT COUNT(*) as total_procedures FROM information_schema.ROUTINES 
WHERE ROUTINE_SCHEMA = 'StudentManagement' AND ROUTINE_NAME LIKE 'sp_%';

SELECT ROUTINE_NAME FROM information_schema.ROUTINES 
WHERE ROUTINE_SCHEMA = 'StudentManagement' AND ROUTINE_NAME LIKE 'sp_%'
ORDER BY ROUTINE_NAME;
