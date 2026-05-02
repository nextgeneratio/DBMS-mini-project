INSERT INTO UserAccount 
(user_ID, username, password, role, email, last_login, privilege, created_at, dept_ID) 
VALUES
('UA001', 'admin01', SHA2('123456', 256), 'Admin', 'admin1@gmail.com', '2026-05-01 10:15:00', 'Full Access', '2026-01-01 09:00:00', 1),
('UA002', 'lecturer01', SHA2('123123', 256), 'Lecturer', 'lecturer1@gmail.com', '2026-05-01 11:00:00', 'Edit Access', '2026-02-10 08:30:00', 1),
('UA003', 'student01', SHA2('654321', 256), 'Student', 'student1@gmail.com', '2026-04-30 14:20:00', 'View Only', '2026-03-05 12:00:00', 1),
('UA004', 'admin02', SHA2('112233', 256), 'Admin', 'admin2@gmail.com', '2026-05-01 09:45:00', 'Full Access', '2026-01-15 10:10:00', 3),
('UA005', 'lecturer02', SHA2('123321', 256), 'Lecturer', 'lecturer2@gmail.com', '2026-04-29 16:00:00', 'Edit Access', '2026-02-20 11:25:00', 2),
('UA006', 'student02', SHA2('121212', 256), 'Student', 'student2@gmail.com', '2026-04-28 13:10:00', 'View Only', '2026-03-18 09:40:00', 3),
('UA007', 'dean', SHA2('098765', 256), 'Dean', 'dean@gmail.com', '2026-04-28 13:10:00', 'Full Access', '2026-03-18 09:40:00', NULL ),
('UA008', 'lecturer03', SHA2('124578', 256), 'Lecturer', 'lecturer3@gmail.com', '2026-04-29 16:00:00', 'Edit Access', '2026-02-20 11:25:00', 2),
('UA009', 'lecturer04', SHA2('1234578', 256), 'Lecturer', 'lecturer4@gmail.com', '2026-04-29 16:00:00', 'Edit Access', '2026-02-20 11:25:00', 2),
('UA010', 'technical01', SHA2('1234578', 256), 'Lecturer', 'Technica1@gmail.com', '2026-04-29 16:00:00', 'Edit Access', '2026-03-20 11:25:00', NULL)
;