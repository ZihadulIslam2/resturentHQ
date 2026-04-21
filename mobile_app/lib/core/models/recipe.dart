class Recipe {
  Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
    required this.averageRating,
  });

  final String id;
  final String title;
  final String category;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  final String imageUrl;
  final double averageRating;

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['_id'] as String,
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      ingredients: (json['ingredients'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
      instructions: (json['instructions'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
      imageUrl: json['imageUrl'] as String? ?? '',
      averageRating: (json['averageRating'] as num? ?? 0).toDouble(),
    );
  }
}
