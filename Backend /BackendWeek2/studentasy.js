import * as fs from 'node:fs/promises';

const filePath = "./hel.txt";

async function run() {
  try {
    // Write to file
    await fs.writeFile(filePath, "Hello, Node.js ");

    // Read from file
    const content = await fs.readFile(filePath, "utf8");

    console.log("File content:", content);
  } catch (err) {
    console.error("Error:", err);
  }
}

run();