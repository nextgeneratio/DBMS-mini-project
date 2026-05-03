-- Attendance summary per course
-- Assumptions:
-- 1) Total possible hours for a course = Course.No_of_hours
-- 2) A student is eligible based on attendance if percentage >= 80
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_attendance_summary_by_course$$
CREATE PROCEDURE sp_attendance_summary_by_course(IN in_course_id VARCHAR(20))
BEGIN
    SELECT
        s.Std_Reg,
        s.Name,
        COALESCE(MIN(a.Date), NULL) AS first_attendance_date,
        COALESCE(MAX(a.Date), NULL) AS last_attendance_date,
        COUNT(DISTINCT a.Date) AS sessions_recorded,
        COALESCE(SUM(a.No_hour_Attended),0) AS hours_attended,
        c.No_of_hours AS total_possible_hours,
        CASE WHEN c.No_of_hours > 0
             THEN ROUND(COALESCE(SUM(a.No_hour_Attended),0) / c.No_of_hours * 100,2)
             ELSE NULL END AS percentage,
        CASE WHEN c.No_of_hours > 0 AND (COALESCE(SUM(a.No_hour_Attended),0) / c.No_of_hours * 100) >= 80
             THEN 'Eligible' ELSE 'Not Eligible' END AS eligibility
    FROM Student s
    JOIN StudentCourse sc ON s.Std_Reg = sc.Std_Reg AND sc.Course_ID = in_course_id
    LEFT JOIN Attendance a ON s.Std_Reg = a.Std_Reg AND a.Course_ID = in_course_id
    JOIN Course c ON c.Course_ID = in_course_id
    GROUP BY s.Std_Reg, s.Name, c.No_of_hours;
END$$
DELIMITER ;
