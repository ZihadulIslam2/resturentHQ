# Recipe Creation API Integration - Setup & Testing Guide

## Changes Made

### 1. Enhanced API Client (`lib/core/api/api_client.dart`)

- Added detailed request/response logging using dart:developer
- Added timeout handling (30 seconds by default)
- Better error handling with JSON parsing validation
- Logs include HTTP method, URL, authentication status, and request body
- Detects and warns if token is missing for authenticated requests

### 2. Improved Upload Recipe Screen (`lib/features/recipes/upload_recipe_screen.dart`)

- Added comprehensive error logging
- Better error messages displayed to user
- Added optional fields: Prep Time, Cook Time, Servings
- Improved form UX with OutlineInputBorder and spacing
- Proper cleanup of controllers in dispose method
- More descriptive field hints
- Visual feedback with success/error message colors

### 3. Configuration System (`lib/core/config/app_config.dart`)

- Centralized configuration for API base URL
- Easy switching between environments (localhost, production)
- Request timeout settings
- API logging toggle

## Environment Setup

### For Local Development

The default config uses `http://localhost:5000/api`

**For Flutter Web:**

```bash
cd mobile_app
flutter run -d chrome
```

**For Android Emulator:**
Change in `lib/core/config/app_config.dart`:

```dart
static const String apiBaseUrl = 'http://10.0.2.2:5000/api';
```

**For iOS Simulator:**
Change in `lib/core/config/app_config.dart`:

```dart
static const String apiBaseUrl = 'http://localhost:5000/api';
```

## Testing Recipe Creation

### Prerequisites

1. Backend must be running:

   ```bash
   cd backend
   npm run dev
   ```

   Should see: `RecipeHub backend running on port 5000`

2. User must be logged in (app saves token to SharedPreferences)

### Testing Steps

1. **Start the backend:**

   ```bash
   cd backend
   npm run dev
   ```

2. **Start the mobile app:**

   ```bash
   cd mobile_app
   flutter run -d chrome  # or your chosen device
   ```

3. **Login/Register:**
   - Navigate to login screen
   - Enter credentials and login
   - Token is automatically saved

4. **Upload a Recipe:**
   - Navigate to Upload Recipe screen
   - Fill in the form:
     - **Title:** Test Recipe
     - **Description:** A test recipe
     - **Ingredients:** flour, sugar, eggs, butter (comma separated)
     - **Instructions:** Mix ingredients. Bake at 350F. Cool and serve. (period separated)
     - **Category:** Dessert
     - **Image URL:** https://via.placeholder.com/300 (optional)
     - **Prep Time:** 15 (optional, in minutes)
     - **Cook Time:** 30 (optional, in minutes)
     - **Servings:** 4 (optional)
   - Click "Upload Recipe"

## Debugging

### Check Logs

Open DevTools Console (Chrome) or Debug Console:

- Look for "ApiClient" logs to see all requests/responses
- Look for "ApiClient Error" to see any errors

### Common Issues & Solutions

**Issue: "No token found for authenticated request"**

- Solution: Login first to save the token

**Issue: "Request failed: Recipe not found"**

- Likely a 404 - check backend is running

**Issue: "This field is required" validation errors**

- Ensure: title, ingredients, instructions, category are filled

**Issue: "Request timeout"**

- Backend not running or not reachable
- Check if `http://localhost:5000/api/health` returns a response

**Issue: CORS errors**

- Backend CORS is configured to accept all origins by default
- Check backend logs for details

### Verification Checklist

- [ ] Backend running on port 5000
- [ ] User is logged in
- [ ] All required fields are filled
- [ ] API logs show successful response (status 201)
- [ ] Recipe appears in the recipes list
- [ ] No "Request timeout" errors

## API Endpoint Reference

**Create Recipe:**

- **Endpoint:** `POST /api/recipes`
- **Auth:** Required (Bearer token)
- **Required Fields:**
  - `title` (string)
  - `category` (string)
  - `ingredients` (array of strings)
  - `instructions` (array of strings)
- **Optional Fields:**
  - `description` (string)
  - `imageUrl` (string)
  - `prepTime` (number, minutes)
  - `cookTime` (number, minutes)
  - `servings` (number)

**Example Response (201 Created):**

```json
{
  "_id": "64a1b2c3d4e5f6g7h8i9j0k1",
  "title": "Test Recipe",
  "description": "A test recipe",
  "category": "Dessert",
  "ingredients": ["flour", "sugar", "eggs", "butter"],
  "instructions": ["Mix ingredients", "Bake at 350F", "Cool and serve"],
  "imageUrl": "https://via.placeholder.com/300",
  "prepTime": 15,
  "cookTime": 30,
  "servings": 4,
  "author": "user-id",
  "createdAt": "2024-01-15T10:30:00Z"
}
```

## Next Steps

1. Test recipe creation with the uploaded images
2. Add image upload functionality (currently expects URL)
3. Add category dropdown instead of text input
4. Add recipe preview before submission
5. Implement recipe editing functionality
