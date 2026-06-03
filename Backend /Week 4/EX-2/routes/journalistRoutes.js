import express from 'express';
import {
  getAllJournalists,
  getJournalistsById,
  createNewJournalist,
  updateJournalistByid,
  deleteJournalistById
} from "../controllers/journalistController.js";
const router = express.Router();
router.get('/', getAllJournalists);
router.get('/:id', getJournalistsById);
router.post('/', createNewJournalist);
router.put('/:id', updateJournalistByid);
router.delete('/:id', deleteJournalistById);


export default router;