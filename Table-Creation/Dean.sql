use StudentManagement;

CREATE TABLE Dean (
    user_ID VARCHAR(20) PRIMARY KEY,
    FOREIGN KEY (user_ID) REFERENCES UserAccount(user_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);