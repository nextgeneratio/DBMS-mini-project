# DBMS-mini-project
This repository contains the SQL schema and sample data for the ICT1222 mini project (Student Management System).

**Overview**
- **Purpose**: Implements a relational database to manage students, courses, attendance, marks, medical requests and user accounts for the Faculty of Technology as required by the project scenario.
- **Artifacts**: Schema files, seed data, and an ER / relational diagram are included in the repository.

**Why this architecture was chosen**
- **Normalized, role-aware design:** The schema separates core entities (`Student`, `Course`, `Department`, `UserAccount`) from role-specific extensions (`Admin`, `Dean`, `Lecturers`, `TechnicalOfficer`) to keep user authentication/authorization distinct from domain data. See [UserAccountTable.sql](UserAccountTable.sql) and [Lectures.sql](Lectures.sql).
- **Many-to-many modeling for enrolment:** `StudentCourse` implements the many-to-many relationship between students and courses using a junction table, which simplifies queries for enrolment, attendance and marks aggregation. See [StudentCourse.sql](StudentCourse.sql).
- **Auditable assessment and attendance tracking:** Separate tables for `Score`, `Final_Marks` and `Attendance` allow storing multiple assessment types and session-level attendance, supporting the scenario requirements for CA, eligibility checks and different views (individual, course, batch). See [ScoreTable.sql](ScoreTable.sql), [FinalMarksTable.sql](FinalMarksTable.sql), and [Attendance.sql](Attendance.sql).
- **Medical/exemption handling:** `Medical` stores medical requests and approval metadata so that attendance/marks views can treat medical cases (MC) differently when determining eligibility, per the scenario rules. See [MedicalTable.sql](MedicalTable.sql).
- **Small lookup / extension tables for lecturer details:** `LecturesPhone` and `LecturesDesignation` keep multi-value and optional attributes out of the core `Lecturers` table, preserving 1:N relationships and avoiding NULL clutter. See [LecturerPhone.sql](LecturerPhone.sql) and [LecturerDesignation.sql](LecturerDesignation.sql).
- **Referential integrity and cascading:** Foreign keys link domain objects (e.g., students → department, scores → student/course) and use `ON DELETE/UPDATE CASCADE` where appropriate to keep the dataset consistent when parent records change. Examples are in [Student.sql](Student.sql) and [Course.sql](Course.sql).
- **Support for required reports and rules:** The table layout directly supports the scenario's reporting needs: batch summaries, per-course summaries, individual views, eligibility checks (attendance+CA), and grade/SGPA/CGPA calculations. Storing granular records (per session attendance, per-assessment scores) makes these computations straightforward.

**How the relational diagram maps to files**
- The relational diagram visualizes these entities and relationships; see [Relational-Diagram-MiniProject.drawio.png](Relational-Diagram-MiniProject.drawio.png).
- Key SQL implementations: [Student.sql](Student.sql), [Course.sql](Course.sql), [StudentCourse.sql](StudentCourse.sql), [Attendance.sql](Attendance.sql), [ScoreTable.sql](ScoreTable.sql), [FinalMarksTable.sql](FinalMarksTable.sql), [MedicalTable.sql](MedicalTable.sql), and [UserAccountTable.sql](UserAccountTable.sql).

**Design trade-offs and notes**
- The schema favors clarity and ease of reporting over denormalized performance optimizations. If you need higher read performance for large datasets, add targeted indexes or materialized summary views for attendance and CA aggregation.
- Role privileges are represented implicitly by separate role tables referencing `UserAccount` — consider adding a `roles`/`permissions` metadata table if you need more fine-grained, configurable privileges.

If you want, I can add a short section with example queries for the common reports (eligibility, batch summary, SGPA/CGPA calculation).

