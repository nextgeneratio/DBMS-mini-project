use StudentManagement;

CREATE TABLE UserAccount (
    user_ID VARCHAR(20) PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    password VARCHAR(255),
    role VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    last_login DATETIME,
    privilege VARCHAR(50),
    created_at DATETIME,
    dept_ID INT,
    FOREIGN KEY (dept_ID) REFERENCES Department(dept_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);