from faker import Faker
import csv
import random as r
from datetime import datetime

fake = Faker("ru_RU")

addressesNum = 1000
schoolsNum = addressesNum
schools = [i for i in range(1, schoolsNum + 1)]

teachersNum = schoolsNum * 5

studentsNum = 0
classesNum = 0

subjects = ["Математика", "Русский язык", "Литература", 
            "Физика", "Химия", "Биология", "География", 
            "История", "Обществознание", "Английский язык", 
            "Немецкий язык", "Французский язык", "Испанский язык", 
            "Музыка", "Изобразительное искусство", 
            "Физическая культура", "Технология", "Информатика", "ОБЖ"] 

def generateNumber():

    number = "8"
    for i in range(10):
        number += str(r.randint(0, 9))

    return number

# addresses

with open("./data/addresses.csv", mode = 'w') as file:
    writer = csv.writer(file, delimiter=';', lineterminator='\n')
    
    writer.writerow(("id", "town", "street", "house"))

    for i in range(addressesNum):
        address = fake.address().split(",")
        
        town = address[0]
        street = address[1]
        house = r.randint(1, 400)
    
        writer.writerow((i + 1, town, street, house))

# schools

addresses = [i + 1 for i in range(addressesNum)]

with open("./data/schools.csv", mode = 'w') as file:

    writer = csv.writer(file, delimiter=';', lineterminator='\n')
    
    writer.writerow(("id", "id_address", "construct_year", "type"))

    types = ["Лицей", "Гимназия", ""]

    for i in range(schoolsNum):

        address = r.choice(addresses)
        addresses.remove(address)
        
        year = r.randint(1850, 2023)
        typeS = r.choice(types)

        writer.writerow((i + 1, address, year, typeS))

# teachers

with open("./data/teachers.csv", mode = 'w') as file:

    writer = csv.writer(file, delimiter=';', lineterminator='\n')
    
    writer.writerow(("id", "full_name", "age", "gender"))

    for i in range(teachersNum):
        
        id_school = r.randint(1, schoolsNum + 1)

        name = fake.name()
        gender = "М" if name[-1] != "а" else "Ж"

        age = r.randint(25, 65)

        writer.writerow((i + 1, name, age, gender))


# classes

with open("./data/classes.csv", mode = 'w') as file:
    writer = csv.writer(file, delimiter=';', lineterminator='\n')
    
    writer.writerow(("id", "id_school", "grade", "letter"))

    t = 0
    for i in range(schoolsNum):

        school = r.choice(schools)
        schools.remove(school)

        for j in range(11):

            amount = r.randint(1, 3)
            classesNum += amount

            for k in range(amount):
                studentsNum += r.randint(10, 15)
                t += 1

                writer.writerow((t, school, j + 1, str(chr(k + 65))))

# students

with open("./data/students.csv", mode = 'w') as file:

    writer = csv.writer(file, delimiter=';', lineterminator='\n')

    writer.writerow(("id", "id_class", "full_name", "gender", "phone"))

    for i in range(studentsNum):
        id_class = r.randint(1, classesNum)

        name = fake.name()
        gender = "М" if name[-1] != "а" else "Ж"
        phone = generateNumber()

        writer.writerow((i + 1, id_class, name, gender, phone))

pairs = []

with open("./data/lessons.csv", mode = 'w') as file:

    writer = csv.writer(file, delimiter=';', lineterminator='\n')

    writer.writerow(("id_teacher", "id_class", "title",))

    for i in range(classesNum):

        amount = r.randint(10, 15)

        for i in range(amount):

            pair = (r.randint(1, teachersNum),
                    r.randint(1, classesNum))
            
            while (pair in pairs):
                pair = (r.randint(1, teachersNum),
                        r.randint(1, classesNum))
                
            titile = r.choice(subjects)

            writer.writerow((pair[0], pair[1], titile))