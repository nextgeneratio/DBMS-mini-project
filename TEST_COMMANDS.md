# PROCEDURE TEST COMMANDS

## Quick Reference - Copy & Paste These Commands

### Prerequisites
```bash
cd /mnt/storage/Coding/Group\ Project/DBMS-mini-project
```

---

## Individual Test Commands

### 1. sp_attendance_individual
**Get individual student attendance across all courses**
```bash
mysql -u root -pAmjad@302 StudentManagement -e "CALL sp_attendance_individual('ICT2023001', NULL, 'combined');"
```

### 2. sp_attendance_summary_by_course
**Get attendance summary for all students in a course**
```bash
mysql -u root -pAmjad@302 StudentManagement -e "CALL sp_attendance_summary_by_course('ICT1212');"
```

### 3. sp_batch_attendance_summary
**Get batch attendance statistics (counts, averages)**
```bash
mysql -u root -pAmjad@302 StudentManagement -e "CALL sp_batch_attendance_summary('ICT1212');"
```

### 4. sp_ca_marks_by_course
**Get CA marks for all students in a course**
```bash
mysql -u root -pAmjad@302 StudentManagement -e "CALL sp_ca_marks_by_course('ICT1212');"
```

### 5. sp_ca_marks_individual
**Get CA marks for specific student in a course**
```bash
mysql -u root -pAmjad@302 StudentManagement -e "CALL sp_ca_marks_individual('ICT1212', 'ICT2023002');"
```

### 6. sp_check_eligibility_by_course
**Check final exam eligibility (attendance >= 80% AND CA >= 35)**
```bash
mysql -u root -pAmjad@302 StudentManagement -e "CALL sp_check_eligibility_by_course('ICT1212');"
```

### 7. sp_compute_grades_for_student
**Get all grades for a student with repeat rule applied**
```bash
mysql -u root -pAmjad@302 StudentManagement -e "CALL sp_compute_grades_for_student('ICT2023002');"
```

### 8. sp_compute_sgpa
**Calculate semester GPA for a student**
```bash
mysql -u root -pAmjad@302 StudentManagement -e "CALL sp_compute_sgpa('ICT2023002', '02');"
```

### 9. sp_compute_cgpa
**Calculate cumulative GPA for a student**
```bash
mysql -u root -pAmjad@302 StudentManagement -e "CALL sp_compute_cgpa('ICT2023002');"
```

### 10. sp_batch_results_summary
**Get batch results (3 result sets: grades, CA eligibility, GPA stats)**
```bash
mysql -u root -pAmjad@302 StudentManagement -e "CALL sp_batch_results_summary('ICT1212', '02');"
```

### 11. sp_exec_sql
**Verify helper procedure exists**
```bash
mysql -u root -pAmjad@302 StudentManagement -e "SELECT ROUTINE_NAME FROM information_schema.ROUTINES WHERE ROUTINE_NAME='sp_exec_sql';"
```

### 12. sp_assign_role
**Assign role and privileges to existing user**
```bash
mysql -u root -pAmjad@302 StudentManagement -e "CALL sp_assign_role('lecturer', 'lect1', 'localhost', 'StudentManagement');"
```

### 13. sp_revoke_role
**Revoke role and privileges from user**
```bash
mysql -u root -pAmjad@302 StudentManagement -e "CALL sp_revoke_role('student', 's2021001', 'localhost', 'StudentManagement');"
```

### 14. sp_create_user_with_role
**Create user and assign role in one step**
```bash
mysql -u root -pAmjad@302 StudentManagement -e "CALL sp_create_user_with_role('student', 'newstudent', 'localhost', 'pass123', 'StudentManagement');"
```

---

## Run All Tests at Once

### Option 1: Using SQL file
```bash
mysql -u root -pAmjad@302 StudentManagement < quick_test.sql
```

### Option 2: Using bash script
```bash
bash run_tests.sh
```

---

## Available Test Data

### Students
```sql
ICT2023001, ICT2023002, ICT2023003, ICT2023004, ICT2023005
BIO2023001, BIO2023002, BIO2023003, BIO2023004
ENG2023001, ENG2023002, ENG2023003, ENG2023004
```

### Courses (with Final_Marks data)
```sql
ICT1212 (Semester 02) - Database Management Systems
ICT1261 (Semester 02) - System Programming
ICT1222 (Semester 02) - Database Practicum
ICT1232 (Semester 02) - Web Development
ICT1252 (Semester 02) - Operating Systems
TMS1233 (Semester 03) - Discrete Mathematics
ENG1212 (Semester 02) - English II
```

---

## Alternative: Test with Interactive MySQL

### Start MySQL shell
```bash
mysql -u root -pAmjad@302 StudentManagement
```

### Then run any command
```sql
CALL sp_attendance_individual('ICT2023001', NULL, 'combined');
CALL sp_compute_grades_for_student('ICT2023002');
CALL sp_compute_cgpa('ICT2023002');
-- etc...
```

---

## Batch Test All Procedures

```bash
for proc in "sp_attendance_individual('ICT2023001', NULL, 'combined')" \
            "sp_attendance_summary_by_course('ICT1212')" \
            "sp_ca_marks_by_course('ICT1212')" \
            "sp_compute_grades_for_student('ICT2023002')" \
            "sp_compute_sgpa('ICT2023002', '02')" \
            "sp_compute_cgpa('ICT2023002')" \
            "sp_batch_results_summary('ICT1212', '02')"; do
  echo "Testing: $proc"
  mysql -u root -pAmjad@302 StudentManagement -e "CALL $proc;"
  echo ""
done
```

---

## Verify All Procedures Are Loaded

```bash
mysql -u root -pAmjad@302 StudentManagement -e "SELECT COUNT(*) as total_procedures FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA='StudentManagement' AND ROUTINE_NAME LIKE 'sp_%';"
```

```bash
mysql -u root -pAmjad@302 StudentManagement -e "SELECT ROUTINE_NAME FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA='StudentManagement' AND ROUTINE_NAME LIKE 'sp_%' ORDER BY ROUTINE_NAME;"
```

---

## Test Output Examples

### Expected output for sp_attendance_individual:
```
Course_ID | course_name           | hours_attended | total_possible_hours | percentage | eligibility
ICT1232   | Web Development       | 2              | 30                   | 6.67       | Not Eligible
```

### Expected output for sp_compute_grades_for_student:
```
Course_ID | course_name | Total_Marks | raw_grade | final_grade | final_grade_point | Credit
ICT1212   | DBMS        | 4.00        | F         | F           | 0.0               | 2
```

### Expected output for sp_compute_cgpa:
```
Std_Reg    | CGPA
ICT2023002 | 0.000
```

---

## Notes

- Replace student IDs (`ICT2023001`, `ICT2023002`, etc.) with actual student registration numbers
- Replace course IDs (`ICT1212`, etc.) with actual course IDs from your database
- Privilege procedures (`sp_assign_role`, `sp_revoke_role`, `sp_create_user_with_role`) require appropriate MySQL root privileges
- All procedures support NULL parameters where applicable (see specific procedure documentation)
