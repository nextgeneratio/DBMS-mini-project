#!/bin/bash
# Test commands for all 14 stored procedures
# Run from the project root directory

DB_USER="root"
DB_PASS="Amjad@302"
DB_NAME="StudentManagement"

echo "======================================================"
echo "TESTING ALL 14 STORED PROCEDURES"
echo "======================================================"

# Test 1: sp_attendance_individual
echo ""
echo "TEST 1: sp_attendance_individual"
echo "Get individual student attendance across all courses"
mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "CALL sp_attendance_individual('2021001', NULL, 'combined');"

# Test 2: sp_attendance_summary_by_course
echo ""
echo "TEST 2: sp_attendance_summary_by_course"
echo "Get attendance summary for all students in a course"
mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "CALL sp_attendance_summary_by_course('ICT1212');"

# Test 3: sp_batch_attendance_summary
echo ""
echo "TEST 3: sp_batch_attendance_summary"
echo "Get batch attendance statistics (counts, averages)"
mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "CALL sp_batch_attendance_summary('ICT1212');"

# Test 4: sp_ca_marks_by_course
echo ""
echo "TEST 4: sp_ca_marks_by_course"
echo "Get CA marks for all students in a course"
mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "CALL sp_ca_marks_by_course('ICT1212');"

# Test 5: sp_ca_marks_individual
echo ""
echo "TEST 5: sp_ca_marks_individual"
echo "Get CA marks for specific student in a course"
mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "CALL sp_ca_marks_individual('ICT1212', 'ICT2023002');"

# Test 6: sp_check_eligibility_by_course
echo ""
echo "TEST 6: sp_check_eligibility_by_course"
echo "Check final exam eligibility (attendance >= 80% AND CA >= 35)"
mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "CALL sp_check_eligibility_by_course('ICT1212');"

# Test 7: sp_compute_grades_for_student
echo ""
echo "TEST 7: sp_compute_grades_for_student"
echo "Get all grades for a student with repeat rule applied"
mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "CALL sp_compute_grades_for_student('ICT2023002');"

# Test 8: sp_compute_sgpa
echo ""
echo "TEST 8: sp_compute_sgpa"
echo "Calculate semester GPA for a student"
mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "CALL sp_compute_sgpa('ICT2023002', '02');"

# Test 9: sp_compute_cgpa
echo ""
echo "TEST 9: sp_compute_cgpa"
echo "Calculate cumulative GPA for a student"
mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "CALL sp_compute_cgpa('ICT2023002');"

# Test 10: sp_batch_results_summary
echo ""
echo "TEST 10: sp_batch_results_summary"
echo "Get batch results (grade distribution, CA eligibility, GPA stats)"
mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "CALL sp_batch_results_summary('ICT1212', '02');"

# Test 11: sp_exec_sql
echo ""
echo "TEST 11: sp_exec_sql"
echo "Helper procedure for dynamic SQL (used internally by privilege procedures)"
mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "SELECT ROUTINE_NAME FROM information_schema.ROUTINES WHERE ROUTINE_NAME='sp_exec_sql';"

# Test 12: sp_assign_role
echo ""
echo "TEST 12: sp_assign_role"
echo "Assign role and privileges to existing user"
echo "Example: CALL sp_assign_role('lecturer', 'lect1', 'localhost', 'StudentManagement');"

# Test 13: sp_revoke_role
echo ""
echo "TEST 13: sp_revoke_role"
echo "Revoke role and privileges from user"
echo "Example: CALL sp_revoke_role('student', 's2021001', 'localhost', 'StudentManagement');"

# Test 14: sp_create_user_with_role
echo ""
echo "TEST 14: sp_create_user_with_role"
echo "Create user and assign role in one step"
mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "SELECT ROUTINE_NAME FROM information_schema.ROUTINES WHERE ROUTINE_NAME='sp_create_user_with_role';"

echo ""
echo "======================================================"
echo "ALL TESTS COMPLETED"
echo "======================================================"
