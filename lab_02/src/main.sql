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

-- 16
-- INSERT INTO teachers (id, full_name, age, gender)
-- VALUES (112233, 'Иванов Иван Иванович', 65, 'М');

-- 20
-- DELETE addresses
-- WHERE town LIKE '%Москва%';