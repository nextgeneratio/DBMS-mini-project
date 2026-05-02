use StudentManagement;

CREATE TABLE Course (
    Course_ID INT PRIMARY KEY,
    Name varchar(50),
    No_of_hours int,
    Contact_NO varchar(10),
    Level varchar(3),
    Type varchar(20),
    Semester varchar(2),
    Credit int,
    Dept_ID int
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);