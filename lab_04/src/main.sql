-- Active: 1700003274957@@127.0.0.1@5432@Schools

-- Определяемую пользователем скалярную функцию 

-- Определить возраст школы относительно заданного года
CREATE OR REPLACE FUNCTION func_1(cur_year integer, constr_year integer)
  RETURNS integer
AS $$
    return cur_year - constr_year 
$$ LANGUAGE plpython3u;

SELECT id, func_1(2023, construct_year) AS years
FROM schools
WHERE func_1(2023, construct_year) < 10;

-- Пользовательскую агрегатную функцию 

-- Определить количество школ (тип задается), возраст которых больше заданного
CREATE OR REPLACE FUNCTION func_2(cur_year integer, kind TEXT)
RETURNS INT 
AS $$
    query = '''
        SELECT func_1(%d, construct_year) AS years
        FROM schools 
        WHERE kind = \'%s\';
            ''' %(cur_year, kind)

    res = plpy.execute(query)
    
    if res is not None:
        cnt = 0;

        for school in res:
            if school["years"] > 20:
                cnt += 1        
        return cnt

$$ LANGUAGE PLPYTHON3U;

SELECT func_2(2023, 'Лицей')


-- Определяемую пользователем табличную функцию

-- Получить рейтинговую таблицу уроков
CREATE OR REPLACE FUNCTION func_3()
RETURNS TABLE
(
    title TEXT,
    amount INT
)
AS $$
    query = '''
    SELECT title, COUNT(*) AS amount
    FROM lessons
    GROUP BY title
    ORDER BY amount ASC;
            '''

    res_query = plpy.execute(query)
    
    if res_query is not None:

        res = list()

        for cur_res in res_query:
            res.append(cur_res);
        
        return res

$$ LANGUAGE PLPYTHON3U;

SELECT * FROM func3();


-- Хранимая процедура

-- Добавляет нового ученика
CREATE OR REPLACE PROCEDURE prod_1
(
    id INT,
    id_class INT,
    full_name TEXT,
    gender CHARACTER,
    phone VARCHAR(11)
) 
AS $$
    plan = plpy.prepare("INSERT INTO students VALUES($1, $2, $3, $4, $5)", 
        ["INT", "INT", "TEXT", "CHARACTER", "VARCHAR(11)"])

    plpy.execute(plan, 
        [id, id_class, full_name, gender, phone])

$$ LANGUAGE plpython3u;

DELETE FROM students
WHERE full_name LIKE '%Савинова%';

CALL prod_1(15042003, '712', 'Савинова Мария', 'Ж', '88005353535');

SELECT *
FROM students
WHERE full_name LIKE '%Савинова%';

-- Триггер
-- Триггер AFTER.
-- Выводит сообщение при дабавлении информации в таблицу 'students'.

CREATE OR REPLACE FUNCTION trigger_info()
RETURNS TRIGGER
AS $$
    if TD["new"]["full_name"] == "Савинова Мария":
        plpy.notice(f"Такой студент уже есть!")
    else:
        plpy.notice(f"Инофрмация была добавлена в таблицу.")
$$ LANGUAGE PLPYTHON3U;

CREATE TRIGGER trigger_inseert AFTER INSERT ON students
FOR ROW EXECUTE PROCEDURE trigger_info();
INSERT INTO students(id, id_class, full_name, gender, phone) 
VALUES(15042004, '712', 'Савинова Мария', 'Ж', '88005353535');

DELETE FROM students
WHERE full_name LIKE '%Савинова%';

-- Тип данных
-- Получить информацию о школах, имеющих количество классов больше заданного
CREATE TYPE cur_school AS
(
    kind VARCHAR,
    town VARCHAR,
    count INT
);

CREATE OR REPLACE FUNCTION func_4(classes_amount INT)
RETURNS SETOF cur_school
AS $$
    query = '''
SELECT s.kind, a.town, n.count FROM
schools s JOIN addresses a ON s.id_address = a.id JOIN (SELECT id_school as id, COUNT(*) AS count
                                                       FROM classes
                                                       GROUP BY id_school) n ON n.id = s.id
WHERE n.count > %d;
            ''' %(classes_amount)

    res_query = plpy.execute(query)
    
    if res_query is not None:
        return res_query

$$ LANGUAGE PLPYTHON3U;

SELECT * 
FROM func_4(10)
ORDER BY count;