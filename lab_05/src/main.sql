-- 1. Из таблиц базы данных, созданной в первой лабораторной работе, извлечь данные в JSON.
-- Запись в json файл данных в виде массива данных

-- copy_to_json.sql
select row_to_json(s) from schools s;

-- 2. Выполнить загрузку и сохранение JSON файла в таблицу. Созданная таблица после всех
-- манипуляций должна соответствовать таблице базы данных, созданной  в первой лабораторной работе.

DROP TABLE IF EXISTS data_json, json_table, s_json_attr, schools_json, schools_json;
-- Преобразовать данные
drop table if exists schools_json;
create table if not exists schools_json 
(
    id serial,
    id_address int,
    construct_year int,
    kind varchar(10)
);

drop table if exists data_json;
create table if not exists data_json
(
    data jsonb
);

-- copy_from_json.sql

select *
from data_json;

with json_elements AS (
    select jsonb_array_elements(data) AS d
    from data_json
)
insert into schools_json
select
    (d::jsonb->>'id')::int,
    (d::jsonb->>'id_address')::int,
    (d::jsonb->>'construct_year')::int,
    (d::jsonb->>'kind')::varchar(10)
from json_elements;

select * from schools_json;

-- 3. Создать таблицу, в которой будет атрибут(ы) с типом JSON.
-- Заполнить атрибут правдоподобными данными с помощью команд INSERT/UPDATE.
drop table if exists s_json_attr;
create table if not exists s_json_attr
(
    kind varchar(10),
    info jsonb
);
insert into s_json_attr values
    ('Лицей', '{"school_num": 100, "stats": {"students": 1000, "rating": 0.4}}'),
    ('Гимназия', '{"school_num": 228, "stats": {"students": 500, "rating": 3.4}}'),
    ('Гимназия', '{"school_num": 15, "stats": {"students": 666, "rating": 6.6}}');
select *
from s_json_attr;

update s_json_attr
set info = '{"school_num": 0, "stats": {"students": 0, "rating": 0}}'
where kind = 'Лицей';

select * from s_json_attr;

-- 4. Выполнить следующие действия:

-- 1) Извлечь JSON фрагмент из JSON документа.
select
    kind,
    info->>'school_num' as school_num
from s_json_attr;

-- 2) Извлечь значения конкретных узлов или атрибутов JSON документа.
select
    kind,
    (info->'stats')->>'rating' as rating
from s_json_attr;

-- 3) Выполнить проверку существования узла или атрибута
select  *
from s_json_attr
where info is not null and (info->>'school_num')::int = 228;

-- 4) Изменить JSON
update s_json_attr
set info = NULL
where kind = 'Лицей';

select  *
from s_json_attr;

-- 5) Разделить JSON документ на несколько строк по узлам
drop table if exists json_table;
create table if not exists json_table
(
    data jsonb
);
-- copy.sql
select jsonb_array_elements(data)
from json_table;