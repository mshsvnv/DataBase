-- по году постройки определить количество классов средних школ, где Ж больше М

CREATE TABLE IF NOT EXISTS tmp_classes(id_school INT, id_class INT, count INT, gender CHAR);
INSERT INTO tmp_classes (
    SELECT c.id_school, s.id_class, COUNT(*)
    FROM students s JOIN classes c ON c.id = s.id_class
    WHERE c.grade BETWEEN 5 AND 9
    GROUP BY c.id_school, s.id_class, s.gender
    ORDER BY c.id_school
);

SELECT * FROM tmp_classes;
CREATE OR REPLACE FUNCTION FUNC(year INT) 
RETURNS INT AS $$
BEGIN
    RETURN (
    SELECT COUNT(s.construct_year)
    FROM schools s JOIN (
        SELECT t1.id_school, COUNT(*)
        FROM tmp_classes t1 JOIN tmp_classes t2 ON t1.id_class = t2.id_class JOIN schools s ON s.id = t1.id_school
        WHERE t1.gender != t2.gender AND t1.gender = 'М' AND t1.count < t2.count
        GROUP BY t1.id_school) s2 ON s.id = s2.id_school
    WHERE s.construct_year = year);
END
$$ LANGUAGE PLPGSQL;

SELECT * FROM FUNC(2010);

DELETE IF EXISTS FUNCTION FUNC;