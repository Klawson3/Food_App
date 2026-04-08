
import 'dart:convert';
import 'package:http/http.dart' as http;

class SpoonacularService {
  final String apiKey = '6c86fd3ac4d6461c99b4fadd891e5b67';
  final String baseUrl = 'https://api.spoonacular.com';

  /// Searches for recipes by given ingredients.
  ///
  /// The function takes a list of ingredients, sends a GET request to the
  /// Spoonacular API, and returns a list of recipe objects.
  ///
  /// The list of recipe objects is sorted in the following order:
  ///
  /// 1. Higher match score first (used ingredients / total ingredients)
  /// 2. 2nd Highest match score next
  /// 3. Fewer total ingredients tie/breaker
  Future<List<dynamic>> searchByIngredients(List<String> ingredients) async {
    final ingredientString = ingredients.join(',');

    final response = await http.get(
      Uri.parse(
        '$baseUrl/recipes/findByIngredients'
        '?ingredients=$ingredientString'
        '&number=20'
        '&apiKey=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
  List recipes = jsonDecode(response.body);

  for (var recipe in recipes) {
    int used = recipe['usedIngredientCount'];
    int missing = recipe['missedIngredientCount'];
    int total = used + missing;

    double matchScore =
        total == 0 ? 0 : used / total;

    //  Penalize large recipes
    double complexityPenalty = total / 30; // tweakable

  recipe['finalScore'] = matchScore - complexityPenalty;
}
// 2️ Sort once
recipes.sort((a, b) {
 int scoreCompare =
      b['finalScore'].compareTo(a['finalScore']);
  if (scoreCompare != 0) return scoreCompare;

  // Tie-breaker,  fewer missing ingredients
  return a['missedIngredientCount']
      .compareTo(b['missedIngredientCount']);
});

  return recipes;
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  /// Gets the details of a given recipe.
  ///
  /// The function takes a recipe ID, sends a GET request to the
  /// Spoonacular API, and returns a map of recipe details.
  ///
  /// If the request is successful, it returns a map of recipe details.
  /// If the request is unsuccessful, it throws an exception.
  Future<Map<String, dynamic>> getRecipeDetails(int id) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/recipes/$id/information?apiKey=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load recipe details');
    }
  }
}
