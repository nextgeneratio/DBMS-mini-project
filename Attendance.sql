use StudentManagement;

CREATE TABLE Attendance (
    Attendance_ID INT PRIMARY KEY,
    Std_Reg VARCHAR(20),
    Course_ID VARCHAR(20),
    Date DATE,
    Status VARCHAR(20),
    No_hour_Attended INT,
    FOREIGN KEY (Std_Reg) REFERENCES Student(Std_Reg)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);