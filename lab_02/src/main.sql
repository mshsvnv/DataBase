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
-- Вывести студентов классов, в которых учится Павел
-- SELECT DISTINCT id_class, id, full_name FROM students S1
-- WHERE EXISTS (SELECT id, id_class, full_name 
--               FROM students S2
--               WHERE S2.full_name LIKE '%Павел%' 
--                     AND S1.id_class = S2.id_class)

-- 16
-- INSERT INTO teachers (id, full_name, age, gender)
-- VALUES (112233, 'Иванов Иван Иванович', 65, 'М');

-- 20
-- DELETE addresses
-- WHERE town LIKE '%Москва%';