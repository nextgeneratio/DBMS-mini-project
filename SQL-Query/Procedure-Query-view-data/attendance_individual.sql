-- Attendance details for an individual student
-- Parameters:
--  IN in_std_reg: student registration number (required)
--  IN in_course_id: optional course id filter (NULL = all courses)
--  IN in_mode: 'theory', 'practical', or 'combined' (default 'combined')
-- Assumptions: uses Course.Type to filter theory/practical

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_attendance_individual$$

CREATE PROCEDURE sp_attendance_individual(
    IN in_std_reg VARCHAR(20),
    IN in_course_id VARCHAR(20),
    IN in_mode VARCHAR(10)
)
BEGIN
    SELECT
        c.Course_ID,
        c.Name AS course_name,
        c.Type AS course_type,
        COALESCE(SUM(a.No_hour_Attended),0) AS hours_attended,
        c.No_of_hours AS total_possible_hours,
        CASE WHEN c.No_of_hours > 0 THEN ROUND(COALESCE(SUM(a.No_hour_Attended),0)/c.No_of_hours*100,2) ELSE NULL END AS percentage,
        CASE WHEN c.No_of_hours > 0 AND (COALESCE(SUM(a.No_hour_Attended),0)/c.No_of_hours*100) >= 80 THEN 'Eligible' ELSE 'Not Eligible' END AS eligibility
    FROM Course c
    JOIN StudentCourse sc ON sc.Course_ID = c.Course_ID AND sc.Std_Reg = in_std_reg
    LEFT JOIN Attendance a ON a.Course_ID = c.Course_ID AND a.Std_Reg = in_std_reg
    WHERE (in_course_id IS NULL OR in_course_id = '' OR c.Course_ID = in_course_id)
      AND (
            in_mode IS NULL
            OR in_mode = ''
            OR in_mode = 'combined'
            OR (in_mode = 'theory' AND LOWER(c.Type) LIKE 'theory%')
            OR (in_mode = 'practical' AND LOWER(c.Type) LIKE 'practical%')
          )
    GROUP BY c.Course_ID, c.Name, c.Type, c.No_of_hours;
END$$

DELIMITER ;
