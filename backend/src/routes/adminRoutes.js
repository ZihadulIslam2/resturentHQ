const express = require('express')
const {
  getUsers,
  updateUserRole,
  deleteUser,
  getAllRecipes,
} = require('../controllers/adminController')
const { protect, authorizeAdmin } = require('../middleware/authMiddleware')

const router = express.Router()

router.use(protect, authorizeAdmin)

router.get('/users', getUsers)
router.put('/users/:id', updateUserRole)
router.delete('/users/:id', deleteUser)
router.get('/recipes', getAllRecipes)

module.exports = router
