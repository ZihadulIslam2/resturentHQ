import 'package:flutter/material.dart';

import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/home/home_screen.dart';
import 'features/favorites/favorites_screen.dart';
import 'features/recipes/recipe_detail_screen.dart';
import 'features/recipes/upload_recipe_screen.dart';
import 'features/splash/splash_screen.dart';

class RecipeHubApp extends StatelessWidget {
  const RecipeHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RecipeHub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        FavoritesScreen.routeName: (_) => const FavoritesScreen(),
        UploadRecipeScreen.routeName: (_) => const UploadRecipeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == RecipeDetailScreen.routeName) {
          final recipeId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => RecipeDetailScreen(recipeId: recipeId),
          );
        }
        return null;
      },
    );
  }
}
