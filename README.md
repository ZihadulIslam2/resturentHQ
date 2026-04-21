# RecipeHub

RecipeHub is a Flutter recipe mobile app with an Express + MongoDB backend.

## Project Structure

- `backend/` - Express API + MongoDB
- `mobile_app/` - Flutter mobile application

## Features

- User registration and login
- Browse recipes by category
- Search recipes by name or ingredients
- View recipe details
- Save favorite recipes
- Upload recipes
- Rate and review recipes
- Admin management for users and recipes

## Backend Setup

```bash
cd backend
cp .env.example .env
npm install
npm run dev
```

## Flutter Setup

```bash
cd mobile_app
flutter pub get
flutter run
```

## Notes

- Set `MONGO_URI` in `backend/.env`.
- Set `API_BASE_URL` in `mobile_app/lib/core/api/api_client.dart`.
- The project is scaffolded so you can extend screens, forms, and API integration easily.
# resturentHQ
