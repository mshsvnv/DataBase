-- 1. Скалярная функция
-- Вывести кол-во детей, обучающихся в школе с заданным номером
CREATE OR REPLACE FUNCTION FUNC1(schoolNum INT) 
RETURNS INT AS $$
BEGIN
    RETURN (
    SELECT COUNT(*)
    FROM students st JOIN classes c ON c.id = st.id 
    WHERE c.id_school = schoolNum);
END;
$$ LANGUAGE PLPGSQL;
SELECT id, FUNC1(id) AS amount
FROM schools;
DROP FUNCTION FUNC1;

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
END;
$$ LANGUAGE PLPGSQL;
SELECT *
FROM FUNC2(33);
DROP FUNCTION FUNC2;

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
END;
$$ LANGUAGE PLPGSQL;
SELECT *
FROM FUNC3();
DROP FUNCTION FUNC3;

-- 4. Рекурсивная функция

-- 5. Функция с рекурсивным ОТВ