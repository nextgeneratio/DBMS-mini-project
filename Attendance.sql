CREATE TABLE Attendance (
    Attendance_ID INT PRIMARY KEY,
    Std_Reg VARCHAR(20),
    Course_Code VARCHAR(20),
    Date DATE,
    Status VARCHAR(20),
    No_hour_Attended INT,
    FOREIGN KEY (Std_Reg) REFERENCES Student(Std_Reg),
    FOREIGN KEY (Course_Code) REFERENCES Course(Course_Code)
);