CREATE TABLE TechnicalOfficer (
    user_ID INT PRIMARY KEY,
    FOREIGN KEY (user_ID) REFERENCES UserAccount(user_ID)
);