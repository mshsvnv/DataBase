CREATE DATABASE RK2;

CREATE TABLE IF NOT EXISTS Department (
    id INT PRIMARY KEY,
    name_department VARCHAR(100) NOT NULL,
    number TEXT UNIQUE,
    id_leader INT UNIQUE
);
CREATE TABLE IF NOT EXISTS Drug (
    id INT PRIMARY KEY,
    title TEXT,
    instruction TEXT,
    price REAL
);
CREATE TABLE IF NOT EXISTS Employee (
    id INT PRIMARY KEY,
    id_department INT NOT NULL,
    position TEXT NOT NULL,
    fio VARCHAR(100) NOT NULL,
    salary INT DEFAULT 100,
    FOREIGN KEY(id_department) REFERENCES Department(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS Responses (
    id INT PRIMARY KEY,
    id_empl INT,
    id_drug INT,
    FOREIGN KEY(id_empl) REFERENCES Employee(id) ON DELETE CASCADE,
    FOREIGN KEY(id_drug) REFERENCES Drug(id) ON DELETE CASCADE
);

ALTER TABLE Department
    ADD CONSTRAINT fk_leader FOREIGN KEY(id_leader) REFERENCES Employee(id) ON DELETE SET NULL;

ALTER TABLE Department
    DROP CONSTRAINT fk_leader;

INSERT INTO Department VALUES(1, 'Departmant 1', '89990202888', 1),
                              (2, 'Departmant 2', '89990202889', 10),
                              (3, 'Departmant 3', '89990202879', 22),
                              (4, 'Departmant 4', '89990202869', 15),
                              (5, 'Departmant 5', '89990202859', 16),
                              (6, 'Departmant 6', '89990202849', 17),
                              (7, 'Departmant 7', '89990202839', 18),
                              (8, 'Departmant 8', '89990202829', 19),
                              (9, 'Departmant 9', '89990202819', 20),
                              (10, 'Departmant 10', '89990202809', 21);
INSERT INTO Employee VALUES(1, 1, 'Заведующий', 'fio 1', 50000),
                           (2, 1, 'МедБрат', 'fio 2', 10000),
                           (3, 1, 'МедСестра', 'fio 3', 8000),
                           (4, 1, 'Терапевт', 'fio 4', 15000),
                           (5, 1, 'Интерн', 'fio 5', 5000),
                           (6, 1, 'Интерн', 'fio 6', 5000),
                           (7, 1, 'Санитар', 'fio 7', 15000),
                           (8, 1, 'Медсестра', 'fio 8', 15000),
                           (9, 1, 'Санитар', 'fio 9', 15000);

INSERT INTO Employee VALUES(10, 2, 'Заведующий', 'fio 10', 50000),
                            (11, 2, 'МедБрат', 'fio 11', 10000),
                            (12, 2, 'МедСестра', 'fio 12', 8000),
                            (13, 2, 'Терапевт', 'fio 13', 15000),
                            (14, 2, 'Интерн', 'fio 14', 5000);

INSERT INTO Employee VALUES(22, 3, 'Заведующий', 'fio 22', 450000),
                            (15, 4, 'Заведующий', 'fio 15', 50000),
                            (16, 5, 'Заведующий', 'fio 16', 150000),
                            (17, 6, 'Заведующий', 'fio 17', 350000),
                            (18, 7, 'Заведующий', 'fio 18', 250000),
                            (19, 8, 'Заведующий', 'fio 19', 50000),
                            (20, 9, 'Заведующий', 'fio 20', 150000),
                            (21, 10, 'Заведующий', 'fio 21', 50000);

INSERT INTO Drug VALUES(1, 'Medisions 1', 'manual', 50.9),
                        (2, 'Medisions 2', 'manual', 10.9),
                        (3, 'Medisions 3', 'manual', 150.9),
                        (4, 'Medisions 4', 'manual', 530.129),
                        (5, 'Medisions 5', 'manual', 5230.9),
                        (6, 'Medisions 6', 'manual', 510.9),
                        (7, 'Medisions 7', 'manual', 10.9),
                        (8, 'Medisions 8', 'manual', 30.9),
                        (9, 'Medisions 9', 'manual', 523.9),
                        (10, 'Medisions 10', 'manual', 53.9);

INSERT INTO Responses VALUES (1, 2, 1),
                             (2, 1, 2),
                             (3, 3, 10),
                             (4, 21, 7),
                             (5, 19, 9),
                             (6, 19, 3),
                             (7, 12, 4),
                             (8, 8, 5),
                             (9, 3, 3),
                             (10, 6, 6);

-- 1. SELECT c CASE
SELECT  d.id, 
        CASE 
            WHEN e.fio IS NULL THEN 'Отсутствует' 
            ELSE e.fio 
        END
FROM drug d LEFT JOIN responses r ON r.id_drug = d.id
            LEFT JOIN employee e ON e.id = r.id_empl; 

-- 2. Запрос с оконной функцией
SELECT e.id, 
       e.position,
       MAX(e.salary) OVER (PARTITION BY e.position) as max_salary,
       COUNT(*) OVER (PARTITION BY e.position) as amount_salary
FROM employee e JOIN department d ON d.id = e.id_department
WHERE d.id = 1;

-- 3. Запрос с GROUP BY и Having
SELECT e.position, MIN(e.salary)
FROM drug d JOIN responses r ON r.id_drug = d.id 
            JOIN employee e ON r.id_empl = e.id
GROUP BY(e.position)
HAVING AVG(e.salary) > (SELECT MIN(salary)
                        FROM employee);

DROP DATABASE RK2;

-- функция, возвращающая 1
CREATE FUNCTION one() RETURNS INT AS
$$
    SELECT 1 AS res;
$$
LANGUAGE SQL;
SELECT one();

-- функция, удаляющая сотружников с зарплатой < 10 000
CREATE FUNCTION getSalary() RETURNS void AS
$$
    DELETE FROM employee
    WHERE salary < 10000;
$$
LANGUAGE SQL;
SELECT getSalary();

-- функция, возвращающая только 1 строку
CREATE FUNCTION getDrug() RETURNS drug AS
$$
    SELECT * FROM drug
    WHERE id = 1;
$$
LANGUAGE SQL;
-- в таком случае возвращается просто кортеж
SELECT getDrug();

CREATE FUNCTION getDrugs() RETURNS SETOF drug AS
$$
    SELECT * FROM drug
    WHERE id % 2 = 0;
$$
LANGUAGE SQL;
-- в таком случае возвращается уже таблица
SELECT * FROM getDrugs();

-- функция, возвращающая таблицу
CREATE FUNCTION makeTable(a INT, b INT)
RETURNS TABLE (sum INT, mul INT) AS
$$
    SELECT a + e.id, b * e.id FROM employee e;
$$
LANGUAGE SQL;

SELECT * FROM maketable(2, 3);