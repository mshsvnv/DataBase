-- 1. Хранимую процедуру без параметров или с параметрами
-- Обновить год постройки для для обычных школ
CREATE OR REPLACE PROCEDURE prod1(year INT)
AS $$
BEGIN
    UPDATE schools
        SET construct_year = schools.construct_year + year
    WHERE kind IS NULL AND schools.construct_year < 2000;
END;
$$ LANGUAGE PLPGSQL;

CALL prod1(10);

SELECT * FROM schools
WHERE kind IS NULL;

DROP PROCEDURE IF EXISTS prod1;

-- 2. Рекурсивную хранимую процедуру или хранимую процедур срекурсивным ОТВ
CREATE OR REPLACE PROCEDURE prod2(cnt INT)
AS $$
BEGIN
    IF cnt > 0 THEN
        RAISE NOTICE 'ID, title, name: % % %',
        cnt,

        (SELECT l.title
        FROM teachers t JOIN lessons l ON l.id_teacher = t.id
        WHERE t.id = cnt
        LIMIT 1),

        (SELECT t.full_name
        FROM teachers t JOIN lessons l ON l.id_teacher = t.id
        WHERE t.id = cnt
        LIMIT 1);

        CALL prod2(cnt - 1);
    ELSE
        RAISE NOTICE 'Stop';
    END IF;
END;
$$ LANGUAGE PLPGSQL;

CALL prod2(0);
DROP PROCEDURE IF EXISTS prod2;

-- 3. Хранимую процедуру с курсором
-- Подсчитать кол-во школ, построенных после определенного года 
CREATE OR REPLACE PROCEDURE prod3(year INT)
AS $$
DECLARE
    cur CURSOR FOR
        SELECT construct_year
        FROM schools
        WHERE construct_year >= year;
    cur_year TEXT;
    cnt INT;
BEGIN
    cnt := 0;
    OPEN cur;
    LOOP 
        FETCH NEXT FROM cur INTO cur_year;
        EXIT WHEN NOT FOUND;

        IF cur_year::INT >= year THEN
            cnt := cnt + 1;
        END IF;

    END LOOP;
    CLOSE cur;
    RAISE NOTICE 'Кол-во школ, построенных после %: %', year, cnt;
END;
$$ LANGUAGE PLPGSQL;

CALL prod3(2003);
DROP PROCEDURE IF EXISTS prod3;

-- 4. Хранимую процедуру доступа к метаданным
CREATE OR REPLACE PROCEDURE prod4(my_table TEXT)
AS $$
DECLARE
    cur CURSOR FOR
        SELECT * 
        FROM information_schema.columns
        WHERE table_name = my_table;
    metadata record;
BEGIN
    OPEN cur;
    LOOP 
        FETCH NEXT FROM cur INTO metadata;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE '%; %', metadata.column_name, metadata.data_type;
    END LOOP;
    CLOSE cur;
END;
$$ LANGUAGE PLPGSQL;

CALL prod4('students');
DROP PROCEDURE IF EXISTS prod4;