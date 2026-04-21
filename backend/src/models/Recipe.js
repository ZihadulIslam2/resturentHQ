const mongoose = require('mongoose')

const recipeSchema = new mongoose.Schema(
  {
    title: { type: String, required: true, trim: true },
    description: { type: String, default: '' },
    ingredients: [{ type: String, required: true }],
    instructions: [{ type: String, required: true }],
    category: { type: String, required: true, trim: true },
    imageUrl: { type: String, default: '' },
    prepTime: { type: Number, default: 0 },
    cookTime: { type: Number, default: 0 },
    servings: { type: Number, default: 1 },
    author: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    averageRating: { type: Number, default: 0 },
    ratingCount: { type: Number, default: 0 },
  },
  { timestamps: true },
)

module.exports = mongoose.model('Recipe', recipeSchema)
