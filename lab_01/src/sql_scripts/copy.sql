-- Active: 1700003274957@@127.0.0.1@5432@Schools
-- \copy addresses(id, town, street, house) from '/home/mshsvnv/Desktop/DB/lab_01/src/data/addresses.csv' delimiter ';' csv header;
\copy classes(id, id_school, grade, letter) from '/home/mshsvnv/Desktop/DB/lab_01/src/data/classes.csv' delimiter ';' csv header;
\copy lessons(id_teacher, id_class, title) from '/home/mshsvnv/Desktop/DB/lab_01/src/data/lessons.csv' delimiter ';' csv header;
\copy schools(id, id_address, construct_year, kind) from '/home/mshsvnv/Desktop/DB/lab_01/src/data/schools.csv' delimiter ';' csv header;
\copy students(id, id_class, full_name, gender, phone) from '/home/mshsvnv/Desktop/DB/lab_01/src/data/students.csv' delimiter ';' csv header;
\copy teachers(id, full_name, age, gender) from '/home/mshsvnv/Desktop/DB/lab_01/src/data/teachers.csv' delimiter ';' csv header;
