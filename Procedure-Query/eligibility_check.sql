-- Eligibility check combining attendance and CA marks
-- Uses attendance percentage >=80 AND CA_Total >=35 to mark final eligibility
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_check_eligibility_by_course$$
CREATE PROCEDURE sp_check_eligibility_by_course(IN in_course_id VARCHAR(20))
BEGIN
    SELECT
        s.Std_Reg,
        s.Name,
        COALESCE(att.hours_attended,0) AS hours_attended,
        COALESCE(att.total_possible_hours, c.No_of_hours) AS total_possible_hours,
        att.percentage AS attendance_percentage,
        COALESCE(ca.CA_Total,0) AS CA_Total,
        CASE WHEN (att.percentage IS NOT NULL AND att.percentage >= 80) AND COALESCE(ca.CA_Total,0) >= 35
             THEN 'Eligible for Final' ELSE 'Not Eligible for Final' END AS final_eligibility
    FROM Student s
    JOIN StudentCourse stc ON s.Std_Reg = stc.Std_Reg AND stc.Course_ID = in_course_id
    LEFT JOIN (
        SELECT Std_Reg, SUM(No_hour_Attended) AS hours_attended, c.No_of_hours AS total_possible_hours,
               ROUND(SUM(No_hour_Attended)/c.No_of_hours*100,2) AS percentage
        FROM Attendance a
        JOIN Course c ON c.Course_ID = a.Course_ID
        WHERE a.Course_ID = in_course_id
        GROUP BY Std_Reg, c.No_of_hours
    ) att ON att.Std_Reg = s.Std_Reg
    LEFT JOIN (
        SELECT Std_Reg, COALESCE(SUM(Marks),0) AS CA_Total
        FROM Score
        WHERE Course_ID = in_course_id AND LOWER(std_type) IN ('assignment','quiz','mid-term','midterm')
        GROUP BY Std_Reg
    ) ca ON ca.Std_Reg = s.Std_Reg
    JOIN Course c ON c.Course_ID = in_course_id;
END$$
DELIMITER ;
