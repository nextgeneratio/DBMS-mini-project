# Data Requirement Document

## Project
Student Management, Attendance, and Results Management System  
Course: ICT1222 - Database Management Systems Practicum  
Faculty of Technology, University of Ruhuna

## 1. Purpose
This document defines the data requirements for the mini project database system. It covers:
- Required data domains
- Core entities and attributes
- Relationships and cardinalities
- Business rules for attendance, marks, eligibility, grades, and GPA
- Data volume requirements from the scenario
- Data quality, integrity, and security requirements

## 2. Scope
The system shall manage:
- Student profile data
- User accounts and role-based academic staff data (Admin, Dean, Lecturer, Technical Officer)
- Course and department data
- Student course enrollment data
- Session-level attendance data
- Continuous assessment (CA), final marks, grades, and GPA data
- Medical submission and approval data

## 3. Stakeholders and Data Consumers
- Admin: full academic and account-level operational visibility
- Dean: faculty-level oversight and reporting
- Lecturers: course-level attendance and marks operations
- Technical Officers: attendance-focused operations
- Students: read-only access to approved attendance and final result data

## 4. Data Domains
- Identity data: user IDs, student registration numbers, names, emails
- Academic master data: departments, courses, credits, levels, semesters
- Enrollment data: student-course mappings and repeat flags
- Attendance transactions: per student, per course, per session/date
- Assessment transactions: CA components and final marks
- Medical transactions: request and approval workflow metadata
- Security metadata: login and role/privilege information

## 5. Entity and Attribute Requirements

### 5.1 Department
- Required attributes:
  - dept_ID (PK)
  - Name

### 5.2 UserAccount
- Required attributes:
  - user_ID (PK)
  - username (unique)
  - password
  - role
  - email (unique)
  - last_login
  - privilege
  - created_at
  - dept_ID (FK -> Department.dept_ID)

### 5.3 Role Extension Tables
These represent specialized user categories and each user_ID is both PK and FK to UserAccount.user_ID:
- Admin
- Dean
- Lecturers
- TechnicalOfficer

Lecturer support tables:
- LecturesPhone:
  - user_ID (FK -> Lecturers.user_ID)
  - Phone
  - Composite PK (user_ID, Phone)
- LecturesDesignation:
  - user_ID (PK/FK -> Lecturers.user_ID)
  - Designation

### 5.4 Student
- Required attributes:
  - Std_Reg (PK)
  - Name
  - enrol_year
  - Contact_No
  - batch
  - deg_program
  - Gender
  - DOB
  - address
  - email (unique)
  - dept_ID (FK -> Department.dept_ID)

### 5.5 Course
- Required attributes:
  - Course_ID (PK)
  - Name
  - No_of_hours
  - Level
  - Type
  - Semester
  - Credit
  - Dept_ID (FK -> Department.dept_ID)
  - Lec_ID (FK -> Lecturers.user_ID)

### 5.6 StudentCourse
- Required attributes:
  - Std_Reg (FK -> Student.Std_Reg)
  - Course_ID (FK -> Course.Course_ID)
  - is_repeat
  - Composite PK (Std_Reg, Course_ID)

### 5.7 Attendance
- Required attributes:
  - Attendance_ID (PK)
  - Std_Reg (FK -> Student.Std_Reg)
  - Course_ID (FK -> Course.Course_ID)
  - Date
  - Status
  - No_hour_Attended

### 5.8 Score
- Required attributes:
  - Score_ID (PK)
  - Std_Reg (FK -> Student.Std_Reg)
  - Course_ID (FK -> Course.Course_ID)
  - std_type
  - date
  - Marks

### 5.9 Final_Marks
- Required attributes:
  - F_M_ID (PK)
  - Std_Reg (FK -> Student.Std_Reg)
  - Course_ID (FK -> Course.Course_ID)
  - Total_Marks
  - Grade

### 5.10 Medical
- Required attributes:
  - med_ID (PK)
  - Std_Reg (FK -> Student.Std_Reg)
  - Course_ID (FK -> Course.Course_ID)
  - state
  - Approved_by (FK -> UserAccount.user_ID)
  - date_medical_request
  - certificate_file
  - date_of_approval

## 6. Relationship Requirements
- Department 1:N UserAccount
- Department 1:N Student
- Department 1:N Course
- UserAccount 1:1 Admin/Dean/Lecturers/TechnicalOfficer (role-extension pattern)
- Lecturers 1:N Course
- Student M:N Course via StudentCourse
- Student 1:N Attendance
- Course 1:N Attendance
- Student 1:N Score
- Course 1:N Score
- Student 1:N Final_Marks
- Course 1:N Final_Marks
- Student 1:N Medical
- Course 1:N Medical
- UserAccount 1:N Medical (as approving authority)

## 7. Functional Data Rules

### 7.1 Attendance
- Attendance must be stored per session/date and per student-course pair.
- Attendance percentage is computed with time-weight awareness:
  - Percentage = (sum(No_hour_Attended) / Course.No_of_hours) * 100
- Final exam attendance eligibility threshold:
  - Eligible if percentage >= 80%
- Medical-aware attendance handling must be available in summary views.

### 7.2 Continuous Assessment (CA)
- Marks are stored out of 100.
- CA total is derived by summing accepted CA components (for example: assignment, quiz, mid-term).
- CA eligibility threshold for final exam:
  - Eligible if CA_Total >= 35

### 7.3 Final Eligibility
- A student is eligible for final exam only if both are satisfied:
  - Attendance percentage >= 80
  - CA_Total >= 35

### 7.4 Grade and GPA
- Grade mapping:
  - >= 70 : A (4.0)
  - 60-69 : B (3.0)
  - 50-59 : C (2.0)
  - 40-49 : D (1.0)
  - < 40 : F (0.0)
- Repeat student rule:
  - If is_repeat = TRUE, maximum final grade is C (2.0)
- SGPA:
  - Weighted average by credit for a given semester
- CGPA:
  - Weighted average by credit across all courses

### 7.5 Medical and Withheld Results
- If approved medical exists for an assessment context, result should support MC display in reporting contexts.
- Suspended students must display WH for results (see Gap Analysis section; current schema requires enhancement to support this directly).

## 8. Data Volume Requirements

### 8.1 Minimum Required by Scenario
- Proper students: at least 10
- Repeat students: at least 5
- Lecturers: at least 5
- Technical Officers: at least 5
- Dean: at least 1
- Admin: at least 1
- Sufficient course, attendance, marks, and medical records for all report types

### 8.2 Current Loaded Dataset Snapshot
- Students: 15
- Courses: 9
- Lecturers: 5
- Technical Officers: 5
- Dean: 1
- Admin: 2
- StudentCourse rows: 9
- Attendance rows: 9
- Score rows: 7
- Final_Marks rows: 7
- Medical rows: 3

## 9. Data Quality and Integrity Requirements
- Primary keys must be unique and non-null.
- Foreign keys must enforce referential integrity with cascading behavior as configured.
- Email fields in Student and UserAccount must be unique.
- Marks and hour values should be non-negative.
- Controlled values should be enforced for key columns:
  - Course.Type (for example: theory/practical)
  - Attendance.Status (for example: present/absent/medical)
  - Score.std_type (for example: assignment/quiz/mid-term)
- Date fields should represent valid chronological events.

## 10. Security and Access Data Requirements
- DB user accounts and privileges must support dynamic role assignment/revocation procedures.
- Role expectations:
  - Admin: all privileges with grant option
  - Dean: all privileges without grant option
  - Lecturer: operational privileges for teaching and evaluation scope
  - Technical Officer: attendance-focused read/write/update
  - Student: read-only final attendance/result views
- Authentication and role metadata must be maintained in UserAccount.

## 11. Reporting and Query Output Requirements
The data model must support:
- Individual attendance by student and by student-course
- Batch attendance summary by course
- Theory-only, practical-only, and combined attendance views
- Individual and batch CA summaries
- Individual and batch final eligibility summaries
- Individual grade sheets (with repeat rule)
- SGPA and CGPA per student
- Batch results summary (grade distributions, CA eligibility distributions, GPA statistics)

## 12. Gap Analysis and Recommended Enhancements
To fully satisfy all scenario notes and improve data robustness:
- Add Student.status field with controlled values: proper, repeat, suspended
  - Reason: direct support for WH logic for suspended students
- Add check constraints where supported:
  - Marks between 0 and 100
  - No_hour_Attended >= 0
  - Semester and credit domain checks
- Add indexing for performance on frequent join/filter columns:
  - Attendance(Std_Reg, Course_ID, Date)
  - Score(Std_Reg, Course_ID, std_type)
  - Final_Marks(Std_Reg, Course_ID)
  - StudentCourse(Std_Reg, Course_ID)

## 13. Assumptions
- Course.No_of_hours represents total planned hours used in attendance percentage calculations.
- Semester values are stored in comparable code format (for example, 01, 02, 03).
- Medical and grade overrides are handled in reporting/procedure logic where not physically stored as final grade values.

## 14. Traceability to Project Files
This document is based on schema and scenario definitions in:
- Scenario.txt
- Table-Creation/DepartementTable.sql
- Table-Creation/UserAccountTable.sql
- Table-Creation/Student.sql
- Table-Creation/Course.sql
- Table-Creation/StudentCourse.sql
- Table-Creation/Attendance.sql
- Table-Creation/ScoreTable.sql
- Table-Creation/FinalMarksTable.sql
- Table-Creation/MedicalTable.sql
- Table-Creation/Admine.sql
- Table-Creation/Dean.sql
- Table-Creation/Lectures.sql
- Table-Creation/TecnicalOfficer.sql
- Table-Creation/LecturerPhone.sql
- Table-Creation/LecturerDesignation.sql
