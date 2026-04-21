const express = require('express')
const {
  getRecipes,
  getRecipeById,
  createRecipe,
  updateRecipe,
  deleteRecipe,
  getCategories,
} = require('../controllers/recipeController')
const { protect, authorizeAdmin } = require('../middleware/authMiddleware')

const router = express.Router()

router.get('/categories', getCategories)
router.get('/', getRecipes)
router.get('/:id', getRecipeById)
router.post('/', protect, createRecipe)
router.put('/:id', protect, authorizeAdmin, updateRecipe)
router.delete('/:id', protect, authorizeAdmin, deleteRecipe)

module.exports = router
