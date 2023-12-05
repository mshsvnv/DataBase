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
                          self.get_school_town_info]

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
    # 5 Вызвать скалярную функцию (написанную в третьей лабораторной работе);
    # 6. Вызвать многооператорную или табличную функцию (написанную в третьей лабораторной работе);
    # 7. Вызвать хранимую процедуру (написанную в третьей лабораторной работе);
    # 8. Вызвать системную функцию или процедуру;
    # 9. Создать таблицу в базе данных, соответствующую тематике БД;
    # 10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY