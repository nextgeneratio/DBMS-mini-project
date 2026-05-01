use StudentManagement;

CREATE TABLE StudentCourse (
    Std_Reg VARCHAR(20),
    Course_Code VARCHAR(20),
    PRIMARY KEY (Std_Reg, Course_Code),
    FOREIGN KEY (Std_Reg) REFERENCES Student(Std_Reg)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (Course_Code) REFERENCES Course(Course_Code)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);