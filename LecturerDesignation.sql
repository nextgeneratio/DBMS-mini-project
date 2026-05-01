CREATE TABLE LecturesDesignation (
    user_ID INT PRIMARY KEY,
    Designation VARCHAR(100),
    FOREIGN KEY (user_ID) REFERENCES Lecturers(user_ID)
);