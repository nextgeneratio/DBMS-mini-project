use StudentManagement;

CREATE TABLE Student (
    Std_Reg VARCHAR(20) PRIMARY KEY,
    Name VARCHAR(100),
    enrol_year INT,
    Contact_No VARCHAR(15),
    batch VARCHAR(20),
    deg_program VARCHAR(100),
    Gender VARCHAR(10),
    DOB DATE,
    address TEXT,
    email VARCHAR(100) UNIQUE,
    dept_ID INT,
    FOREIGN KEY (dept_ID) REFERENCES Department(dept_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);