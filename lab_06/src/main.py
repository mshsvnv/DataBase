from schoolsDB import SchoolsDB

class Menu:

    def __init__(self):
        self.msg = "\n\t\tМеню\n\n"\
                    "1. Выполнить скалярный запрос \n"\
                    "2. Выполнить запрос с несколькими соединениями (JOIN) \n"\
                    "3. Выполнить запрос с ОТВ(CTE) и оконными функциями \n"\
                    "4. Выполнить запрос к метаданным \n"\
                    "5. Вызвать скалярную фуclнкцию \n"\
                    "6. Вызвать многооператорную табличную функцию \n"\
                    "7. Вызвать хранимую процедуру \n"\
                    "8. Вызвать системную функцию \n"\
                    "9. Создать таблицу в базе данных, соответствующую тематике БД \n"\
                    "10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT \n"\
                    "0. Выход \n\n"\
                    "Выбор: "\
    
    def run(self):
        try:
            command = int(input(self.msg))
        except:
            command = -1
        
        if not (0 <= command <= 10):
            print("\nОжидался ввод целого числа от 0 до 10")

        return command
        


if __name__ == "__main__":

    menu = Menu()
    DataBase = SchoolsDB()

    command = menu.run()

    while (1 <= command <= 10):

        DataBase.funcs[command - 1]()

        command = menu.run()
     


