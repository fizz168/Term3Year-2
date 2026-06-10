import { Routes, Route } from 'react-router-dom'; // remove unused Link import
import ArticleList from './components/ArticleList';
import CreateArticleForm from './components/CreateArticleForm';
import UpdateArticleForm from './components/UpdateArticleForm';
import ArticleViewer from './components/ArticleViewer';

function App() {
  return (
    <div style={{ padding: '20px' }}>
      <h1>📰 News Article Management</h1>
      <Routes>
        <Route path="/" element={<ArticleList />} />
        <Route path="/add" element={<CreateArticleForm />} />
        <Route path="/articles/update/:id" element={<UpdateArticleForm />} />  
        <Route path="/articles/:id" element={<ArticleViewer />} />
      </Routes>
    </div>
  );
}

export default App;