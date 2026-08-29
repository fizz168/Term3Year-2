import { pool } from "./db/database.js";
  
async function testConnection() {
  try {
    // TODO  - Use the pool to query the database (SHOW TABLES query)
const [rows] = await pool.query("SHOW TABLES");
     // TODO - Print the list of tables in the console
    console.log("Employees in the database:");
    console.log(rows);

  } catch (err) {
    console.error("Failed to connect to the database:", err.message);
  } finally {
    process.exit();
  }
}

testConnection();
