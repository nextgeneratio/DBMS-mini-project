use StudentManagement;

CREATE TABLE Score (
    Score_ID INT PRIMARY KEY,
    Std_Reg VARCHAR(20),
    Course_Code VARCHAR(20),
    std_type VARCHAR(50),
    date DATE,
    Marks DECIMAL(5,2),
    FOREIGN KEY (Std_Reg) REFERENCES Student(Std_Reg)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (Course_Code) REFERENCES Course(Course_Code)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);