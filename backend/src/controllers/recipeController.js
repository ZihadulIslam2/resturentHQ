const Recipe = require('../models/Recipe')
const Review = require('../models/Review')

async function getRecipes(req, res) {
  const { q, category } = req.query
  const filter = {}

  if (category) {
    filter.category = category
  }

  if (q) {
    filter.$or = [
      { title: { $regex: q, $options: 'i' } },
      { ingredients: { $elemMatch: { $regex: q, $options: 'i' } } },
    ]
  }

  const recipes = await Recipe.find(filter)
    .populate('author', 'name avatar')
    .sort({ createdAt: -1 })

  return res.json(recipes)
}

async function getRecipeById(req, res) {
  const recipe = await Recipe.findById(req.params.id).populate(
    'author',
    'name avatar',
  )

  if (!recipe) {
    return res.status(404).json({ message: 'Recipe not found' })
  }

  const reviews = await Review.find({ recipe: recipe._id }).populate(
    'user',
    'name avatar',
  )

  return res.json({ recipe, reviews })
}

async function createRecipe(req, res) {
  const {
    title,
    description,
    ingredients,
    instructions,
    category,
    imageUrl,
    prepTime,
    cookTime,
    servings,
  } = req.body

  if (!title || !ingredients?.length || !instructions?.length || !category) {
    return res
      .status(400)
      .json({
        message: 'Title, ingredients, instructions, and category are required',
      })
  }

  const recipe = await Recipe.create({
    title,
    description,
    ingredients,
    instructions,
    category,
    imageUrl,
    prepTime,
    cookTime,
    servings,
    author: req.user._id,
  })

  return res.status(201).json(recipe)
}

async function updateRecipe(req, res) {
  const recipe = await Recipe.findById(req.params.id)

  if (!recipe) {
    return res.status(404).json({ message: 'Recipe not found' })
  }

  Object.assign(recipe, req.body)
  const updatedRecipe = await recipe.save()

  return res.json(updatedRecipe)
}

async function deleteRecipe(req, res) {
  const recipe = await Recipe.findById(req.params.id)

  if (!recipe) {
    return res.status(404).json({ message: 'Recipe not found' })
  }

  await recipe.deleteOne()
  await Review.deleteMany({ recipe: req.params.id })

  return res.json({ message: 'Recipe removed' })
}

async function getCategories(req, res) {
  const categories = await Recipe.distinct('category')
  return res.json(categories.sort())
}

module.exports = {
  getRecipes,
  getRecipeById,
  createRecipe,
  updateRecipe,
  deleteRecipe,
  getCategories,
}
