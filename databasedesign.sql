DROP TABLE IF EXISTS p_takes;
DROP TABLE IF EXISTS p_offerings;
DROP TABLE IF EXISTS p_classrooms;
DROP TABLE IF EXISTS p_courses;
DROP TABLE IF EXISTS p_students;

-- Table for students
CREATE TABLE p_students (
    pid CHAR(9) PRIMARY KEY, -- 9-digit student ID
    ssn CHAR(9), -- 9-digit SSN
    fname VARCHAR(40),
    lname VARCHAR(40),
    bdate DATE, -- Date of birth in YYYY-MM-DD format
    exp_grad_year CHAR(4), -- Expected graduation year in YYYY format
    major VARCHAR(40)
);

-- Table for courses
CREATE TABLE p_courses (
    dept CHAR(4), -- Exactly 4-letter department code
    cnum INT CHECK (cnum BETWEEN 100 AND 999), -- Course number (100-999)
    cname VARCHAR(40),
    cdesc TEXT, -- Long text description
    PRIMARY KEY (dept, cnum) -- Composite key
);

-- Table for classrooms
CREATE TABLE p_classrooms (
    building VARCHAR(40), -- Building name
    room_num INT CHECK (room_num BETWEEN 1 AND 999), -- Room number (1-999)
    num_seats INT CHECK (num_seats BETWEEN 1 AND 9999), -- Number of seats (1-9999)
    projector BOOLEAN, -- True or False
    PRIMARY KEY (building, room_num) -- Composite key
);

-- Table for offerings
CREATE TABLE p_offerings (
    dept CHAR(4), -- Matches p_courses.dept
    cnum INT CHECK (cnum BETWEEN 100 AND 999), -- Matches p_courses.cnum
    sem CHAR(1) CHECK (sem IN ('F', 'S')), -- 'F' for Fall, 'S' for Spring
    section INT CHECK (section BETWEEN 100 AND 999), -- Section number (100-999)
    building VARCHAR(40), -- Matches p_classrooms.building
    room_num INT, -- Matches p_classrooms.room_num
    num_enroll INT CHECK (num_enroll BETWEEN 1 AND 9999), -- Number of enrolled students
    PRIMARY KEY (dept, cnum, sem, section), -- Composite key
    FOREIGN KEY (dept, cnum) REFERENCES p_courses(dept, cnum),
    FOREIGN KEY (building, room_num) REFERENCES p_classrooms(building, room_num)
);

-- Table for takes (student enrollments in courses)
CREATE TABLE p_takes (
    pid CHAR(9), -- Matches p_students.pid
    dept CHAR(4), -- Matches p_offerings.dept
    cnum INT, -- Matches p_offerings.cnum
    sem CHAR(1), -- Matches p_offerings.sem
    section INT, -- Matches p_offerings.section
    grade CHAR(1) CHECK (grade IN ('A', 'B', 'C', 'D', 'F', 'W')), -- Grade for the course
    PRIMARY KEY (pid, dept, cnum, sem, section), -- Composite key
    FOREIGN KEY (pid) REFERENCES p_students(pid),
    FOREIGN KEY (dept, cnum, sem, section) REFERENCES p_offerings(dept, cnum, sem, section)
);

INSERT INTO p_students (pid, ssn, fname, lname, bdate, exp_grad_year, major) 
VALUES 
('123456789', '987654321', 'Alice', 'Johnson', '2002-05-15', '2025', 'Computer Science'),
('223456789', '876543210', 'Bob', 'Smith', '2001-08-22', '2024', 'Mathematics'),
('323456789', '765432109', 'Charlie', 'Brown', '2003-01-30', '2026', 'Physics');

INSERT INTO p_courses (dept, cnum, cname, cdesc) 
VALUES 
('COMP', 101, 'Intro to Programming', 'Learn the basics of programming using Python.'),
('MATH', 201, 'Calculus II', 'A continuation of differential calculus, focusing on integrals.'),
('PHYS', 301, 'Quantum Mechanics', 'An introduction to quantum mechanics and its principles.');

INSERT INTO p_classrooms (building, room_num, num_seats, projector) 
VALUES 
('Smith Hall', 101, 30, TRUE),
('Johnson Hall', 202, 50, FALSE),
('Brown Hall', 303, 25, TRUE);

INSERT INTO p_offerings (dept, cnum, sem, section, building, room_num, num_enroll) 
VALUES 
('COMP', 101, 'F', 101, 'Smith Hall', 101, 25),
('MATH', 201, 'S', 202, 'Johnson Hall', 202, 45),
('PHYS', 301, 'F', 301, 'Brown Hall', 303, 20);

INSERT INTO p_takes (pid, dept, cnum, sem, section, grade) 
VALUES 
('123456789', 'COMP', 101, 'F', 101, 'A'),
('223456789', 'MATH', 201, 'S', 202, 'B'),
('323456789', 'PHYS', 301, 'F', 301, 'A');



