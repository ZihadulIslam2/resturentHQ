const User = require('../models/User')
const Recipe = require('../models/Recipe')

async function getUsers(req, res) {
  const users = await User.find().select('-password')
  return res.json(users)
}

async function updateUserRole(req, res) {
  const user = await User.findById(req.params.id)

  if (!user) {
    return res.status(404).json({ message: 'User not found' })
  }

  user.role = req.body.role || user.role
  const updatedUser = await user.save()

  return res.json({
    _id: updatedUser._id,
    name: updatedUser.name,
    email: updatedUser.email,
    role: updatedUser.role,
  })
}

async function deleteUser(req, res) {
  const user = await User.findById(req.params.id)

  if (!user) {
    return res.status(404).json({ message: 'User not found' })
  }

  await user.deleteOne()
  return res.json({ message: 'User removed' })
}

async function getAllRecipes(req, res) {
  const recipes = await Recipe.find().populate('author', 'name avatar')
  return res.json(recipes)
}

module.exports = { getUsers, updateUserRole, deleteUser, getAllRecipes }
