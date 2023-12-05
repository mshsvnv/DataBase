-- Active: 1696673577093@@127.0.0.1@5432@task2
-- ЗАДАНИЕ 1

CREATE DATABASE IF NOT EXISTS task2;
CREATE TABLE IF NOT EXISTS Faculty (
    ID INT PRIMARY KEY,
    Title TEXT NOT NULL,
    Description TEXT
);
CREATE TABLE IF NOT EXISTS Tutor (
    ID INT PRIMARY KEY,
    FIO TEXT NOT NULL,
    Degree BOOLEAN,
    JobTitle TEXT NOT NULL,
    FacultyID INT NOT NULL,
    FOREIGN KEY(FacultyID) REFERENCES Faculty(ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Subject (
    ID INT PRIMARY KEY,
    Title TEXT NOT NULL,
    HoursAmount INT DEFAULT(48),
    Semester INT CHECK(Semester > 0),
    Rating INT NOT NULL
);

CREATE TABLE IF NOT EXISTS TutorSubject (
    TutorID INT,
    SubjectID INT,
    FOREIGN KEY(TutorID) REFERENCES Tutor(ID) ON DELETE CASCADE,
    FOREIGN KEY(SubjectID) REFERENCES Subject(ID) ON DELETE CASCADE
);

INSERT INTO Faculty VALUES
(1, 'ИУ7', 'Тяжело, больно, весело'),
(2, 'ИУ5', 'Как ИУ7, только легче'),
(3, 'ФН12', 'Тяжело, больно(2х)'),
(4, 'ФН4', NULL),
(5, 'ФВ', NULl);

INSERT INTO Tutor VALUES 
(1, 'Иванов ИИ', FALSE, 'Младший преподаватель', 1),
(2, 'Семенов СС', TRUE, 'Старший преподаватель', 2),
(3, 'Шубенина ДВ', FALSE, 'Ассистент', 2),
(4, 'Пац ИА', TRUE, 'Заведующий кафедрой', 1),
(5, 'Жигунов ДА', TRUE, 'Заместитель заведующего кафедрой', 3),
(6, 'Сентябова ЛА', TRUE, 'Старший преподаватель', 4),
(7, 'Глуздова ОА', FALSE, 'Младший преподаватель', 3),
(8, 'Коломиец ЕМ', FALSE, 'Ассистент', 4),
(9, 'Барило ЕА', FALSE, 'Младший преподаватель', 3),
(10, 'Постнов СА', TRUE, 'Старший преподаватель', 5);

INSERT INTO Subject VALUES
(1, 'Информатика', 48, 1, 100),
(2, 'Математика', 48, 1, 99),
(3, 'Физика', 96, 2, 50),
(4, 'Физ-ра', 96, 3, 50),
(5, 'ОС', 108, 3, 110);

INSERT INTO TutorSubject VALUES 
(1, 2),
(2, 1),
(3, 1),
(4, 1),
(5, 5),
(6, 3),
(7, 2),
(8, 3),
(9, 2),
(10, 4);

DROP TABLE IF EXISTS Tutor, Subject, Faculty, TutorSubject;

-- ЗАДАНИЕ 2
-- 1
-- Существуют ли факультеты, на которых весело
SELECT *
FROM Faculty
WHERE EXISTS (SELECT *
            FROM Faculty
             WHERE Description LIKE '%весело%');
SELECT .ID
FROM Tutor
WHERE EXISTS (SELECT Tutor.ID
              FROM Tutor LEFT JOIN Faculty ON Tutor.FacultyID = FacultyID
              WHERE Tutor.Degree = FALSE);

-- 2 
-- Вывести инфу о преподах, рейтинг которых меньше 60
SELECT * 
FROM Tutor
WHERE Tutor.ID IN (SELECT T.ID
                   FROM Tutor T JOIN TutorSubject TS ON T.ID = TS.TutorID JOIN Subject S ON S.ID = TS.SubjectID
                   WHERE S.Rating < 60);

-- 3
-- Вывести инфу о преподах, рейтин которых между 50 и 60
SELECT *
FROM Tutor T
WHERE T.ID IN (SELECT T2.ID
              FROM Tutor T2 JOIN TutorSubject TS ON T.ID = TS.TutorID JOIN Subject S ON S.ID = TS.SubjectID
              WHERE S.ID IN (SELECT S1.ID
                            FROM Subject S1
                            WHERE S1.Rating BETWEEN 50 AND 60));

-- ЗАДАНИЕ 3
CREATE VIEW view1 AS
SELECT 'A' AS column1, 1 AS column2;

CREATE VIEW view2 AS
SELECT 'B' AS column1, 2 AS column2;

CREATE VIEW view3 AS
SELECT 'C' AS column1, 3 AS column2;

SELECT table_name
FROM information_schema.views
WHERE table_catalog = 'task2' 
AND table_schema = 'public';

DROP FUNCTION DropAllViewsInDatabase;

CREATE OR REPLACE FUNCTION DropAllViewsInDatabase(database_name text) RETURNS int AS  
$$
DECLARE
    cnt int := 0;
    viewRec RECORD;
BEGIN
    FOR viewRec IN 
        SELECT table_name
        FROM information_schema.views
        WHERE table_catalog = database_name
        AND table_schema = 'public'
    LOOP
        EXECUTE 'DROP VIEW IF EXISTS ' || viewRec.table_name;
        cnt := cnt + 1;
    END LOOP;

    RETURN cnt;
END;
$$
LANGUAGE plpgsql;

SELECT DropAllViewsInDatabase('task2');
