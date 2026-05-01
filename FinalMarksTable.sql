CREATE TABLE Final_Marks (
    F_M_ID INT PRIMARY KEY,
    Std_Reg VARCHAR(20),
    Course_Code VARCHAR(20),
    Total_Marks DECIMAL(5,2),
    Grade VARCHAR(5),
    FOREIGN KEY (Std_Reg) REFERENCES Student(Std_Reg),
    FOREIGN KEY (Course_Code) REFERENCES Course(Course_Code)
);