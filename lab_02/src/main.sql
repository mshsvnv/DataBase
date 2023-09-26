-- -- 1
-- Выбрать уроки, возраст учителей которых больше 40
-- SELECT *
-- FROM lessons L JOIN teachers T ON L.id_teacher = T.id;
-- WHERE T.age > 40
-- ORDER BY T.age;

-- 2
-- Выбрать преподавтелей, возраст которых от 20 до 30
-- SELECT *
-- FROM teachers
-- WHERE age BETWEEN 20 AND 30 AND gender='Ж'
-- ORDER BY full_name;

-- 3
-- Вывести все улицы
-- SELECT *
-- FROM addresses
-- WHERE street LIKE ' ул%' 
-- ORDER BY house;

-- 4
-- Вывести предметы для 5-8 классов
-- SELECT * FROM lessons
-- WHERE id_class IN (SELECT id
--                    FROM classes
--                    WHERE grade BETWEEN 5 AND 8)
-- ORDER BY title;

-- 5
-- Вывесим студентов из A класса
-- SELECT * FROM students
-- WHERE EXISTS (SELECT classes.id
--               FROM classes
--               WHERE classes.id = students.id_class AND classes.letter = 'A');

-- 6
-- Вывести самых взрослых преподавателей мужчин
-- SELECT * FROM teachers
-- WHERE gender = 'М' AND age >= ALL (SELECT age
--                                    FROM teachers
--                                    WHERE gender = 'М');

-- -- 7
-- Средний возраст преподавателей по гендеру
-- SELECT gender, AVG(age) AS aver_age
-- FROM teachers
-- GROUP BY gender;

-- 8
-- Вывести учеников и их букву класса
-- SELECT *, 
--     (SELECT classes.letter FROM classes
--     WHERE classes.id = students.id_class) AS class_letter
-- FROM students
-- ORDER BY id_class;

-- 9
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
-- Учеников 100го класса в одну таблицу
-- SELECT *
-- INTO class 
-- FROM students
-- WHERE students.id_class = 100;

-- DROP TABLE class;

-- 12
-- Вывести 10е классы
-- SELECT *
-- FROM lessons JOIN (SELECT *
--                    FROM classes
--                    WHERE grade = 10) AS C ON C.id = lessons.id_class
-- ORDER BY title;

-- 13
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
-- SELECT kind, AVG(construct_year) as average
-- FROM schools
-- GROUP BY kind;

-- 15
-- Вывести школы по категориям, ср. зн-ие года постройки меньше общего значения
-- SELECT kind, AVG(construct_year) as average
-- FROM schools
-- GROUP BY kind
-- HAVING AVG(construct_year) < (SELECT AVG(construct_year)
--                          FROM schools);

-- 16
-- INSERT INTO teachers (id, full_name, age, gender)
-- VALUES (112233, 'Иванов Иван Иванович', 65, 'М');

-- 17
-- INSERT INTO lessons (id_teacher, id_class, title)
--     SELECT * FROM lessons
--     WHERE title = 'Биология' 
--     AND id_class IN (SELECT id
--                       FROM classes
--                       WHERE letter = 'A');

-- 18
-- Продлим молодость 65 летним на 5 лет
-- UPDATE teachers
-- SET age = age - 5
-- WHERE age = 65;

-- 19
-- Заменяем для гимназий год постройки на среднее значение
-- UPDATE schools
-- SET construct_year = (SELECT AVG(construct_year)
--                       FROM schools)
-- WHERE kind = 'Гимназия';

-- 20
-- DELETE teachers
-- WHERE full_name = 'Иванов Иван Иванович';

-- 21
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
-- WITH ST_10 AS
--     (SELECT * from students
--     WHERE id_class IN (SELECT id
--                        FROM classes
--                        WHERE grade = 10 and letter = 'A'))

-- SELECT * FROM ST_10;

-- 23
-- TODO

-- 24
-- SELECT *, 
--     AVG(construct_year) OVER (PARTITION BY kind) AS aver,
--     COUNT(*) OVER (PARTITION BY kind) AS count
-- FROM schools
-- WHERE construct_year > 2000;

-- 25
-- TODO