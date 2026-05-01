CREATE TABLE StudentCourse (
    Std_Reg VARCHAR(20),
    Course_Code VARCHAR(20),
    PRIMARY KEY (Std_Reg, Course_Code),
    FOREIGN KEY (Std_Reg) REFERENCES Student(Std_Reg),
    FOREIGN KEY (Course_Code) REFERENCES Course(Course_Code)
);