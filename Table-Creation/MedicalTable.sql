use StudentManagement;

CREATE TABLE Medical (
    med_ID INT PRIMARY KEY,
    Std_Reg VARCHAR(20),
    Course_ID VARCHAR(20),
    state VARCHAR(50),
    Approved_by VARCHAR(20),
    date_medical_request DATE,
    certificate_file VARCHAR(255),
    date_of_approval DATE,
    FOREIGN KEY (Std_Reg) REFERENCES Student(Std_Reg)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (Approved_by) REFERENCES UserAccount(user_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);