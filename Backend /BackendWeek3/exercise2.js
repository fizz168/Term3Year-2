import express from 'express';
const PORT = 3000;
const app = express();

const course = [
    {
        "id": "CSE101",
        "title": "Introduction to Computer Science",    
        "department": "CS",
        "level": "Undergraduate",
        "credits": 3,
        "instructor": "Dr. Smith",
        "semester": "Fall"
    }
];
app.get('/course', (req, res) => {
    res.json(course);
});

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});