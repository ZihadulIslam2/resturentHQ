import 'package:flutter/material.dart';

import '../../core/api/api_client.dart';
import '../../core/services/recipe_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});

  static const routeName = '/recipe-detail';

  final String recipeId;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final _recipeService = RecipeService(ApiClient());
  Map<String, dynamic>? _details;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final details = await _recipeService.getRecipeDetails(widget.recipeId);
      setState(() => _details = details);
    } catch (_) {
      setState(() => _details = null);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = _details?['recipe'] as Map<String, dynamic>?;
    final reviews = (_details?['reviews'] as List<dynamic>?) ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Details')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : recipe == null
          ? const Center(child: Text('Recipe not found'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  recipe['title'] as String? ?? '',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(recipe['category'] as String? ?? ''),
                const SizedBox(height: 16),
                Text(recipe['description'] as String? ?? ''),
                const SizedBox(height: 24),
                const Text(
                  'Ingredients',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...((recipe['ingredients'] as List<dynamic>? ?? []).map(
                  (item) => Text('• $item'),
                )),
                const SizedBox(height: 24),
                const Text(
                  'Instructions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...((recipe['instructions'] as List<dynamic>? ?? [])
                    .asMap()
                    .entries
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('${entry.key + 1}. ${entry.value}'),
                      ),
                    )),
                const SizedBox(height: 24),
                const Text(
                  'Reviews',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                if (reviews.isEmpty)
                  const Text('No reviews yet')
                else
                  ...reviews.map(
                    (item) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(item['user']?['name'] as String? ?? 'User'),
                      subtitle: Text(item['comment'] as String? ?? ''),
                      trailing: Text('${item['rating']}/5'),
                    ),
                  ),
              ],
            ),
    );
  }
}
