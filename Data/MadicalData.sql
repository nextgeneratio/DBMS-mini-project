INSERT INTO Medical 
(med_ID, Std_Reg, Course_ID, state, Approved_by, date_medical_request, certificate_file, date_of_approval) 
VALUES
(1, 'ICT2023001', 'DBS201', 'Pending', 'UA001', '2026-05-01', 'med_cert_001.pdf', NULL),
(2, 'ICT2023002', 'WED202', 'Approved', 'UA001', '2026-04-28', 'med_cert_002.pdf', '2026-04-29'),
(3, 'ENG2023001', 'SWE203', 'Approved', 'UA004', '2026-04-25', 'med_cert_003.pdf', '2026-04-26'),
(4, 'BIO2023001', 'BIO205', 'Rejected', 'UA001', '2026-04-20', 'med_cert_004.pdf', '2026-04-21'),
(5, 'BIO2023002', 'BIO205', 'Pending', 'UA004', '2026-05-02', 'med_cert_005.pdf', NULL)
;