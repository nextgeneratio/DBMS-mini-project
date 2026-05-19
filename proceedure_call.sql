-- Procedure call script using seeded data from the Data folder.
-- These values were chosen to return rows from the existing dataset.

-- ============================================================
-- 1. Attendance for an individual student
-- ============================================================
SELECT '1. sp_attendance_individual' AS test;
CALL sp_attendance_individual('ICT2023001', NULL, 'combined');

-- ============================================================
-- 2. Attendance summary by course
-- ============================================================
SELECT '2. sp_attendance_summary_by_course' AS test;
CALL sp_attendance_summary_by_course('ICT1232');

-- ============================================================
-- 3. Batch attendance summary
-- ============================================================
SELECT '3. sp_batch_attendance_summary' AS test;
CALL sp_batch_attendance_summary('ICT1212');

-- ============================================================
-- 4. CA marks by course
-- ============================================================
SELECT '4. sp_ca_marks_by_course' AS test;
CALL sp_ca_marks_by_course('ICT1212');

-- ============================================================
-- 5. CA marks for an individual student
-- ============================================================
SELECT '5. sp_ca_marks_individual' AS test;
CALL sp_ca_marks_individual('ICT1212', 'ICT2023002');

-- ============================================================
-- 6. Eligibility check by course
-- ============================================================
SELECT '6. sp_check_eligibility_by_course' AS test;
CALL sp_check_eligibility_by_course('ICT1212');

-- ============================================================
-- 7. Compute grades for a student
-- ============================================================
SELECT '7. sp_compute_grades_for_student' AS test;
CALL sp_compute_grades_for_student('ICT2023002');

-- ============================================================
-- 8. Compute SGPA for a student
-- ============================================================
SELECT '8. sp_compute_sgpa' AS test;
CALL sp_compute_sgpa('ICT2023002', '02');

-- ============================================================
-- 9. Compute CGPA for a student
-- ============================================================
SELECT '9. sp_compute_cgpa' AS test;
CALL sp_compute_cgpa('ICT2023002');

-- ============================================================
-- 10. Batch results summary
-- ============================================================
SELECT '10. sp_batch_results_summary' AS test;
CALL sp_batch_results_summary('ICT1212', '02');
