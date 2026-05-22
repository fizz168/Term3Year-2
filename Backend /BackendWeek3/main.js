import express from 'express';
const PORT = 3000;
const app = express();

app.get('/', (req , res) => {
    res.send("omra sex");
});
app.post('/', (req, res) => {
  res.send('POST request to the homepage');
});
app.get('/about', (req, res) => {
  res.send('About page');
});
app.all('*', (req, res) => {
  res.status(404).send('404 - Page not found');
}); 



app.listen(3000, () => {
    console.log("server running on http://localhost:3000")
})