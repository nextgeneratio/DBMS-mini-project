-- Detailed test showing actual procedure outputs

-- ============================================================
-- TEST 1: sp_ca_marks_individual - Specific student marks
-- ============================================================
SELECT '=== TEST 1: sp_ca_marks_individual ===' AS test_name;
CALL sp_ca_marks_individual('ICT1211', '2021001');

-- ============================================================
-- TEST 2: sp_compute_grades_for_student - Student grades
-- ============================================================
SELECT '=== TEST 2: sp_compute_grades_for_student ===' AS test_name;
CALL sp_compute_grades_for_student('2021001');

-- ============================================================
-- TEST 3: sp_compute_sgpa - Semester GPA
-- ============================================================
SELECT '=== TEST 3: sp_compute_sgpa ===' AS test_name;
CALL sp_compute_sgpa('2021001', '02');

-- ============================================================
-- TEST 4: sp_compute_cgpa - Cumulative GPA
-- ============================================================
SELECT '=== TEST 4: sp_compute_cgpa ===' AS test_name;
CALL sp_compute_cgpa('2021001');

-- ============================================================
-- TEST 5: sp_attendance_individual - Student attendance
-- ============================================================
SELECT '=== TEST 5: sp_attendance_individual ===' AS test_name;
CALL sp_attendance_individual('2021001', NULL, 'combined');

-- ============================================================
-- TEST 6: Show all available students and courses for reference
-- ============================================================
SELECT '=== REFERENCE: Available Students ===' AS info;
SELECT DISTINCT Std_Reg, Name FROM Student LIMIT 10;

SELECT '=== REFERENCE: Available Courses ===' AS info;
SELECT DISTINCT Course_ID, Name, Semester FROM Course LIMIT 10;

-- ============================================================
-- TEST 7: Check table row counts
-- ============================================================
SELECT '=== DATA SUMMARY ===' AS info;
SELECT 'Student' as table_name, COUNT(*) as row_count FROM Student
UNION ALL
SELECT 'Course', COUNT(*) FROM Course
UNION ALL
SELECT 'StudentCourse', COUNT(*) FROM StudentCourse
UNION ALL
SELECT 'Attendance', COUNT(*) FROM Attendance
UNION ALL
SELECT 'Score', COUNT(*) FROM Score
UNION ALL
SELECT 'Final_Marks', COUNT(*) FROM Final_Marks
UNION ALL
SELECT 'Procedures', COUNT(*) FROM information_schema.ROUTINES 
WHERE ROUTINE_SCHEMA='StudentManagement' AND ROUTINE_NAME LIKE 'sp_%';
