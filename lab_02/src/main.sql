-- 1
-- Выбрать уроки, возраст учителей которых больше 40
-- Инструкция SELECT, использующая предикат сравнения
-- SELECT *
-- FROM lessons L JOIN teachers T ON L.id_teacher = T.id;
-- WHERE T.age > 40
-- ORDER BY T.age;

-- 2
-- Инструкция SELECT, использующая предикат BETWEEN.
-- Выбрать преподавтелей, возраст которых от 20 до 30
-- SELECT *
-- FROM teachers
-- WHERE age BETWEEN 20 AND 30 AND gender='Ж'
-- ORDER BY full_name;

-- 3
-- Инструкция SELECT, использующая предикат LIKE
-- Вывести все улицы
-- SELECT *
-- FROM addresses
-- WHERE street LIKE ' ул%' 
-- ORDER BY house;

-- 4
-- Инструкция SELECT, использующая предикат IN с вложенным подзапросом
-- Вывести предметы для 5-8 классов
-- SELECT * FROM lessons
-- WHERE id_class IN (SELECT id
--                    FROM classes
--                    WHERE grade BETWEEN 5 AND 8)
-- ORDER BY title;

-- 5
-- Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом
-- Вывесим студентов из A класса
-- SELECT * FROM students
-- WHERE EXISTS (SELECT classes.id
--               FROM classes
--               WHERE classes.id = students.id_class AND classes.letter = 'A');

-- 6
-- Инструкция SELECT, использующая предикат сравнения с квантором
-- Вывести самых взрослых преподавателей мужчин
-- SELECT * FROM teachers
-- WHERE gender = 'М' AND age >= ALL (SELECT age
--                                    FROM teachers
--                                    WHERE gender = 'М');

-- 7
-- Инструкция SELECT, использующая агрегатные функции в выражениях столбцов.
-- Средний возраст преподавателей по гендеру
-- SELECT gender, AVG(age) AS aver_age
-- FROM teachers
-- GROUP BY gender;

-- 8
-- Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов
-- Вывести учеников и их букву класса
-- SELECT *, 
--     (SELECT classes.letter FROM classes
--     WHERE classes.id = students.id_class) AS class_letter
-- FROM students
-- ORDER BY id_class;

-- 9
-- Инструкция SELECT, использующая простое выражение CASE
-- Направления изучения
-- SELECT *,
--     CASE kind
--         WHEN 'Гимназия'
--         THEN 'Гуманитарное'
--         WHEN 'Лицей'
--         THEN 'Техническое'
--     END AS direction
-- from schools
-- ORDER BY construct_year;

-- 10
-- Инструкция SELECT, использующая поисковое выражение CASE
-- Временные промежутки постройки школы
-- SELECT *,
--     CASE
--         WHEN Schools.construct_year < 1918
--         THEN 'Дореволюционная'
--         WHEN Schools.construct_year < 1991
--         THEN 'Советская'
--         ELSE 'Постсоветская'
--     END AS status
-- from schools;
        
-- 11
-- Создание новой временной локальной таблицы из результирующего набора
-- данных инструкции SELECT
-- Учеников 100го класса в одну таблицу
-- SELECT *
-- INTO class 
-- FROM students
-- WHERE students.id_class = 100;

-- DROP TABLE class;

-- 12
-- Инструкция SELECT, использующая вложенные коррелированные
-- подзапросы в качестве производных таблиц в предложении FROM.
-- Вывести 10е классы
-- SELECT *
-- FROM lessons JOIN (SELECT *
--                    FROM classes
--                    WHERE grade = 10) AS C ON C.id = lessons.id_class
-- ORDER BY title;

-- 13
-- Инструкция SELECT, использующая вложенные подзапросы с уровнем
-- вложенности 3.
-- Вывести предметы в Москве
-- SELECT *
-- FROM lessons
-- WHERE id_class IN (SELECT id
--                   FROM classes
--                   WHERE id_school IN (SELECT id
--                                      FROM schools
--                                      WHERE id_address IN (SELECT id
--                                                         FROM addresses
--                                                         WHERE town LIKE '%Москва%')));

-- 14
-- Инструкция SELECT, консолидирующая данные с помощью предложения
-- GROUP BY, но без предложения HAVING
-- SELECT kind, AVG(construct_year) as average
-- FROM schools
-- GROUP BY kind;

-- 15
-- Инструкция SELECT, консолидирующая данные с помощью предложения
-- GROUP BY и предложения HAVING
-- Вывести школы по категориям, ср. зн-ие года постройки меньше общего значения
-- SELECT kind, AVG(construct_year) as average
-- FROM schools
-- GROUP BY kind
-- HAVING AVG(construct_year) < (SELECT AVG(construct_year)
--                          FROM schools);

-- 16
-- Однострочная инструкция INSERT, выполняющая вставку в таблицу одной
-- строки значений.
-- INSERT INTO teachers (id, full_name, age, gender)
-- VALUES (112233, 'Иванов Иван Иванович', 65, 'М');

-- 17
-- Многострочная инструкция INSERT, выполняющая вставку в таблицу
-- результирующего набора данных вложенного подзапроса.
-- INSERT INTO lessons (id_teacher, id_class, title)
--     SELECT * FROM lessons
--     WHERE title = 'Биология' 
--     AND id_class IN (SELECT id
--                       FROM classes
--                       WHERE letter = 'A');

-- 18
-- Простая инструкция UPDATE.
-- Продлим молодость 65 летним на 5 лет
-- UPDATE teachers
-- SET age = age - 5
-- WHERE age = 65;

-- 19
-- Инструкция UPDATE со скалярным подзапросом в предложении SET
-- Заменяем для гимназий год постройки на среднее значение
-- UPDATE schools
-- SET construct_year = (SELECT AVG(construct_year)
--                       FROM schools)
-- WHERE kind = 'Гимназия';

-- 20
-- Простая инструкция DELETE
-- DELETE teachers
-- WHERE full_name = 'Иванов Иван Иванович';

-- 21
-- Инструкция DELETE с вложенным коррелированным подзапросом в
-- предложении WHERE
-- SELECT * FROM students
-- WHERE id in (SELECT id
--              FROM classes 
--              WHERE id_school = 2);

-- DELETE FROM students
-- WHERE id IN (SELECT id
--              FROM classes 
--              WHERE id_school = 2);

-- SELECT * FROM students
-- WHERE id in (SELECT id
--              FROM classes 
--              WHERE id_school = 2);

-- 22
-- Инструкция SELECT, использующая простое обобщенное табличное
-- выражение
-- WITH ST_10 AS
--     (SELECT * from students
--     WHERE id_class IN (SELECT id
--                        FROM classes
--                        WHERE grade = 10 and letter = 'A'))

-- SELECT * FROM ST_10;

-- -- 23
-- Инструкция SELECT, использующая рекурсивное обобщенное табличное
-- выражение
-- DROP TABLE IF EXISTS friends;

-- CREATE TABLE IF NOT EXISTS friends
-- (
--     id SERIAL NOT NULL PRIMARY KEY,
--     full_name TEXT,
--     id_friend INT
-- );

-- INSERT INTO friends (id, full_name, id_friend)
-- VALUES  (1,'Иван Иванов', 3),
--         (2,'Петя Петров', NULL),
--         (3,'Александр Александров', 4),
--         (4,'Василий Васильев', 2);

-- SELECT * FROM friends;

-- WITH RECURSIVE rec_friends (id, full_name, id_friend) AS 
-- (
--     SELECT f.id, f.full_name, f.id_friend
--     FROM friends AS f
--     WHERE f.id = 1
--     UNION ALL
--     SELECT f.id, f.full_name, f.id_friend
--     FROM friends AS f
--     JOIN rec_friends ON f.id = rec_friends.id_friend
-- )

-- SELECT * FROM rec_friends;

-- 24
-- Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
-- SELECT *, 
--     AVG(construct_year) OVER (PARTITION BY kind) AS aver,
--     COUNT(*) OVER (PARTITION BY kind) AS count
-- FROM schools
-- WHERE construct_year > 2000;

-- 25
-- Оконные фнкции для устранения дублей
-- WITH 
--     duplicate_schools AS (
--     SELECT *
--     FROM schools

--     UNION ALL

--     SELECT *
--     FROM schools
--     ),

--     not_duplicate_schools AS (
--         SELECT *, ROW_NUMBER() OVER (PARTITION BY id) AS num
--         FROM duplicate_schools
--     )

-- SELECT * 
-- FROM not_duplicate_schools
-- WHERE num = 1;