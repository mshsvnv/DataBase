CREATE TABLE IF NOT EXISTS adresses 
(
    id serial,
    town varchar(100),
    street varchar(100),
    house int
);

CREATE TABLE IF NOT EXISTS schools 
(
    id serial,
    id_adress int,
    construct_year int,
    kind varchar(10)
);

CREATE TABLE IF NOT EXISTS classes
(
    id serial,
    id_school int,
    grade int, 
    letter char
);

CREATE TABLE IF NOT EXISTS puples 
(
    id serial,
    id_class int,
    full_name text,
    gender char,
    phone varchar(11)
);

CREATE TABLE IF NOT EXISTS lessons
(
    id_teacher int,
    id_class int,
    title text
);

CREATE TABLE IF NOT EXISTS teachers
(
    id serial,
    full_name text,
    age int, 
    gender char
);