# Data Requirement Document (Submission Version)

## 1. Introduction
This document defines the data requirements for the Student Management System developed for ICT1222 (Database Management Systems Practicum), Faculty of Technology, University of Ruhuna.

The system is designed to manage:
- student details
- course and department details
- attendance records
- assessment and final marks
- result processing (grades, SGPA, CGPA)
- role-based users and privileges
- medical submissions related to attendance and examinations

## 2. Objectives
The database must support:
1. storing complete academic and user account data.
2. generating attendance summaries for individuals and batches.
3. computing CA eligibility and final exam eligibility.
4. processing grades according to UGC Circular 12-2024.
5. supporting SGPA and CGPA calculation.
6. enforcing role-based access for Admin, Dean, Lecturer, Technical Officer, and Student.

## 3. Scope of Data
The required data scope includes:
- master data: Department, Course
- person/account data: Student, UserAccount, Admin, Dean, Lecturers, TechnicalOfficer
- relationship data: StudentCourse (enrollment + repeat flag)
- transaction data: Attendance, Score, Final_Marks, Medical

## 4. Entity-Wise Data Requirements

### 4.1 Department
- dept_ID (Primary Key)
- Name

### 4.2 UserAccount
- user_ID (Primary Key)
- username (Unique)
- password
- role
- email (Unique)
- last_login
- privilege
- created_at
- dept_ID (Foreign Key)

### 4.3 Role Entities
- Admin (user_ID as PK/FK)
- Dean (user_ID as PK/FK)
- Lecturers (user_ID as PK/FK)
- TechnicalOfficer (user_ID as PK/FK)

Supporting lecturer data:
- LecturesPhone: user_ID, Phone (composite key)
- LecturesDesignation: user_ID, Designation

### 4.4 Student
- Std_Reg (Primary Key)
- Name
- enrol_year
- Contact_No
- batch
- deg_program
- Gender
- DOB
- address
- email (Unique)
- dept_ID (Foreign Key)

### 4.5 Course
- Course_ID (Primary Key)
- Name
- No_of_hours
- Level
- Type
- Semester
- Credit
- Dept_ID (Foreign Key)
- Lec_ID (Foreign Key)

### 4.6 StudentCourse
- Std_Reg (Foreign Key)
- Course_ID (Foreign Key)
- is_repeat
- Composite Primary Key: (Std_Reg, Course_ID)

### 4.7 Attendance
- Attendance_ID (Primary Key)
- Std_Reg (Foreign Key)
- Course_ID (Foreign Key)
- Date
- Status
- No_hour_Attended

### 4.8 Score
- Score_ID (Primary Key)
- Std_Reg (Foreign Key)
- Course_ID (Foreign Key)
- std_type
- date
- Marks

### 4.9 Final_Marks
- F_M_ID (Primary Key)
- Std_Reg (Foreign Key)
- Course_ID (Foreign Key)
- Total_Marks
- Grade

### 4.10 Medical
- med_ID (Primary Key)
- Std_Reg (Foreign Key)
- Course_ID (Foreign Key)
- state
- Approved_by (Foreign Key)
- date_medical_request
- certificate_file
- date_of_approval

## 5. Relationship Requirements
The system must enforce these relationships:
1. Department to Student: 1:N
2. Department to Course: 1:N
3. Department to UserAccount: 1:N
4. UserAccount to Admin/Dean/Lecturers/TechnicalOfficer: 1:1 specialization
5. Lecturers to Course: 1:N
6. Student to Course: M:N via StudentCourse
7. Student and Course to Attendance: 1:N each
8. Student and Course to Score: 1:N each
9. Student and Course to Final_Marks: 1:N each
10. Student and Course to Medical: 1:N each

## 6. Business Rules (Data Rules)

### 6.1 Attendance Rules
1. Attendance is recorded per student, per course, per date/session.
2. Attendance percentage is calculated using course hours.
3. Eligibility threshold: attendance >= 80%.
4. Reports must support:
- individual (by registration number)
- individual by registration number + course code
- batch summary by course
- theory-only, practical-only, and combined views

### 6.2 CA Marks Rules
1. Marks are out of 100.
2. CA total is computed from valid CA components (assignment, quiz, mid-term).
3. CA eligibility threshold: CA_Total >= 35.
4. Reports must support individual and batch summaries.

### 6.3 Final Eligibility Rule
A student is eligible for final exam only if:
- attendance >= 80%
- CA_Total >= 35

### 6.4 Grade and GPA Rules
Grade mapping:
- 70 and above: A (4.0)
- 60-69: B (3.0)
- 50-59: C (2.0)
- 40-49: D (1.0)
- below 40: F (0.0)

Repeat-student rule:
- if is_repeat = TRUE, maximum grade allowed is C (2.0)

GPA rules:
- SGPA = weighted average for a semester
- CGPA = weighted average across all completed courses

### 6.5 Medical and Special Results
1. Medical records must be storable and linkable to student/course.
2. Result views should support MC display where applicable.
3. Suspended student results must be shown as WH (requires Student status support in schema/procedures).

## 7. Required Minimum Data Volumes (Scenario Compliance)
The database should contain at least:
1. proper students: 10
2. repeat students: 5
3. lecturers: 5
4. technical officers: 5
5. dean: 1
6. admin: 1

Current loaded sample data (snapshot):
1. students: 15
2. courses: 9
3. lecturers: 5
4. technical officers: 5
5. dean: 1
6. admin: 2

## 8. Data Integrity Requirements
1. All primary keys must be unique and non-null.
2. All foreign keys must preserve referential integrity.
3. Unique constraints must be enforced for email and username fields.
4. Marks and attendance hours should not be negative.
5. Controlled domains should be used for status/type fields (for example Course.Type, Attendance.Status, Score.std_type).

## 9. Security and Access Requirements
Role privileges expected by scenario:
1. Admin: all privileges with grant option
2. Dean: all privileges without grant option
3. Lecturer: operational academic privileges
4. Technical Officer: attendance-related read/write/update
5. Student: read-only access to final attendance and final marks/grades

The system should maintain user authentication and privilege metadata through UserAccount and procedure-based privilege management.

## 10. Output and Reporting Requirements
The database must support data retrieval for:
1. attendance summaries (individual and batch)
2. CA summaries (individual and batch)
3. final eligibility reports
4. individual subject-wise grades
5. SGPA and CGPA reports
6. batch-level result summaries including grade distribution and statistics

## 11. Assumptions and Improvement Note
Assumptions:
1. Course.No_of_hours is used as total denominator for attendance percentage.
2. Semester codes are consistently stored (for example 01, 02, 03).

Improvement note:
- Add Student.status (proper, repeat, suspended) to fully enforce WH requirement directly in schema and procedures.

## 12. Source Artifacts Used
This document is derived from:
1. Scenario.txt
2. Table-Creation SQL files (Student, Course, Attendance, Score, Final_Marks, Medical, UserAccount, role tables)
3. Project stored procedures and test outputs
