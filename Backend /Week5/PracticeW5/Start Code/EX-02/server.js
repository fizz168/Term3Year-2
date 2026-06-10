
import express from 'express';

const app = express();
const PORT = 5000;

// Middleware
app.use(express.json());

// CORS - allow React frontend
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', 'http://localhost:5173');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
});

// ============================================
// SAMPLE DATA
// ============================================

const journalists = [
  { id: 1, name: 'Sokha Chea' },
  { id: 2, name: 'Dara Pich' },
  { id: 3, name: 'Maly Keo' },
];

const categories = [
  { id: 1, name: 'Politics' },
  { id: 2, name: 'Sports' },
  { id: 3, name: 'Technology' },
];

let articles = [
  { id: 1, title: 'Election Results 2025', content: 'The election results are in...', journalistId: 1, categoryId: 1 },
  { id: 2, title: 'Cambodia Wins SEA Games', content: 'Cambodia won 5 gold medals...', journalistId: 2, categoryId: 2 },
  { id: 3, title: 'New AI Tools Released', content: 'Several AI tools launched this week...', journalistId: 3, categoryId: 3 },
  { id: 4, title: 'Government New Policy', content: 'New policy announced today...', journalistId: 1, categoryId: 1 },
  { id: 5, title: 'Football League Update', content: 'Local football league results...', journalistId: 2, categoryId: 2 },
  { id: 6, title: 'Tech Startup in Phnom Penh', content: 'A new startup is making waves...', journalistId: 3, categoryId: 3 },
];

let nextId = 7;

// ============================================
// JOURNALIST ROUTES
// ============================================

// GET all journalists
app.get('/journalists', (req, res) => {
  res.json(journalists);
});

// GET articles by journalist ID (Q2)
app.get('/journalists/:id/articles', (req, res) => {
  const journalistId = parseInt(req.params.id);
  const filtered = articles.filter(a => a.journalistId === journalistId);
  res.json(filtered);
});

// ============================================
// CATEGORY ROUTES
// ============================================

// GET all categories
app.get('/categories', (req, res) => {
  res.json(categories);
});

// GET articles by category ID (Q3)
app.get('/categories/:id/articles', (req, res) => {
  const categoryId = parseInt(req.params.id);
  const filtered = articles.filter(a => a.categoryId === categoryId);
  res.json(filtered);
});

// ============================================
// ARTICLE ROUTES
// ============================================

// GET all articles + combined filter (Q4 bonus)
// GET /articles
// GET /articles?journalistId=1&categoryId=2
app.get('/articles', (req, res) => {
  const { journalistId, categoryId } = req.query;

  let result = articles;

  if (journalistId) {
    result = result.filter(a => a.journalistId === parseInt(journalistId));
  }

  if (categoryId) {
    result = result.filter(a => a.categoryId === parseInt(categoryId));
  }

  res.json(result);
});

// GET article by ID
app.get('/articles/:id', (req, res) => {
  const article = articles.find(a => a.id === parseInt(req.params.id));
  if (!article) return res.status(404).json({ message: 'Article not found' });
  res.json(article);
});

// POST create article
app.post('/articles', (req, res) => {
  const { title, content, journalistId, categoryId } = req.body;
  const newArticle = {
    id: nextId++,
    title,
    content,
    journalistId: parseInt(journalistId),
    categoryId: parseInt(categoryId),
  };
  articles.push(newArticle);
  res.status(201).json(newArticle);
});

// PUT update article
app.put('/articles/:id', (req, res) => {
  const index = articles.findIndex(a => a.id === parseInt(req.params.id));
  if (index === -1) return res.status(404).json({ message: 'Article not found' });
  articles[index] = { ...articles[index], ...req.body };
  res.json(articles[index]);
});

// DELETE article
app.delete('/articles/:id', (req, res) => {
  const index = articles.findIndex(a => a.id === parseInt(req.params.id));
  if (index === -1) return res.status(404).json({ message: 'Article not found' });
  articles.splice(index, 1);
  res.json({ message: 'Deleted successfully' });
});

// ============================================
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
