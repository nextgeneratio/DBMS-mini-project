# DBMS Mini Project - Stored Procedures Setup Guide

This document provides a complete overview of all stored procedures created for the student management system across attendance, marks, grades, and privilege management.

## Folder Structure

```
DBMS-mini-project/
├── Procedure-Query-view-data/          # Attendance, Marks, Grades, Eligibility procedures
│   ├── attendance_individual.sql
│   ├── attendance_summary_by_course.sql
│   ├── batch_attendance_summary.sql
│   ├── batch_results_summary.sql
│   ├── ca_marks_summary.sql
│   ├── eligibility_check.sql
│   └── grades_and_gpa.sql
│
├── Privilege/                          # Role and privilege management
│   ├── grant_privileges.sql
│   ├── sp_manage_role_privileges.sql
│   ├── sp_create_user_with_role.sql
│   ├── usage_examples.sql
│   └── README.md
│
└── [Other folders: Table-Creation, Data, etc.]
```

## Setup Instructions

### Step 1: Create Database and Tables

```bash
# Create database and tables (if not already done)
mysql -u root -p < "Table-Creation/Admine.sql"
mysql -u root -p < "Table-Creation/Student.sql"
# ... (load all table creation files)
```

### Step 2: Load All Stored Procedures

Load in this order:

```bash
# Load privilege management procedures first (needed for user setup)
mysql -u root -p StudentManagement < "Privilege/sp_manage_role_privileges.sql"
mysql -u root -p StudentManagement < "Privilege/sp_create_user_with_role.sql"

# Load data query procedures
mysql -u root -p StudentManagement < "Procedure-Query-view-data/attendance_summary_by_course.sql"
mysql -u root -p StudentManagement < "Procedure-Query-view-data/attendance_individual.sql"
mysql -u root -p StudentManagement < "Procedure-Query-view-data/batch_attendance_summary.sql"
mysql -u root -p StudentManagement < "Procedure-Query-view-data/ca_marks_summary.sql"
mysql -u root -p StudentManagement < "Procedure-Query-view-data/eligibility_check.sql"
mysql -u root -p StudentManagement < "Procedure-Query-view-data/grades_and_gpa.sql"
mysql -u root -p StudentManagement < "Procedure-Query-view-data/batch_results_summary.sql"
```

Or use a batch script:

```bash
#!/bin/bash
DB="StudentManagement"

# Privilege procedures
mysql -u root -p $DB < "Privilege/sp_manage_role_privileges.sql"
mysql -u root -p $DB < "Privilege/sp_create_user_with_role.sql"

# Data query procedures
for file in Procedure-Query-view-data/*.sql; do
  mysql -u root -p $DB < "$file"
done

echo "All procedures loaded successfully!"
```

### Step 3: Create Users and Assign Roles

```sql
-- Connect as root
mysql -u root -p StudentManagement

-- Create Admin
CALL sp_create_user_with_role('admin','admin1','localhost','admin_pass_123','StudentManagement');

-- Create Dean
CALL sp_create_user_with_role('dean','dean1','localhost','dean_pass_456','StudentManagement');

-- Create Lecturers (multiple)
CALL sp_create_user_with_role('lecturer','lect1','localhost','lect1_pass','StudentManagement');
CALL sp_create_user_with_role('lecturer','lect2','localhost','lect2_pass','StudentManagement');

-- Create Technical Officers (multiple)
CALL sp_create_user_with_role('technical_officer','to1','localhost','to1_pass','StudentManagement');
CALL sp_create_user_with_role('technical_officer','to2','localhost','to2_pass','StudentManagement');

-- Create Students (multiple, read-only)
CALL sp_create_user_with_role('student','s2021001','localhost','s2021001_pass','StudentManagement');
CALL sp_create_user_with_role('student','s2021002','localhost','s2021002_pass','StudentManagement');
```

## Procedure Reference

### Attendance Management Procedures

#### `sp_attendance_summary_by_course(course_id)`
Attendance summary for a specific course (all students).

**Usage:**
```sql
CALL sp_attendance_summary_by_course('CS101');
```

**Returns:**
- Student registration, name
- First/last attendance dates
- Hours attended vs. total possible hours
- Attendance percentage
- Eligibility status (>= 80% → Eligible)

---

#### `sp_attendance_individual(std_reg, course_id, mode)`
Individual student attendance across courses (or specific course).

**Parameters:**
- `std_reg`: Student registration number
- `course_id`: Course ID (NULL for all courses)
- `mode`: 'theory', 'practical', or 'combined'

**Usage:**
```sql
CALL sp_attendance_individual('2021001', NULL, 'combined');
CALL sp_attendance_individual('2021001', 'CS101', 'theory');
```

---

#### `sp_batch_attendance_summary(course_id)`
Batch attendance statistics per course.

**Returns:**
- Total students
- Count of students >= 80% attendance
- Count of students < 80% attendance
- Medical-adjusted counts (>= 80%, < 80%)
- Average percentages

**Usage:**
```sql
CALL sp_batch_attendance_summary('CS101');
CALL sp_batch_attendance_summary(NULL);  -- All courses
```

---

### CA Marks Management Procedures

#### `sp_ca_marks_by_course(course_id)`
CA marks batch summary for a course.

**Returns:**
- Student registration, name
- Total CA marks (sum of Assignment + Quiz + Mid-Term)
- CA eligibility (>= 35 marks → Eligible)

**Usage:**
```sql
CALL sp_ca_marks_by_course('CS101');
```

---

#### `sp_ca_marks_individual(course_id, std_reg)`
CA marks for a specific student in a course.

**Returns:**
- Student registration
- CA Total
- CA eligibility status

**Usage:**
```sql
CALL sp_ca_marks_individual('CS101', '2021001');
```

---

### Eligibility Check Procedures

#### `sp_check_eligibility_by_course(course_id)`
Combined eligibility check: attendance (>= 80%) AND CA (>= 35 marks).

**Returns:**
- Student registration, name
- Attendance hours and percentage
- CA total marks
- Final eligibility for final exam

**Usage:**
```sql
CALL sp_check_eligibility_by_course('CS101');
```

---

### Grades and GPA Procedures

#### `sp_compute_grades_for_student(std_reg)`
Compute grades for a student across all courses.

**Returns:**
- Course ID, name, total marks
- Raw grade and grade point
- Final grade (accounting for repeat status)
- Final grade point
- Credit hours

**Repeat Rule:** If `StudentCourse.is_repeat = TRUE`, maximum grade capped at 'C' (2.0 points)

**Usage:**
```sql
CALL sp_compute_grades_for_student('2021001');
```

---

#### `sp_compute_sgpa(std_reg, semester)`
Compute SGPA (Semester Grade Point Average).

**Formula:**
```
SGPA = Σ (Grade Point × Credit) / Σ Credit
```

**Usage:**
```sql
CALL sp_compute_sgpa('2021001', '02');
```

---

#### `sp_compute_cgpa(std_reg)`
Compute CGPA (Cumulative Grade Point Average) across all courses/semesters.

**Usage:**
```sql
CALL sp_compute_cgpa('2021001');
```

---

### Batch Results Summary Procedure

#### `sp_batch_results_summary(course_id, semester)`
Comprehensive batch report including grade distribution, CA eligibility, and GPA statistics.

**Returns three result sets:**
1. **Grade Distribution**: A/B/C/D/F/MC/WH counts per course
2. **CA Eligibility**: CA eligible/not eligible counts per course
3. **GPA Statistics**: Average/min/max SGPA and CGPA

**Special Cases:**
- Medical records: Result marked as 'MC'
- Suspended students: Result marked as 'WH' (if status field exists)

**Usage:**
```sql
CALL sp_batch_results_summary('CS101', '02');
CALL sp_batch_results_summary(NULL, '02');  -- All courses for semester 02
```

---

## Grade Mapping Reference

| Mark Range | Grade | Grade Point |
|-----------|-------|------------|
| >= 70     | A     | 4.0        |
| 60 - 69   | B     | 3.0        |
| 50 - 59   | C     | 2.0        |
| 40 - 49   | D     | 1.0        |
| < 40      | F     | 0.0        |
| Medical   | MC    | N/A        |
| Suspended | WH    | N/A        |

**Note:** If a student is a **repeat** student (`StudentCourse.is_repeat = TRUE`), maximum achievable grade is **C** (2.0 points), even if marks warrant higher.

---

## Role-Based Access Control

### Admin
- **Privilege**: ALL PRIVILEGES WITH GRANT OPTION
- **Can**: Create users, manage all database objects

### Dean
- **Privilege**: ALL PRIVILEGES (no GRANT OPTION)
- **Can**: View and manage all data

### Lecturer
- **Privilege**: ALL PRIVILEGES on database
- **Can**: Record marks, manage attendance, view all data

### Technical Officer
- **Privilege**: SELECT, INSERT, UPDATE on Attendance table
- **Can**: Record and update attendance only

### Student
- **Privilege**: SELECT on Final_Marks and Attendance
- **Can**: View own marks and attendance (read-only)

---

## Testing Procedures

### Load Sample Data

```bash
mysql -u root -p StudentManagement < "Data/StudentData.sql"
mysql -u root -p StudentManagement < "Data/CourseData.sql"
mysql -u root -p StudentManagement < "Data/AttendanceData.sql"
mysql -u root -p StudentManagement < "Data/ScoreData.sql"
mysql -u root -p StudentManagement < "Data/FinalMarks.sql"
```

### Run Test Queries

```sql
-- Test attendance procedures
CALL sp_attendance_summary_by_course('ICT1211');
CALL sp_batch_attendance_summary('ICT1211');

-- Test CA marks
CALL sp_ca_marks_by_course('ICT1211');

-- Test eligibility
CALL sp_check_eligibility_by_course('ICT1211');

-- Test grades and GPA
CALL sp_compute_grades_for_student('2021001');
CALL sp_compute_sgpa('2021001', '02');
CALL sp_compute_cgpa('2021001');

-- Test batch results
CALL sp_batch_results_summary('ICT1211', '02');
```

---

## Common Issues and Solutions

### Issue: "Procedure not found"
**Solution**: Ensure all SQL files have been loaded. Check:
```sql
SHOW PROCEDURES LIKE 'sp_%';
```

### Issue: "Access denied for user"
**Solution**: Ensure user has correct privileges:
```sql
SHOW GRANTS FOR 'username'@'localhost';
```

### Issue: No data returned
**Solution**: Verify sample data has been loaded:
```sql
SELECT COUNT(*) FROM Student;
SELECT COUNT(*) FROM Course;
SELECT COUNT(*) FROM Attendance;
```

### Issue: Grade calculations incorrect
**Solution**: Check if repeat status is set correctly:
```sql
SELECT Std_Reg, is_repeat FROM StudentCourse WHERE Std_Reg = 'student_id';
```

---

## Next Steps

1. **Load all procedures** following the setup instructions
2. **Create user accounts** for Admin, Dean, Lecturers, and Students
3. **Test with sample data** using the test queries above
4. **Integrate with application** (backend/frontend) to call procedures

For more details, see:
- `Privilege/README.md` — Detailed privilege management guide
- `Procedure-Query-view-data/*.sql` — Individual procedure documentation

---

**Last Updated:** May 3, 2026
**Status:** Ready for deployment
