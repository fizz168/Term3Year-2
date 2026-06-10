import { useEffect, useState } from 'react';
import axios from 'axios';
export default function ArticleFilterByJournalist() {
  const [articles, setArticles] = useState([]);
  const [journalists, setJournalists] = useState([]);
  const [selectedJournalist, setSelectedJournalist] = useState("");
  // Fetch all articles when component mounts
  useEffect(() => {
    fetchArticles();
    fetchJournalists();
  }, []);

  const fetchArticles = async () => {
    // Fetch articles from the API
      const response = await axios.get("http://localhost:5000/articles");
    setArticles(response.data);
  };

  const fetchJournalists = async () => {
    // Fetch journalists from the API
    const response = await axios.get("http://localhost:5000/journalists");
    setJournalists(response.data);
  };
  const applyFilters = async () => {
    if(selectedJournalist) {
      const response = await axios.get(`http://localhost:5000/articles?journalistId=${selectedJournalist}`);    
      setArticles(response.data);
    } else {
      fetchArticles();
    } 
  };
  const resetFilters = () => {
    setSelectedJournalist("");
    fetchArticles();
  }

  return (
    <div>
      <h2>Articles</h2>
      <div style={{ marginBottom: '20px', display: 'flex', gap: '10px' }}>
        <label htmlFor="journalistFilter">Filter by Journalist:</label>
        <select value = {selectedJournalist} onChange={(e) => setSelectedJournalist(e.target.value)} id="journalistFilter">
          <option value="">All Journalists</option>
          {journalists.map((journalist) => (
            <option key={journalist.id} value={journalist.id}>
              {journalist.name}
            </option>
          ))}
        </select>

        <button
          onClick={() => {
           
            applyFilters();
          }}
        >Apply Filters</button>
        <button
          onClick={() => {
          resetFilters();
          }}
        >Reset Filters</button>
      </div>

      <ul>
        {articles.map(article => (
          <li key={article.id}>
            <strong>{article.title}</strong> <br />
            <small>By Journalist #{article.journalistId} | Category #{article.categoryId}</small><br />
            <button disabled>Delete</button>
            <button disabled>Update</button>
            <button disabled>View</button>
          </li>
        ))}
      </ul>
    </div>
  );
}