use StudentManagement;

CREATE TABLE StudentCourse (
    Std_Reg VARCHAR(20),
    Course_ID VARCHAR(20),
    is_repeat BOOLEAN,
    PRIMARY KEY (Std_Reg, Course_ID),
    FOREIGN KEY (Std_Reg) REFERENCES Student(Std_Reg)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);