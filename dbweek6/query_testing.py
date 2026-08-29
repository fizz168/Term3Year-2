
import mysql.connector
import time

# --- Configuration ---
db_config = {
    'host': '172.23.5.77',
    'user': 'omra',         # Replace with your MySQL username
    'password': 'omra1234', # Replace with your MySQL password
    'database': 'employees',
    'port' : 3306
}
# --- Helper Functions ---
def measure_query(cursor, query, test_name):
    """Executes a query and measures the time it takes to fetch all results."""
    print(f"Running: {test_name}...")
    
    # Start high-resolution timer
    start_time = time.time()
    
    cursor.execute(query)
    # We must fetch the rows to ensure the database actually processes the full result set
    results = cursor.fetchall() 
    
    end_time = time.time()
    duration = end_time - start_time
    
    print(f" -> Found {len(results)} rows.")
    print(f" -> Execution Time: {duration:.4f} seconds\n")
    return duration
# --- Helper Functions ---
def manage_index(cursor, action, index_name, table, columns=""):
    """Helper to create or drop indexes cleanly."""
    try:
        if action == "CREATE":
            print(f"Creating index '{index_name}' on {table}({columns})... This might take a moment.")
            cursor.execute(f"CREATE INDEX {index_name} ON {table}({columns})")
        elif action == "DROP":
            cursor.execute(f"DROP INDEX {index_name} ON {table}")
    except mysql.connector.Error as err:
        # Ignore errors if we try to drop an index that doesn't exist
        if action != "DROP": 
            print(f"Index Error: {err}")

# --- Main Test Suite ---
def run_tests():
    try:
        # Connect to Database
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        print("Connected to MySQL successfully!\n" + "="*40 + "\n")

        # ---------------------------------------------------------
        # TEST 1: Baseline (Full Table Scan vs Single Index)
        # ---------------------------------------------------------
        print("TEST 1: SINGLE COLUMN INDEX (last_name)")
        query_1 = "SELECT SQL_NO_CACHE * FROM employees WHERE last_name = 'Facello'"
        
        manage_index(cursor, "DROP", "idx_last_name", "employees") # Ensure clean slate
        
        measure_query(cursor, query_1, "Without Index (Full Table Scan)")
        
        manage_index(cursor, "CREATE", "idx_last_name", "employees", "last_name")
        measure_query(cursor, query_1, "With Index (Index Seek)")


        # ---------------------------------------------------------
        # TEST 2: JOIN Performance (Indexing the Driver Table)
        # ---------------------------------------------------------
        print("="*40)
        print("TEST 2: JOIN PERFORMANCE (hire_date filter)")
        query_2 = """
            SELECT SQL_NO_CACHE e.first_name, e.last_name, t.title 
            FROM employees e
            JOIN titles t ON e.emp_no = t.emp_no
            WHERE e.hire_date = '1989-09-12'
        """
        
        manage_index(cursor, "DROP", "idx_hire_date", "employees")
        
        measure_query(cursor, query_2, "JOIN Without hire_date Index (Scanning Driver Table)")
        
        manage_index(cursor, "CREATE", "idx_hire_date", "employees", "hire_date")
        measure_query(cursor, query_2, "JOIN With hire_date Index")


        # ---------------------------------------------------------
        # TEST 3: ORDER BY Performance (Avoiding Filesort)
        # ---------------------------------------------------------
        # print("="*40)
        # print("TEST 3: ORDER BY (Sorting Salaries)")
        # query_3 = "SELECT SQL_NO_CACHE * FROM salaries ORDER BY salary DESC"
        
        # manage_index(cursor, "DROP", "idx_salary", "salaries")
        
        # measure_query(cursor, query_3, "ORDER BY Without Index (Filesort)")
        
        # manage_index(cursor, "CREATE", "idx_salary", "salaries", "salary")
        # measure_query(cursor, query_3, "ORDER BY With Index (Pre-sorted)")
         
         #test4 
        print("="*40)
        print("TEST 4: EXACT MATCH (last_name)")

        query_4 = """
        SELECT SQL_NO_CACHE *
        FROM employees
        WHERE last_name = 'Facello'
    """

        manage_index(cursor, "DROP", "idx_last_name_test", "employees")
        measure_query(cursor, query_4, "Without index")
        manage_index(cursor, "CREATE", "idx_last_name_test", "employees", "last_name")
        measure_query(cursor, query_4, "With index")

        #test5
        print("="*40)
        print("TEST: HIRE DATE BEFORE 2000 (NO INDEX)")

        query_hd = """
    SELECT SQL_NO_CACHE *
    FROM employees
    WHERE hire_date < '2000-01-01'
"""

        manage_index(cursor, "DROP", "idx_hire_date_2000", "employees")
        measure_query(cursor, query_hd, "Without index")
        manage_index(cursor, "CREATE", "idx_hire_date_2000", "employees", "hire_date")
        measure_query(cursor, query_hd, "With index")
        
        #test6
        print("="*40)
        print("TEST 6: RANGE QUERY (salary range)")

        query_6 = """
        SELECT SQL_NO_CACHE *
        FROM salaries
        WHERE salary BETWEEN 60000 AND 70000
        """

        manage_index(cursor, "DROP", "idx_salary_range", "salaries")
        measure_query(cursor, query_6, "Without index")
        manage_index(cursor, "CREATE", "idx_salary_range", "salaries", "salary")
        measure_query(cursor, query_6, "With index")

        #test7
        print("="*40)
        print("TEST 7: Order by filtered results")
        query_7 = """ select SQL_NO_CACHE *
        from employees e
        where last_name like 'F%'
        order by first_name """
        manage_index(cursor, "DROP", "idx_last_name_order", "employees")
        measure_query(cursor, query_7, "Without index")
        manage_index(cursor, "CREATE", "idx_last_name_order", "employees", "last_name, first_name")
        measure_query(cursor, query_7, "With index")    

# test 8
        print("="*40)
        print("TEST 8: ORDER BY SMALL DATA")
        query_8 = """
        SELECT SQL_NO_CACHE *
        FROM employees
        ORDER BY first_name ASC
        LIMIT 20
"""
        manage_index(cursor, "DROP", "idx_first_name_sort", "employees")
        measure_query(cursor, query_8, "Without index")
        manage_index(cursor, "CREATE", "idx_first_name_sort", "employees", "first_name")
        measure_query(cursor, query_8, "With index")


        # --- Clean up indexes we made during the test ---
        print("="*40)
        print("Cleaning up created test indexes...")
        manage_index(cursor, "DROP", "idx_last_name", "employees")
        manage_index(cursor, "DROP", "idx_hire_date", "employees")
        manage_index(cursor, "DROP", "idx_salary", "salaries")
        print("Tests Complete!")

    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()

if __name__ == "__main__":
    run_tests()