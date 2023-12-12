-- Active: 1696673577093@@127.0.0.1@5432@postgres

DROP FUNCTION IF EXISTS func;
DROP TABLE IF EXISTS workers;
CREATE TABLE IF NOT EXISTS workers(
    id INT,
    FIO TEXT,
    date_off DATE,
    Status TEXT
);

INSERT INTO workers(id, FIO, date_off, Status)
VALUES
    (1, 'Иванов ИИ', '12-12-2022', 'Работа offline'), 
    (1, 'Иванов ИИ', '13-12-2022', 'Работа offline'), 
    (1, 'Иванов ИИ', '14-12-2022', 'Больничный'),     
    (1, 'Иванов ИИ', '15-12-2022', 'Больничный'),     
    (1, 'Иванов ИИ', '16-12-2022', 'Удаленная работа'),  
    (2, 'Петров ПП', '12-12-2022', 'Работа offline'),  
    (2, 'Петров ПП', '13-12-2022', 'Работа offline'),  
    (2, 'Петров ПП', '13-12-2022', 'Удаленная работа'),
    (2, 'Петров ПП', '15-12-2022', 'Удаленная работа'),
    (2, 'Петров ПП', '16-12-2022', 'Работа offline');  
SELECT * FROM workers;

CREATE OR REPLACE FUNCTION func() RETURNS 
TABLE(IDD int, FIOO TEXT, DATE_FROM date, DATE_TO date, STATUSS TEXT) 
AS $$
DECLARE
    workerOld RECORD;
    workerNew RECORD;
    dateOld DATE;
    i INT;
BEGIN
    i := 0;
    FOR workerNew IN
        SELECT id, fio, date_off, Status
        FROM workers
    LOOP
        IF (i > 0) THEN
            IF (workerOld.Status != workerNew.Status OR workerOld.id != workerNew.id) THEN
                
                RETURN QUERY SELECT workerOld.id, workerOld.fio, dateOld, workerOld.date_off, workerOld.Status;
                
                dateOld := workerNew.date_off;
            END IF;
        ELSE
            dateOld := workerNew.date_off;
        END IF;

        workerOld := workerNew;

        i := i + 1;
        
    END LOOP;

    RETURN QUERY SELECT workerOld.id, workerOld.fio, dateOld, workerOld.date_off, workerOld.Status;
END;
$$ LANGUAGE PLPGSQL;
SELECT * FROM func();