use StudentManagement;

CREATE TABLE LecturesDesignation (
    user_ID VARCHAR(20) PRIMARY KEY,
    Designation VARCHAR(100),
    FOREIGN KEY (user_ID) REFERENCES Lecturers(user_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);