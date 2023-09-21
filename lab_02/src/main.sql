-- -- 1
-- SELECT * FROM classes
-- WHERE grade > 5 and letter = 'A'
-- ORDER BY letter;

-- -- 2
-- SELECT DISTINCT id, full_name
-- FROM teachers
-- WHERE age BETWEEN 30 and 40
-- ORDER BY full_name;

-- -- 3
-- SELECT id, town, house
-- FROM addresses
-- WHERE street LIKE '%ул%' 
-- ORDER BY house;

-- -- 4
-- SELECT * FROM lessons
-- WHERE id_class IN (SELECT id
--                    FROM classes
--                    WHERE grade BETWEEN 5 AND 8);