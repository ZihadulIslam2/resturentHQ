const Favorite = require('../models/Favorite')

async function getFavorites(req, res) {
  const favorites = await Favorite.find({ user: req.user._id }).populate({
    path: 'recipe',
    populate: { path: 'author', select: 'name avatar' },
  })

  return res.json(favorites)
}

async function addFavorite(req, res) {
  const favorite = await Favorite.findOneAndUpdate(
    { user: req.user._id, recipe: req.params.recipeId },
    { user: req.user._id, recipe: req.params.recipeId },
    { upsert: true, new: true, setDefaultsOnInsert: true },
  )

  return res.status(201).json(favorite)
}

async function removeFavorite(req, res) {
  await Favorite.deleteOne({ user: req.user._id, recipe: req.params.recipeId })
  return res.json({ message: 'Favorite removed' })
}

module.exports = { getFavorites, addFavorite, removeFavorite }
