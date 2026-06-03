import express from 'express';
import{
    getAllArticle,
    getArticleById,
    createArticle,
    updateArticleById,
    deleteArticleById   
}from '../controllers/articleController.js';
const router = express.Router();
router.get('/', getAllArticle);
router.get('/:id', getArticleById);
router.post('/', createArticle);
router.put('/:id', updateArticleById);
router.delete('/:id', deleteArticleById);

export default router;