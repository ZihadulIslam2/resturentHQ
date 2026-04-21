const express = require('express')
const {
  createOrUpdateReview,
  deleteReview,
  getReviewsByRecipe,
} = require('../controllers/reviewController')
const { protect } = require('../middleware/authMiddleware')

const router = express.Router()

router.get('/:recipeId', getReviewsByRecipe)
router.post('/:recipeId', protect, createOrUpdateReview)
router.delete('/:recipeId', protect, deleteReview)

module.exports = router
