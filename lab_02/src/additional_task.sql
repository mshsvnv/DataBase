-- Active: 1696673577093@@127.0.0.1@5432@task
CREATE TABLE IF NOT EXISTS table1(
    id INT,
    var1 TEXT,
    valid_from_dttm DATE DEFAULT '5999-12-31',
    valid_to_dttm DATE DEFAULT '5999-12-31'
);

CREATE TABLE IF NOT EXISTS table2(
    id INT,
    var2 TEXT,
    valid_from_dttm DATE DEFAULT '5999-12-31',
    valid_to_dttm DATE DEFAULT '5999-12-31'
);

INSERT INTO table1(ID, var1, valid_from_dttm, valid_to_dttm)
VALUES
    (1, 'A', '2018-09-01', '2018-09-15'),
    (1, 'B', '2018-09-16', '5999-12-31'),
    (2, 'B', '2018-09-16', '5999-12-31');

INSERT INTO table2(ID, var2, valid_from_dttm, valid_to_dttm)
VALUES
    (1, 'A', '2018-09-01', '2018-09-18'),
    (1, 'B', '2018-09-19', '5999-12-31');

SELECT * FROM table1;
SELECT * FROM table2;

DROP TABLE IF EXISTS table1, table2;

WITH from_dttm AS (
    SELECT id, valid_from_dttm FROM table1
    UNION
    SELECT id, valid_from_dttm FROM table2
),
to_dttm AS (
    SELECT id, valid_to_dttm FROM table1
    UNION
    SELECT id, valid_to_dttm FROM table2
),
ranges AS (
    SELECT fd.id, fd.valid_from_dttm, MIN(td.valid_to_dttm) AS valid_to_dttm
    FROM from_dttm fd JOIN to_dttm td ON fd.id = td.id 
    AND fd.valid_from_dttm < td.valid_to_dttm
    GROUP BY fd.id, fd.valid_from_dttm 
)
SELECT r.id,
       t1.var1, t2.var2,
       r.valid_from_dttm, r.valid_to_dttm
FROM ranges r
LEFT JOIN table1 t1 ON t1.id = r.id AND t1.valid_from_dttm <= r.valid_to_dttm AND t1.valid_to_dttm >= r.valid_from_dttm
LEFT JOIN table2 t2 ON t2.id = r.id AND t2.valid_from_dttm <= r.valid_to_dttm AND t2.valid_to_dttm >= r.valid_from_dttm
ORDER BY r.id, r.valid_from_dttm;