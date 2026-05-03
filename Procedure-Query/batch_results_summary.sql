-- Batch results, grade distribution and batch GPA summary
-- Notes:
--  - If a student has a Medical record for the course (exists in Medical table), their final result is reported as 'MC'.
--  - If Student table contains a status field (e.g., 'suspended'), this procedure will honor it and mark 'WH' where applicable; otherwise WH is not applied.
--  - Grade bands and points follow the mapping used in grades_and_gpa.sql; adjust as needed to match UGC Circular No.12-2024.
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_batch_results_summary$$
CREATE PROCEDURE sp_batch_results_summary(IN in_course_id VARCHAR(20), IN in_semester VARCHAR(5))
BEGIN
    -- Grade distribution per course (or for all courses when course_id is NULL)
    SELECT
        t.Course_ID,
        SUM(CASE WHEN t.result_label = 'A' THEN 1 ELSE 0 END) AS A_count,
        SUM(CASE WHEN t.result_label = 'B' THEN 1 ELSE 0 END) AS B_count,
        SUM(CASE WHEN t.result_label = 'C' THEN 1 ELSE 0 END) AS C_count,
        SUM(CASE WHEN t.result_label = 'D' THEN 1 ELSE 0 END) AS D_count,
        SUM(CASE WHEN t.result_label = 'F' THEN 1 ELSE 0 END) AS F_count,
        SUM(CASE WHEN t.result_label = 'MC' THEN 1 ELSE 0 END) AS MC_count,
        SUM(CASE WHEN t.result_label = 'WH' THEN 1 ELSE 0 END) AS WH_count,
        COUNT(*) AS total_students
    FROM (
        SELECT fm.Std_Reg, fm.Course_ID,
            -- check medicals first
            CASE WHEN EXISTS (
                SELECT 1 FROM Medical m WHERE m.Std_Reg = fm.Std_Reg AND m.Course_ID = fm.Course_ID
            ) THEN 'MC'
            ELSE (
                CASE
                    WHEN fm.Total_Marks >= 70 THEN 'A'
                    WHEN fm.Total_Marks >= 60 THEN 'B'
                    WHEN fm.Total_Marks >= 50 THEN 'C'
                    WHEN fm.Total_Marks >= 40 THEN 'D'
                    ELSE 'F'
                END
            ) END AS result_label
        FROM Final_Marks fm
        WHERE (in_course_id IS NULL OR in_course_id = '' OR fm.Course_ID = in_course_id)
    ) t
    GROUP BY t.Course_ID;

    -- Batch CA eligibility summary
    SELECT
        sc.Course_ID,
        COUNT(*) AS total_students,
        SUM(CASE WHEN COALESCE(ca.CA_Total,0) >= 35 THEN 1 ELSE 0 END) AS ca_eligible_count,
        SUM(CASE WHEN COALESCE(ca.CA_Total,0) < 35 THEN 1 ELSE 0 END) AS ca_not_eligible_count
    FROM StudentCourse sc
    LEFT JOIN (
        SELECT Std_Reg, Course_ID, SUM(Marks) AS CA_Total
        FROM Score
        WHERE LOWER(std_type) IN ('assignment','quiz','mid-term','midterm')
        GROUP BY Std_Reg, Course_ID
    ) ca ON ca.Std_Reg = sc.Std_Reg AND ca.Course_ID = sc.Course_ID
    WHERE (in_course_id IS NULL OR in_course_id = '' OR sc.Course_ID = in_course_id)
    GROUP BY sc.Course_ID;

    -- Batch GPA summary: average SGPA (for given semester) and average CGPA (overall) for students in the selected semester/course
    -- Compute per-student SGPA
    DROP TEMPORARY TABLE IF EXISTS tmp_sgpa;
    CREATE TEMPORARY TABLE tmp_sgpa AS
    SELECT fm.Std_Reg,
        ROUND(SUM(CASE
            WHEN sc.is_repeat = TRUE AND fm.Total_Marks >= 60 THEN 2.0
            WHEN fm.Total_Marks >= 70 THEN 4.0
            WHEN fm.Total_Marks >= 60 THEN 3.0
            WHEN fm.Total_Marks >= 50 THEN 2.0
            WHEN fm.Total_Marks >= 40 THEN 1.0
            ELSE 0.0 END * c.Credit) / NULLIF(SUM(c.Credit),0),3) AS SGPA
    FROM Final_Marks fm
    JOIN Course c ON c.Course_ID = fm.Course_ID
    LEFT JOIN StudentCourse sc ON sc.Std_Reg = fm.Std_Reg AND sc.Course_ID = fm.Course_ID
    WHERE c.Semester = in_semester
    GROUP BY fm.Std_Reg;

    -- Compute per-student CGPA (overall)
    DROP TEMPORARY TABLE IF EXISTS tmp_cgpa;
    CREATE TEMPORARY TABLE tmp_cgpa AS
    SELECT fm.Std_Reg,
        ROUND(SUM(CASE
            WHEN sc.is_repeat = TRUE AND fm.Total_Marks >= 60 THEN 2.0
            WHEN fm.Total_Marks >= 70 THEN 4.0
            WHEN fm.Total_Marks >= 60 THEN 3.0
            WHEN fm.Total_Marks >= 50 THEN 2.0
            WHEN fm.Total_Marks >= 40 THEN 1.0
            ELSE 0.0 END * c.Credit) / NULLIF(SUM(c.Credit),0),3) AS CGPA
    FROM Final_Marks fm
    JOIN Course c ON c.Course_ID = fm.Course_ID
    LEFT JOIN StudentCourse sc ON sc.Std_Reg = fm.Std_Reg AND sc.Course_ID = fm.Course_ID
    GROUP BY fm.Std_Reg;

    -- Return averages for students in the selected course (or all students if course not provided)
    SELECT
        CASE WHEN (in_course_id IS NULL OR in_course_id = '') THEN 'ALL_COURSES' ELSE in_course_id END AS Course_ID_or_ALL,
        ROUND(AVG(tmp_sgpa.SGPA),3) AS avg_SGPA,
        ROUND(MIN(tmp_sgpa.SGPA),3) AS min_SGPA,
        ROUND(MAX(tmp_sgpa.SGPA),3) AS max_SGPA,
        ROUND(AVG(tmp_cgpa.CGPA),3) AS avg_CGPA,
        ROUND(MIN(tmp_cgpa.CGPA),3) AS min_CGPA,
        ROUND(MAX(tmp_cgpa.CGPA),3) AS max_CGPA
    FROM tmp_sgpa
    JOIN tmp_cgpa USING (Std_Reg)
    JOIN StudentCourse sc ON sc.Std_Reg = tmp_sgpa.Std_Reg
    WHERE (in_course_id IS NULL OR in_course_id = '' OR sc.Course_ID = in_course_id);

END$$
DELIMITER ;
