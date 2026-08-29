import { DataTypes } from "sequelize";
import sequelize from "./db/database.js";

// Define the Student model
const Student = sequelize.define("Student", {
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  age: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  major: {
    type: DataTypes.STRING,
  },
});

async function run() {
  await sequelize.sync({ force: true });

  // 🟢 1. Add 3 students
  console.log("📌 Adding 3 students...");
  // 👉 TODO: Use Student.create() to add Alice, Bob, and Chenda
  // Example:   await Student.create({ name: 'Alice', age: 20, major: 'Computer Science' });
 
 
  // 🟡 2. Update Bob's major to "Statistics"
  console.log("📌 Updating Bob's major...");
  // 👉 TODO: Find Bob by name, then update his major
 


  // 🔴 3. Delete Chenda
  console.log("📌 Deleting Chenda...");
  // 👉 TODO: Find Chenda by name, then delete her

  

  // 🔍 4. List all students
  console.log("\n📋 Remaining students:");
  // 👉 TODO: Use findAll() and log all students (name - age - major)



  await sequelize.close(); // not strictly required, but it's good practice for short-lived scripts
}
run();
