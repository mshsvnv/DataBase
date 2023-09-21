COPY addresses
FROM 'C:\Users\mshsv\OneDrive\Рабочий стол\studying\5_sem\DataBase\lab_01\src\data\addresses.csv'
WITH (format csv,
    header,
    delimiter ";");

COPY teachers
FROM 'C:\Users\mshsv\OneDrive\Рабочий стол\studying\5_sem\DataBase\lab_01\src\data\teachers.csv'
WITH (format csv,
    header,
    delimiter ";");

COPY schools
FROM 'C:\Users\mshsv\OneDrive\Рабочий стол\studying\5_sem\DataBase\lab_01\src\data\schools.csv'
WITH (format csv,
    header,
    delimiter ";");

COPY classes
FROM 'C:\Users\mshsv\OneDrive\Рабочий стол\studying\5_sem\DataBase\lab_01\src\data\classes.csv'
WITH (format csv,
    header,
    delimiter ";");

COPY lessons
FROM 'C:\Users\mshsv\OneDrive\Рабочий стол\studying\5_sem\DataBase\lab_01\src\data\lessons.csv'
WITH (format csv,
    header,
    delimiter ";");

COPY students
FROM 'C:\Users\mshsv\OneDrive\Рабочий стол\studying\5_sem\DataBase\lab_01\src\data\students.csv'
WITH (format csv,
    header,
    delimiter ";");