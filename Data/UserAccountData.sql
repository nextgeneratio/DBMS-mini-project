INSERT INTO UserAccount 
(user_ID, username, password, role, email, last_login, privilege, created_at, dept_ID) 
VALUES
(1, 'admin01', '123456', 'Admin', 'admin1@gmail.com', '2026-05-01 10:15:00', 'Full Access', '2026-01-01 09:00:00', 1),
(2, 'lecturer01', '123123', 'Lecturer', 'lecturer1@gmail.com', '2026-05-01 11:00:00', 'Edit Access', '2026-02-10 08:30:00', 1),
(3, 'student01', '654321', 'Student', 'student1@gmail.com', '2026-04-30 14:20:00', 'View Only', '2026-03-05 12:00:00', 1),
(4, 'admin02', '112233', 'Admin', 'admin2@gmail.com', '2026-05-01 09:45:00', 'Full Access', '2026-01-15 10:10:00', 3),
(5, 'lecturer02', '123321', 'Lecturer', 'lecturer2@gmail.com', '2026-04-29 16:00:00', 'Edit Access', '2026-02-20 11:25:00', 2),
(6, 'student02', '121212', 'Student', 'student2@gmail.com', '2026-04-28 13:10:00', 'View Only', '2026-03-18 09:40:00', 3),
(7, 'dean', '098765', 'Dean', 'dean@gmail.com', '2026-04-28 13:10:00', 'Full Access', '2026-03-18 09:40:00', NULL ),
(8, 'lecturer03', '124578', 'Lecturer', 'lecturer3@gmail.com', '2026-04-29 16:00:00', 'Edit Access', '2026-02-20 11:25:00', 2),
(9, 'lecturer04', '1234578', 'Lecturer', 'lecturer4@gmail.com', '2026-04-29 16:00:00', 'Edit Access', '2026-02-20 11:25:00', 2),
(10, 'technical01', '1234578', 'Lecturer', 'Technica1@gmail.com', '2026-04-29 16:00:00', 'Edit Access', '2026-03-20 11:25:00', NULL)
;