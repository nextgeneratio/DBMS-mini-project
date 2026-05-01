CREATE TABLE Medical (
    med_ID INT PRIMARY KEY,
    Std_Reg VARCHAR(20),
    Course_Code VARCHAR(20),
    state VARCHAR(50),
    Approved_by INT,
    date_medical_request DATE,
    certificate_file VARCHAR(255),
    date_of_approval DATE,
    FOREIGN KEY (Std_Reg) REFERENCES Student(Std_Reg),
    FOREIGN KEY (Course_Code) REFERENCES Course(Course_Code),
    FOREIGN KEY (Approved_by) REFERENCES UserAccount(user_ID)
);