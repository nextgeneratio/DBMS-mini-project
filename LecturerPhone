use StudentManagement;

CREATE TABLE LecturesPhone (
    user_ID INT,
    Phone VARCHAR(15),
    PRIMARY KEY (user_ID, Phone),
    FOREIGN KEY (user_ID) REFERENCES Lecturers(user_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);