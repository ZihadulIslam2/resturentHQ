const Review = require('../models/Review')
const Recipe = require('../models/Recipe')

async function createOrUpdateReview(req, res) {
  const { rating, comment } = req.body

  if (!rating) {
    return res.status(400).json({ message: 'Rating is required' })
  }

  const review = await Review.findOneAndUpdate(
    { user: req.user._id, recipe: req.params.recipeId },
    { user: req.user._id, recipe: req.params.recipeId, rating, comment },
    { upsert: true, new: true, setDefaultsOnInsert: true },
  )

  const reviews = await Review.find({ recipe: req.params.recipeId })
  const averageRating =
    reviews.reduce((sum, item) => sum + item.rating, 0) / reviews.length

  await Recipe.findByIdAndUpdate(req.params.recipeId, {
    averageRating,
    ratingCount: reviews.length,
  })

  return res.status(201).json(review)
}

async function deleteReview(req, res) {
  await Review.deleteOne({ user: req.user._id, recipe: req.params.recipeId })
  const reviews = await Review.find({ recipe: req.params.recipeId })
  const averageRating = reviews.length
    ? reviews.reduce((sum, item) => sum + item.rating, 0) / reviews.length
    : 0

  await Recipe.findByIdAndUpdate(req.params.recipeId, {
    averageRating,
    ratingCount: reviews.length,
  })

  return res.json({ message: 'Review removed' })
}

async function getReviewsByRecipe(req, res) {
  const reviews = await Review.find({ recipe: req.params.recipeId }).populate(
    'user',
    'name avatar',
  )
  return res.json(reviews)
}

module.exports = { createOrUpdateReview, deleteReview, getReviewsByRecipe }
