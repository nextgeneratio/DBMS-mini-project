use StudentManagement;

CREATE TABLE Lecturers (
    user_ID INT PRIMARY KEY,
    FOREIGN KEY (user_ID) REFERENCES UserAccount(user_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);