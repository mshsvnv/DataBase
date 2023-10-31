-- 1. Скалярная функция
-- Вывести кол-во детей, обучающихся в школе с заданным номером
CREATE OR REPLACE FUNCTION FUNC1(schoolNum INT) 
RETURNS INT AS $$
BEGIN
    RETURN (
    SELECT COUNT(*)
    FROM students st JOIN classes c ON c.id = st.id 
    WHERE c.id_school = schoolNum);
END
$$ LANGUAGE PLPGSQL;
SELECT id, FUNC1(id) AS amount
FROM schools;
DROP FUNCTION IF EXISTS FUNC1;

-- 2. Подставляемая табличная функция
-- Выести учителей-женщин, возраст которых больше заданного и преподающих Физику
CREATE OR REPLACE FUNCTION FUNC2(ageNew INT) RETURNS 
TABLE (full_name TEXT,
       age INT)
AS $$
BEGIN
    RETURN QUERY
    SELECT t.full_name, t.age
    FROM teachers t JOIN lessons l on t.id = l.id_teacher
    WHERE t.gender = 'Ж' AND l.title = 'Физика' AND t.age > ageNew;
END
$$ LANGUAGE PLPGSQL;
SELECT *
FROM FUNC2(33);
DROP FUNCTION IF EXISTS FUNC2;

-- 3. Многооператорная табличная функция
-- Вывести школы, сгруппированные по типу, их кол-во, средний год постройки
CREATE OR REPLACE FUNCTION FUNC3() RETURNS 
TABLE(kind TEXT, cnt INT, avg FLOAT) 
AS $$
BEGIN
    CREATE TABLE tmp(kind TEXT, cnt INT, avg FLOAT);

    INSERT INTO tmp
    SELECT s.kind, COUNT(*) AS amount, AVG(s.construct_year)
    FROM schools s
    GROUP BY s.kind
    ORDER BY amount DESC;      

    RETURN QUERY
    SELECT * FROM tmp;   
END
$$ LANGUAGE PLPGSQL;
SELECT *
FROM FUNC3();
DROP FUNCTION IF EXISTS FUNC3;
DROP TABLE IF EXISTS tmp;

-- 4. Рекурсивная функция
-- Получить цепочку друзей
DROP TABLE IF EXISTS friends;
CREATE TABLE IF NOT EXISTS friends(
    id INT, 
    full_name TEXT,
    id_friend INT
);

INSERT INTO friends VALUES
    (1, 'Иванов Иван', 2),
    (2, 'Петров Петр', 3),
    (3, 'Федоров Федор', 4),
    (4, 'Александров Александр', NULL);

SELECT * FROM friends;

CREATE OR REPLACE FUNCTION FUNC4(id_start INT) RETURNS
TABLE(id INT, full_name TEXT, id_friend INT) 
AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE friends_rec(id, full_name, id_friend) AS (
        -- нерекурсивная часть
        SELECT f.id, f.full_name, f.id_friend
        FROM friends f
        WHERE f.id = id_start

        UNION ALL
        -- нерекурсивная часть
        SELECT f.id, f.full_name, f.id_friend
        FROM friends f JOIN friends_rec fk ON f.id = fk.id_friend)

        SELECT *
        FROM friends_rec;
END
$$ LANGUAGE PLPGSQL;

SELECT *
FROM FUNC4(1);

DROP FUNCTION IF EXISTS FUNC4;

-- расчет чиел Фибоначчи до заданого
CREATE OR REPLACE FUNCTION fib(end_val INT) RETURNS
TABLE(prev_val INT, cur_val INT, step INT)
AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE fib_num(prev_val, cur_val, step) AS (
        VALUES (1, 1, 1)
    
        UNION ALL
        
        SELECT fb.cur_val, fb.prev_val + fb.cur_val, fb.step + 1
        FROM fib_num fb
        WHERE fb.step < end_val)

    SELECT * FROM fib_num;
END
$$ LANGUAGE PLPGSQL;

SELECT * FROM fib(4);
DROP FUNCTION IF EXISTS fib;