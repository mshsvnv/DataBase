
-- Триггер AFTER
-- Кинуть исключение при добавлении нового ученика в класс, id которого больше 1000
CREATE OR REPLACE FUNCTION info_student() 
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.id_class > 1000 THEN
        RAISE EXCEPTION 'Некорректный номер класса!';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE PLPGSQL; 

CREATE OR REPLACE TRIGGER info_student_trigger 
AFTER INSERT ON students
FOR EACH ROW EXECUTE PROCEDURE info_student();

INSERT INTO students VALUES
(275000, 1111, 'Алексеев Алексей', 'М', '89161234567');

DELETE FROM students
WHERE full_name = 'Алексеев Алексей';

DROP TRIGGER IF EXISTS info_student_trigger ON students;
DROP FUNCTION IF EXISTS info_student;

-- Триггер INSTEAD OF
-- Добавлять в класс, с индексом 15, только девочек
CREATE VIEW class_view AS
SELECT * FROM students
WHERE id_class = 15;

DROP VIEW IF EXISTS class_view;

SELECT * FROM class_view;

CREATE OR REPLACE FUNCTION insert_class() 
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.id_class != 15 THEN
        RAISE EXCEPTION 'Некорректный номер класса!';
    END IF;

    IF NEW.gender = 'М' THEN
        RAISE EXCEPTION 'Некорректное значение пола!';
    END IF;

    RETURN NEW;
END
$$ LANGUAGE PLPGSQL; 

CREATE OR REPLACE TRIGGER insert_class_trigger 
INSTEAD OF INSERT ON class_view
FOR EACH ROW EXECUTE PROCEDURE insert_class();

INSERT INTO class_view VALUES
(275000, 16, 'Алексеев Алексей', 'Ж', '89161234567');

DROP TRIGGER IF EXISTS insert_class_trigger ON class_view;
DROP FUNCTION IF EXISTS insert_class;
