use StudentManagement;

CREATE TABLE Course (
    Course_ID VARCHAR(20) PRIMARY KEY,
    Name varchar(50),
    No_of_hours int,
    Level varchar(3),
    Type varchar(20),
    Semester varchar(2),
    Credit int,
    Dept_ID int,
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    Lec_ID VARCHAR(20),
    FOREIGN KEY (Lec_ID) REFERENCES Lecturers(user_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);