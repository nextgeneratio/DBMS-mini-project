-- Batch attendance summary per course (and for all courses when course_id is NULL)
-- Computes counts for: >=80%, <80%, medical-adjusted >=80%, medical-adjusted <80%
-- Uses Attendance.Status values: 'Present' and 'Medical' (case-insensitive). If your data models differ, adjust accordingly.
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_batch_attendance_summary$$
CREATE PROCEDURE sp_batch_attendance_summary(IN in_course_id VARCHAR(20))
BEGIN
    SELECT
        t.Course_ID,
        COUNT(*) AS total_students,
        SUM(CASE WHEN (t.hours_present / NULLIF(t.no_of_hours,0) * 100) >= 80 THEN 1 ELSE 0 END) AS count_ge_80,
        SUM(CASE WHEN (t.hours_present / NULLIF(t.no_of_hours,0) * 100) < 80 THEN 1 ELSE 0 END) AS count_lt_80,
        SUM(CASE WHEN (t.hours_med_adj / NULLIF(t.no_of_hours,0) * 100) >= 80 THEN 1 ELSE 0 END) AS count_medical_adjusted_ge_80,
        SUM(CASE WHEN (t.hours_med_adj / NULLIF(t.no_of_hours,0) * 100) < 80 THEN 1 ELSE 0 END) AS count_medical_adjusted_lt_80,
        ROUND(AVG(t.hours_present / NULLIF(t.no_of_hours,0) * 100),2) AS avg_percentage,
        ROUND(AVG(t.hours_med_adj / NULLIF(t.no_of_hours,0) * 100),2) AS avg_medical_adjusted_percentage
    FROM (
        SELECT sc.Course_ID,
               sc.Std_Reg,
               COALESCE(SUM(CASE WHEN LOWER(a.Status) = 'present' THEN a.No_hour_Attended ELSE 0 END),0) AS hours_present,
               COALESCE(SUM(CASE WHEN LOWER(a.Status) IN ('present','medical') THEN a.No_hour_Attended ELSE 0 END),0) AS hours_med_adj,
               c.No_of_hours
        FROM StudentCourse sc
        JOIN Course c ON c.Course_ID = sc.Course_ID
        LEFT JOIN Attendance a ON a.Course_ID = sc.Course_ID AND a.Std_Reg = sc.Std_Reg
        WHERE (in_course_id IS NULL OR in_course_id = '' OR sc.Course_ID = in_course_id)
        GROUP BY sc.Course_ID, sc.Std_Reg, c.No_of_hours
    ) t
    GROUP BY t.Course_ID;
END$$
DELIMITER ;
