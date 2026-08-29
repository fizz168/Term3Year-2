# import mysql.connector
# import time

# def run_query():
#     start_time = time.time()
#     try:
#         conn = mysql.connector.connect(
#             host="localhost",
#             database="big_data_db",
#             user="root",
#             password="omra1234"
#         )
#         cursor = conn.cursor()
#         query = """
#         SELECT id, country, age
#         FROM facebook_users
#         WHERE country IN ('Cambodia', 'France', 'Laos', 'Japan', 'Canada')
#         AND age > 20
#         """
#         cursor.execute(query)

#         row_count = 0

#         for row in cursor:
#             row_count += 1
           
#             if row_count <= 5:
#                 print(row)

  
#         cursor.close()
#         conn.close()

#         end_time = time.time()

#         print("\n--- RESULT ---")
#         print("Total rows:", row_count)
#         print("Time taken:", round(end_time - start_time, 4), "seconds")

#     except mysql.connector.Error as err:
#         print("Database error:", err)

#     except Exception as e:
#         print("Unexpected error:", e)


# if __name__ == "__main__":
#     run_query()
