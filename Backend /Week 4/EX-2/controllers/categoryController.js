import { categories } from '../models/data.js';

export const getAllCategories = (req, res) => {
    res.status(200).json(categories);
};

export const getCategoryById = (req, res) => {
    const id = parseInt(req.params.id);

    const category = categories.find(c => c.id === id);

    if (!category) {
        return res.status(404).json({
            error: "Category not found"
        });
    }

    res.status(200).json(category);
};

export const createCategory = (req, res) => {
    const { name } = req.body;

    if (!name) {
        return res.status(400).json({
            error: "Name is required"
        });
    }

    const newCategory = {
        id: categories.length > 0
            ? categories[categories.length - 1].id + 1
            : 1,
        name
    };

    categories.push(newCategory);

    res.status(201).json(newCategory);
};

export const updateCategory = (req, res) => {
    const id = parseInt(req.params.id);

    const category = categories.find(c => c.id === id);

    if (!category) {
        return res.status(404).json({
            error: "Category not found"
        });
    }

    const { name } = req.body;

    if (name) category.name = name;

    res.status(200).json(category);
};

export const deleteCategory = (req, res) => {
    const id = parseInt(req.params.id);

    const index = categories.findIndex(c => c.id === id);

    if (index === -1) {
        return res.status(404).json({
            error: "Category not found"
        });
    }

    categories.splice(index, 1);

    res.status(204).send();
};