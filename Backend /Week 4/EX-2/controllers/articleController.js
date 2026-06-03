import { articles } from "../models/data.js";

export const getAllArticle = (req, res) => {
  res.status(200).json(articles);
}
export const getArticleById = (req, res) => {
  const id = parseInt(req.params.id);
  const article = articles.find(a => a.id === id);
  if(!article){
    return res.status(404).json({
      error: "cant find the article"
    });
  }
  res.status(200).json(article);
}

export const createArticle = (req, res) => {
  const {title, content, journalistId, categoryId} = req.body;
  if(!title || !content || !journalistId || !categoryId){
    return res.status(400).json({
      error:"title, content, journalistId and categoryId are required"
    });
  }
  const newArticle = {
    id : articles.length > 0 ? articles[articles.length - 1].id + 1 : 1, title,content,journalistId,categoryId
  };
  articles.push(newArticle);
  return res.status(201).json(newArticle);
}

export const updateArticleById = (req, res) => {
  const id = parseInt(req.params.id);
  const article = articles.find(a => a.id === id);
  if(!article){
    return res.status(404).json({
      error:"cant find it"
    });
  }
const{title, content, journalistId, categoryId} = req.body;
if(title){
 article.title = title;
}
if(content){
  article.content = content;
}
if(journalistId){
  article.journalistId = journalistId;
}
if(categoryId){
  article.categoryId = categoryId;
}
return res.status(200).json(article);
}

export const deleteArticleById = (req, res) => {
  const id = parseInt(req.params.id);
  const index = articles.findIndex(a => a.id === id);

  if (index === -1) {
    return res.status(404).json({
      error: "cant find it"
    });
  }

  articles.splice(index, 1);
  return res.status(204).send();
}