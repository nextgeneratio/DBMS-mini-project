-- CA marks procedures: batch summary and individual
-- CA is defined as sum of Score rows with std_type in ('Assignment','Mid-Term','Quiz')
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ca_marks_by_course$$
CREATE PROCEDURE sp_ca_marks_by_course(IN in_course_id VARCHAR(20))
BEGIN
    SELECT
        s.Std_Reg,
        s.Name,
        COALESCE(SUM(CASE WHEN LOWER(sc.std_type) IN ('assignment','quiz','mid-term','midterm') THEN sc.Marks ELSE 0 END),0) AS CA_Total,
        CASE WHEN COALESCE(SUM(CASE WHEN LOWER(sc.std_type) IN ('assignment','quiz','mid-term','midterm') THEN sc.Marks ELSE 0 END),0) >= 35
             THEN 'Eligible' ELSE 'Not Eligible' END AS ca_eligibility
    FROM Student s
    JOIN StudentCourse stc ON s.Std_Reg = stc.Std_Reg AND stc.Course_ID = in_course_id
    LEFT JOIN Score sc ON sc.Std_Reg = s.Std_Reg AND sc.Course_ID = in_course_id
    GROUP BY s.Std_Reg, s.Name;
END$$

DROP PROCEDURE IF EXISTS sp_ca_marks_individual$$
CREATE PROCEDURE sp_ca_marks_individual(IN in_course_id VARCHAR(20), IN in_std_reg VARCHAR(20))
BEGIN
    SELECT
        in_std_reg AS Std_Reg,
        COALESCE(SUM(CASE WHEN LOWER(std_type) IN ('assignment','quiz','mid-term','midterm') AND Course_ID = in_course_id THEN Marks END),0) AS CA_Total,
        CASE WHEN COALESCE(SUM(CASE WHEN LOWER(std_type) IN ('assignment','quiz','mid-term','midterm') AND Course_ID = in_course_id THEN Marks END),0) >= 35
             THEN 'Eligible' ELSE 'Not Eligible' END AS ca_eligibility
    FROM Score
    WHERE Std_Reg = in_std_reg AND Course_ID = in_course_id;
END$$
DELIMITER ;
