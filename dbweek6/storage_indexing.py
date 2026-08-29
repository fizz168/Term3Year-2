import random
import string
import mysql.connector

DB_HOST = "localhost"
DB_USER = "root"
DB_PASSWORD = "omra1234"
DB_NAME = "big_data_db"

def generate_data():
    countries = [
        "Australia", "Brunei", "Cambodia", "Canada",
        "Vietnam", "France", "Germany", "India",
        "Indonesia", "Italy", "Japan", "Laos",
        "Malaysia", "Myanmar", "Norway", "Singapore",
        "Spain", "Thailand", "United Kingdom", "United States"
    ]

    name = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(10))
    email = f"{name.lower()}@{random.randint(1,100)}.com"
    age = random.randint(18,65)
    country = random.choice(countries)

    return name, email, age, country

connection = mysql.connector.connect(
    host='localhost',
    user="root",
    password="omra1234",
    database="big_data_db"
)

cursor = connection.cursor()

cursor.execute("""
CREATE TABLE IF NOT EXISTS facebook_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    age INT NOT NULL,
    country VARCHAR(255) NOT NULL
)
""")
connection.commit()
insertion_amount = 100
num_records = 600

i = 0

for k in range(insertion_amount):
    for _ in range(num_records):
        name, email, age, country = generate_data()

        insert_query = """
        INSERT INTO facebook_users (name, email, age, country)
        VALUES (%s, %s, %s, %s)
        """

        cursor.execute(insert_query, (name, email, age, country))

    connection.commit()
    i += 1
    print("Insertion round", i, num_records, "records")

print(f"Inserted total: {insertion_amount * num_records} records")

print("Start inserting...")