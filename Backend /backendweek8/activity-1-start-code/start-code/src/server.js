import sequelize from "./db/database.js"; 
import "./models/user.js"; // 👈 this line is critical

try {
  // TODO - Call sequelize.sync()
  await sequelize.sync();
 
  // TODO -  Print the result of the sync on console
  console.log("Database synchronized successfully.");
} catch (error) {
  console.error("Unable to connect to the database:", error);
}
