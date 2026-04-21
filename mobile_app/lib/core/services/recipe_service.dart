import '../api/api_client.dart';
import '../models/recipe.dart';

class RecipeService {
  RecipeService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Recipe>> getRecipes({String? query, String? category}) async {
    final queryParameters = <String, String>{};
    if (query != null && query.isNotEmpty) {
      queryParameters['q'] = query;
    }
    if (category != null && category.isNotEmpty) {
      queryParameters['category'] = category;
    }

    final uri = Uri.parse(
      '${ApiClient.baseUrl}/recipes',
    ).replace(queryParameters: queryParameters);
    final response = await _apiClient.get(
      uri.path + (uri.hasQuery ? '?${uri.query}' : ''),
    );
    return (response as List<dynamic>)
        .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> getRecipeDetails(String recipeId) async {
    return await _apiClient.get('/recipes/$recipeId');
  }

  Future<void> createRecipe(Map<String, dynamic> data) async {
    await _apiClient.post('/recipes', body: data, authenticated: true);
  }

  Future<void> toggleFavorite(String recipeId) async {
    await _apiClient.post('/favorites/$recipeId', authenticated: true);
  }

  Future<void> submitReview(String recipeId, int rating, String comment) async {
    await _apiClient.post(
      '/reviews/$recipeId',
      authenticated: true,
      body: {'rating': rating, 'comment': comment},
    );
  }
}
