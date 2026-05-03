-- Procedures to compute grades and GPAs
-- Notes/Assumptions:
-- 1) Grade mapping (example mapping; adjust to UGC Circular 12-2024 if different):
--    >= 70 : A (4.0)
--    60-69 : B (3.0)
--    50-59 : C (2.0)
--    40-49 : D (1.0)
--    <40   : F (0.0)
-- 2) If a student is marked as repeat for a course (StudentCourse.is_repeat = TRUE), maximum grade is C.
-- 3) SGPA is computed per semester (use Course.Semester); CGPA is over all courses present in Final_Marks
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_compute_grades_for_student$$
CREATE PROCEDURE sp_compute_grades_for_student(IN in_std_reg VARCHAR(20))
BEGIN
    SELECT
        fm.Course_ID,
        c.Name AS course_name,
        fm.Total_Marks,
        CASE 
            WHEN fm.Total_Marks >= 70 THEN 'A'
            WHEN fm.Total_Marks >= 60 THEN 'B'
            WHEN fm.Total_Marks >= 50 THEN 'C'
            WHEN fm.Total_Marks >= 40 THEN 'D'
            ELSE 'F'
        END AS raw_grade,
        CASE 
            WHEN fm.Total_Marks >= 70 THEN 4.0
            WHEN fm.Total_Marks >= 60 THEN 3.0
            WHEN fm.Total_Marks >= 50 THEN 2.0
            WHEN fm.Total_Marks >= 40 THEN 1.0
            ELSE 0.0
        END AS raw_grade_point,
        sc.is_repeat AS is_repeat,
        -- apply repeat rule: cap at C (grade point 2.0)
        CASE
            WHEN sc.is_repeat = TRUE AND fm.Total_Marks >= 60 THEN 'C'
            ELSE CASE 
                    WHEN fm.Total_Marks >= 70 THEN 'A'
                    WHEN fm.Total_Marks >= 60 THEN 'B'
                    WHEN fm.Total_Marks >= 50 THEN 'C'
                    WHEN fm.Total_Marks >= 40 THEN 'D'
                    ELSE 'F'
                 END
        END AS final_grade,
        CASE
            WHEN sc.is_repeat = TRUE AND fm.Total_Marks >= 60 THEN 2.0
            ELSE CASE 
                    WHEN fm.Total_Marks >= 70 THEN 4.0
                    WHEN fm.Total_Marks >= 60 THEN 3.0
                    WHEN fm.Total_Marks >= 50 THEN 2.0
                    WHEN fm.Total_Marks >= 40 THEN 1.0
                    ELSE 0.0
                 END
        END AS final_grade_point,
        c.Credit
    FROM Final_Marks fm
    JOIN Course c ON c.Course_ID = fm.Course_ID
    LEFT JOIN StudentCourse sc ON sc.Std_Reg = fm.Std_Reg AND sc.Course_ID = fm.Course_ID
    WHERE fm.Std_Reg = in_std_reg;
END$$

DROP PROCEDURE IF EXISTS sp_compute_sgpa$$
CREATE PROCEDURE sp_compute_sgpa(IN in_std_reg VARCHAR(20), IN in_semester VARCHAR(5))
BEGIN
    SELECT
        in_std_reg AS Std_Reg,
        in_semester AS Semester,
        ROUND(SUM(final_gp * c.Credit) / NULLIF(SUM(c.Credit),0),3) AS SGPA
    FROM (
        SELECT fm.Course_ID, fm.Total_Marks,
            CASE
                WHEN sc.is_repeat = TRUE AND fm.Total_Marks >= 60 THEN 2.0
                WHEN fm.Total_Marks >= 70 THEN 4.0
                WHEN fm.Total_Marks >= 60 THEN 3.0
                WHEN fm.Total_Marks >= 50 THEN 2.0
                WHEN fm.Total_Marks >= 40 THEN 1.0
                ELSE 0.0
            END AS final_gp
        FROM Final_Marks fm
        JOIN Course c ON c.Course_ID = fm.Course_ID
        LEFT JOIN StudentCourse sc ON sc.Std_Reg = fm.Std_Reg AND sc.Course_ID = fm.Course_ID
        WHERE fm.Std_Reg = in_std_reg AND c.Semester = in_semester
    ) g
    JOIN Course c ON c.Course_ID = g.Course_ID
    GROUP BY in_std_reg, in_semester;
END$$

DROP PROCEDURE IF EXISTS sp_compute_cgpa$$
CREATE PROCEDURE sp_compute_cgpa(IN in_std_reg VARCHAR(20))
BEGIN
    SELECT
        in_std_reg AS Std_Reg,
        ROUND(SUM(final_gp * c.Credit) / NULLIF(SUM(c.Credit),0),3) AS CGPA
    FROM (
        SELECT fm.Course_ID, fm.Total_Marks,
            CASE
                WHEN sc.is_repeat = TRUE AND fm.Total_Marks >= 60 THEN 2.0
                WHEN fm.Total_Marks >= 70 THEN 4.0
                WHEN fm.Total_Marks >= 60 THEN 3.0
                WHEN fm.Total_Marks >= 50 THEN 2.0
                WHEN fm.Total_Marks >= 40 THEN 1.0
                ELSE 0.0
            END AS final_gp
        FROM Final_Marks fm
        LEFT JOIN StudentCourse sc ON sc.Std_Reg = fm.Std_Reg AND sc.Course_ID = fm.Course_ID
        WHERE fm.Std_Reg = in_std_reg
    ) g
    JOIN Course c ON c.Course_ID = g.Course_ID
    GROUP BY in_std_reg;
END$$
DELIMITER ;
