-- -- Active: 1700003274957@@127.0.0.1@5432@Schools
DROP FUNCTION def;
DROP TYPE school;
CREATE TYPE school AS
(
    id INT,
    count_lessons INT,
    count_schools INT
);
CREATE OR REPLACE FUNCTION def(town TEXT)
RETURNS SETOF school
AS $$
    query = f'''
SELECT c.id, COUNT(DISTINCT l.title) AS count_lessons, (SELECT COUNT(*)
                                                        FROM schools s1 JOIN addresses a ON s1.id_address = a.id 
                                                        WHERE a.town LIKE '%{town}%') AS count_schools
FROM lessons l JOIN classes c ON l.id_class = c.id 
               JOIN schools s ON c.id_school = s.id 
               JOIN addresses a ON a.id = s.id_address
WHERE a.town LIKE '%{town}%'
GROUP BY c.id;
            '''

    res_query = plpy.execute(query)
    
    if res_query is not None:
        return res_query

$$ LANGUAGE PLPYTHON3U;

SELECT * FROM def('Краснодар');