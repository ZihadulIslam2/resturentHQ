import 'package:flutter/material.dart';

import '../../core/api/api_client.dart';
import '../../core/models/recipe.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/recipe_service.dart';
import '../auth/login_screen.dart';
import '../favorites/favorites_screen.dart';
import '../recipes/recipe_detail_screen.dart';
import '../recipes/upload_recipe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _recipeService = RecipeService(ApiClient());
  final _authService = AuthService(ApiClient());
  List<Recipe> _recipes = [];
  bool _isLoading = true;
  String? _selectedCategory;

  final List<String> _categories = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
    'Snack',
  ];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    setState(() => _isLoading = true);
    try {
      final recipes = await _recipeService.getRecipes(
        query: _searchController.text.trim(),
        category: _selectedCategory == 'All' ? null : _selectedCategory,
      );
      setState(() => _recipes = recipes);
    } catch (_) {
      setState(() => _recipes = []);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (!mounted) {
      return;
    }
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecipeHub'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, FavoritesScreen.routeName),
            icon: const Icon(Icons.favorite),
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, UploadRecipeScreen.routeName),
            icon: const Icon(Icons.add_circle_outline),
          ),
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadRecipes,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _searchController,
              onSubmitted: (_) => _loadRecipes(),
              decoration: InputDecoration(
                hintText: 'Search recipes or ingredients',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_alt),
                  onPressed: _loadRecipes,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final selected = category == (_selectedCategory ?? 'All');
                  return ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category == 'All' ? null : category;
                      });
                      _loadRecipes();
                    },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: _categories.length,
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _recipes.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: Text('No recipes found yet')),
                  )
                : Column(
                    children: _recipes
                        .map(
                          (recipe) => Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  recipe.title.isEmpty ? 'R' : recipe.title[0],
                                ),
                              ),
                              title: Text(recipe.title),
                              subtitle: Text(
                                '${recipe.category} • Rating ${recipe.averageRating.toStringAsFixed(1)}',
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onTap: () => Navigator.pushNamed(
                                context,
                                RecipeDetailScreen.routeName,
                                arguments: recipe.id,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
