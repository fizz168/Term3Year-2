import { DataTypes } from "sequelize";
import sequelize from "./db/database.js";
 

// Step 1: Define models
const Author = sequelize.define('Author', {
  name: DataTypes.STRING,
});

const Book = sequelize.define('Book', {
  title: DataTypes.STRING,
});

// Step 2: Define associations
// 👉 TODO: COMPLETE THIS PART  
 

async function run() {
  await sequelize.sync({ force: true });

  const author = await Author.create({ name: 'Chim Samnang' });

  // Create a book from the author instance
// 👉 TODO: COMPLETE THIS PART  

  // Get all books written by this author
// 👉 TODO: COMPLETE THIS PART  

  // Create another book separately
// 👉 TODO: COMPLETE THIS PART  

  // Link the second book to the same author
// 👉 TODO: COMPLETE THIS PART  

  // Display all books again
// 👉 TODO: COMPLETE THIS PART  

  // Fetch all authors and for each author dispaly  their books
  const authorsWithBooks = await Author.findAll({
   include: Book
  });

  // 👉 TODO: COMPLETE THIS PART  
 

  await sequelize.close(); // not strictly required, but it's good practice for short-lived scripts
}
run();
