import express from "express";

import articleRoutes from './routes/articleRoutes.js'
import journalistRoutes from './routes/journalistRoutes.js'
import categoryRoutes from './routes/categoryRoutes.js'
const app = express();

const PORT = 3000;

app.use(express.json());t

app.use('/articles', articleRoutes);
app.use('/journalists', journalistRoutes);
app.use('/category', categoryRoutes);
// app.get('/', (req, res) => {
//     res.json(articles)
// });

app.listen(PORT, () => {
  console.log(`🚀 Server is running on http://localhost:${PORT}`);
});
