
import express from 'express';

const app = express();
const PORT = 5000;

// Middleware
app.use(express.json());

// Allow requests from React frontend (CORS)
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', 'http://localhost:5173');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
});



// GET all articles
app.get('/articles', (req, res) => {
  res.json(articles);
});

// GET article by ID
app.get('/articles/:id', (req, res) => {
  const article = articles.find(a => a.id === parseInt(req.params.id));
  if (!article) 
    return res.status(404).json({ message: 'Article not found' });
  res.json(article);
});

// POST create article
app.post('/articles', (req, res) => {
  const { title, content, journalistId, categoryId } = req.body;
  const newArticle = { id: nextId++, title, content, journalistId, categoryId };
  articles.push(newArticle);
  res.status(201).json(newArticle);
});

// PUT update article
app.put('/articles/:id', (req, res) => {
  const index = articles.findIndex(a => a.id === parseInt(req.params.id));
  if (index === -1) 
    return res.status(404).json({ message: 'Article not found' });
  articles[index] = { ...articles[index], ...req.body };
  res.json(articles[index]);
});

// DELETE article
app.delete('/articles/:id', (req, res) => {
  const index = articles.findIndex(a => a.id === parseInt(req.params.id));
  if (index === -1) 
    return res.status(404).json({ message: 'Article not found' });
  articles.splice(index, 1);
  res.json({ message: 'Deleted successfully' });
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
