-- ЗАДАНИЕ 1
CREATE TABLE IF NOT EXISTS Drivers (
    DriverID INT PRIMARY KEY,
    DriverLicense CHAR,
    FIO TEXT NOT NULL,
    Phone TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Cars (
    CarID INT PRIMARY KEY,
    Model TEXT,
    Color TEXT,
    Year INT DEFAULT 1995,
    RegistrationDate DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS Fines (
    FineID INT PRIMARY KEY,
    DriverID INT NOT NULL,
    FineType TEXT NOT NULL,
    Amount INT DEFAULT 0,
    FineDate DATE,
    FOREIGN KEY(DriverID) REFERENCES Drivers(DriverID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Car_Driver (
    ID INT PRIMARY KEY,
    DriverID INT,
    CarID INT,
    FOREIGN KEY(DriverID) REFERENCES Drivers(DriverID) ON DELETE CASCADE,
    FOREIGN KEY(CarID) REFERENCES Cars(CarID) ON DELETE CASCADE
);

DROP TABLE Drivers, Cars, Fines, Car_Driver; 

INSERT INTO Drivers VALUES (1, 'A', 'Иванов Иван', '8 916 772 21 11'),
                           (2, 'A', 'Петров Петр', '8 916 772 61 21'),
                           (3, 'B', 'Алексеев Алексей', '8 919 772 45 21'),
                           (4, 'B', 'Сидоров Андрей', '8 916 124 61 21'),
                           (5, 'C', 'Шевцов Федор', '8 991 726 13 21'),
                           (6, 'C', 'Федоров Федор', '8 926 752 61 21');

INSERT INTO Cars VALUES (1, 'Тойота', 'черный', 2000, '20.12.2000'),
                        (2, 'Форд', 'серый', 2010, '20.12.2000'),
                        (3, 'Форд', 'желтый', 1994, '20.12.1994'),
                        (4, 'Тойота', 'белый', 1999, '20.02.1999'),
                        (5, 'Сузуки', 'белый', 2023, '10.10.2023'),
                        (6, 'Мерседес', 'черный', 2022, '04.04.2022');

INSERT INTO Fines VALUES (1, 1, 'Превышение скорости', 1, '17.10.2023'),
                        (2, 4, 'Светофор', 1, '10.10.2023'),
                        (3, 4, 'Проезд под знак', 2, '17.10.2023'),
                        (4, 2, 'Превышение скорости', 3, '17.10.2023'),
                        (5, 1, 'Светофор', 3, '10.10.2023'),
                        (6, 6, 'Проезд под знак', 4, '10.10.2023'),
                        (7, 6, 'Превышение скорости', 1, '17.10.2023'),
                        (8, 2, 'Проезд под знак', 2, '10.10.2023'),
                        (9, 1, 'Проезд под знак', 1, '17.10.2023'),
                        (10, 1, 'Проезд под знак', 2, '10.10.2023'),
                        (11, 6, 'Превышение скорости', 1, '10.10.2023'),
                        (12, 2, 'Светофор', 20, '10.10.2023');

INSERT INTO Car_Driver VALUES (1, 1, 1),
                              (2, 1, 1),
                              (3, 3, 1),
                              (4, 6, 1),
                              (5, 3, 1),
                              (6, 3, 1);         
-- ЗАДАНИЕ 2

-- 1. SELECT с BETWEEN
-- Проверить, есть ли у людей с именем 'Федор' машины, регистрированные с 2000 до 2010
SELECT * 
FROM Cars c JOIN Car_Driver cd ON cd.CarID = c.CarID
WHERE year BETWEEN 2000 AND 2010 AND cd.DriverID IN (SELECT DriverID
                                                     FROM Drivers
                                                     WHERE FIO LIKE '%Федор%');     

-- 2. UPDATE со скалярным подзапросом в предложении SET
-- Изменить имя владельца на 'Иванова Ивана', если ID делится на 3
UPDATE Drivers 
SET FIO = (SELECT Drivers.fio
           FROM Drivers
           WHERE FIO = 'Иванов Иван')
WHERE DriverID % 3 = 0

-- 3. GROUP BY и HAVING
-- Сгруппировать штрафы по типу, и оставить у которых максимальное значение больше среднего во всей таблице
SELECT f.FineType, MAX(amount)
FROM Fines f
GROUP BY f.FineType
HAVING MAX(amount) > (SELECT AVG(amount)
                      FROM Fines);

-- ЗАДАНИЕ 3
-- Найти в текущей БД 5 самых меленьких таблиц

CREATE OR REPLACE FUNCTION foo() RETURNS
TABLE (name TEXT, volume TEXT) AS
$$
    SELECT table_name, pg_size_pretty(pg_total_relation_size(table_schema || '.' || table_name))  as volume
    FROM information_schema.tables WHERE table_schema = 'public'
    ORDER BY volume DESC
    LIMIT 3;
$$
LANGUAGE SQL;

SELECT * from foo();

                      

                    
                    

