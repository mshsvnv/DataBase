import psycopg2
from prettytable import PrettyTable

class SchoolsDB:

    def __init__(self):

        try:
            self.__connection = psycopg2.connect(
                    database='Школы',
                    user='postgres', 
                    password='m20031504',
                    host='127.0.0.1',
                    port="5432"
                    )
            
            self.__connection.autocommit = True
            self.__cursor = self.__connection.cursor()

            self.x = PrettyTable()
            self.rows = []

            print("PostgreSQL connection opened!\n")

            self.funcs = [self.get_avg_construct_year, 
                          self.get_lessons_info,
                          self.get_school_town_info,
                          self.get_school_town_metha_data,
                          self.call_scalar_func,
                          self.call_table_func,
                          self.call_stored_prod, 
                          self.call_system_func, 
                          self.create_data_base,
                          self.insert_data_base]

        except Exception as ex:
            print("Error while connecting with PostgreSQL!\n", ex)
            return
        
    def print(self):
        
        for row in self.rows:
            self.x.add_row(row)
        
        print(self.x)

    def __del__(self):

        if self.__connection:

            self.__cursor.close()
            self.__connection.close()
            print("PostgreSQL connection closed\n")
    
    def __sql_executer(self, sql_query):

        try:
            self.__cursor.execute(sql_query)
        except Exception as err:
            print("Error while get query - PostgreSQL\n", err)
            return
    
        return sql_query
    
    # 1. Скалаярный запрос
    def get_avg_construct_year(self):

        print("Вывести средний год постройки школ.")

        sql_query = """ 
                    SELECT AVG(construct_year)
                    FROM schools
                    """
        
        if (self.__sql_executer(sql_query) is not None):
            row = self.__cursor.fetchone()

            print(row[0])
        
    # 2. Выполнить запрос с несколькими соединениями (JOIN)
    def get_lessons_info(self):

        print("Вывести информацию о предметах, классе, преподавателе.")

        sql_query = """ 
                    SELECT t.id, t.full_name, cl.id, cl.grade
                    FROM lessons l 
                    JOIN teachers t ON t.id = l.id_teacher
                    JOIN classes cl ON cl.id = l.id_class
                    LIMIT 10
                    """
    
        if (self.__sql_executer(sql_query) is not None):
            self.rows = self.__cursor.fetchall()

            self.x.field_names = ["id_teacher", "fio_teacher", "id_class", "grade"]

            self.print()

    # 3. Выполнить запрос с ОТВ(CTE) и оконными функциями
    def get_school_town_info(self):

        print("Вывести информацию о городе, среднем годе постройки для каждого типа.")

        sql_query = """
                    WITH schools_info (town, kind, construct_year) AS 
                    (
                        SELECT ad.town, s.kind, s.construct_year
                        FROM addresses ad 
                        JOIN schools s on s.id_address = ad.id
                    )
                    SELECT s.town, s.kind,
                    AVG(s.construct_year) OVER (PARTITION BY s.town, s.kind) as avg_year,
                    ROW_NUMBER() OVER (PARTITION BY s.town) as amount
                    FROM schools_info s
                    ORDER BY s.town
                    """
        
        if (self.__sql_executer(sql_query) is not None):
            self.rows = self.__cursor.fetchall()

            self.x.field_names = ["town", "kind", "avg_year", "amount"]

            self.print()

    # 4. Выполнить запрос к метаданным;
    def get_school_town_metha_data(self):

        tableName = input("Вывести информацию для таблицы: ")

        sql_query = f"""
                    SELECT column_name, data_type
                    FROM information_schema.columns
                    WHERE table_name = '{tableName}';
                    """

        if (self.__sql_executer(sql_query) is not None):
            self.rows = self.__cursor.fetchall()

            self.x.field_names = ["column_name", "data_type"]

            self.print()

    # 5 Вызвать скалярную функцию;
    def call_scalar_func(self):

        num = input("Вывести кол-во детей, обучающихся в школе с заданным номером: ")

        sql_query = f"""
                    CREATE OR REPLACE FUNCTION FUNC1(schoolNum INT) 
                    RETURNS INT AS $$
                    BEGIN
                        RETURN (
                        SELECT COUNT(*)
                        FROM students st JOIN classes c ON c.id = st.id 
                        WHERE c.id_school = schoolNum);
                    END
                    $$ LANGUAGE PLPGSQL;

                    SELECT id, FUNC1(({num})::int) AS amount
                    FROM schools;
                    """
        
        if (self.__sql_executer(sql_query) is not None):

            self.rows = self.__cursor.fetchall()

            self.x.field_names = ["id", "amount"]

            self.print()

    # 6. Вызвать многооператорную или табличную функцию (написанную в третьей лабораторной работе);
    def call_table_func(self):

        print("Вывести информацию о среднем годе постройки для каждого типа школы")

        sql_query = f"""
                    CREATE OR REPLACE FUNCTION FUNC3() RETURNS 
                    TABLE(kind TEXT, cnt INT, avg FLOAT) 
                    AS $$
                    BEGIN
                        CREATE TABLE tmp(kind TEXT, cnt INT, avg FLOAT);

                        INSERT INTO tmp
                        SELECT s.kind, COUNT(*) AS amount, AVG(s.construct_year)
                        FROM schools s
                        GROUP BY s.kind
                        ORDER BY amount DESC;      

                        RETURN QUERY
                        SELECT * FROM tmp;   
                    END
                    $$ LANGUAGE PLPGSQL;
                    SELECT *
                    FROM FUNC3();
                    """
        
        if (self.__sql_executer(sql_query) is not None):

            self.rows = self.__cursor.fetchall()

            self.x.field_names = ["kind", "cnt", "avg"]

            self.print()


    # 7. Вызвать хранимую процедуру (написанную в третьей лабораторной работе);
    def call_stored_prod(self):

        num = input("Обновить обычные школы с заданным годом\nВвести год постройки школы: ")

        sql_query = f"""
                    CREATE OR REPLACE PROCEDURE prod1(year INT)
                    AS $$
                    BEGIN
                        UPDATE schools
                            SET construct_year = schools.construct_year + year
                        WHERE kind IS NULL AND schools.construct_year = year;
                    END;
                    $$ LANGUAGE PLPGSQL;

                    CALL prod1({num});

                    SELECT id, construct_year, kind FROM schools
                    WHERE kind IS NULL
                    ORDER BY year;
                    """
        
        if (self.__sql_executer(sql_query) is not None):

            self.rows = self.__cursor.fetchall()

            self.x.field_names = ["id", "year", "kind"]

            self.print()

    # 8. Вызвать системную функцию или процедуру;
    def call_system_func(self):
        
        print("Вызвать системную функцию для вывода имени текущей базы данных\n")

        sql_query = f"""
                    SELECT *
                    FROM current_database();
                    """
        
        if self.__sql_executer(sql_query) is not None:

            row = self.__cursor.fetchone()

            print("Результат: ", row)

    # 9. Создать таблицу в базе данных, соответствующую тематике БД;
    def create_data_base(self):
        
        print("Создать таблицу школьников-друзей\n")

        sql_query = f"""
                    DROP TABLE IF EXISTS friends;

                    CREATE TABLE IF NOT EXISTS friends
                    (
                        id INT, 
                        fio TEXT, 
                        id_class INT,
                        id_friend INT
                    );
                    """
        
        if self.__sql_executer(sql_query) is not None:

            print("Success!")

    # 10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY
    def insert_data_base(self):
        
        print("Создать таблицу преподавателей, женщшин\n")

        sql_query = f"""
                    INSERT INTO friends(id, fio, id_class, id_friend) VALUES
                    (1, 'Иванов ИИ', 34, 3),
                    (2, 'Смирнов СС', 36, 1),
                    (3, 'Петров ПП', 29, 4),
                    (4, 'Сидоров АВ', 22, 2); 

                    SELECT * FROM friends;
                    """
        
        if (self.__sql_executer(sql_query) is not None):

            self.rows = self.__cursor.fetchall()

            self.x.field_names = ["id", "fio", "id_class", "id_friend"]

            self.print()