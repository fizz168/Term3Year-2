// import fs from "fs";
// const filePath = "./hello.txt"

// // write file sync
// fs.writeFileSync(filePath,"hello");
// //read file sync 
// const content = fs.readFileSync(filePath, "utf8");
// console.log("file content:", content);

// 5 convert async read and write 
import fs from "fs/promises";
const filePath = "./hello.txt"
try {
    await fs.writeFile(filePath,"hello bro");
    const content = await fs.readFile(filePath, "utf8");
    console.log("file content:", content);
}catch (error) {
    console.log("error:", error);

}


