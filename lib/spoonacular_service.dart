
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
  /// 1. Fewest missing ingredients first
  /// 2. More used ingredients next
  /// 3. More likes last
  Future<List<dynamic>> searchByIngredients(List<String> ingredients) async {
    final ingredientString = ingredients.join(',');

    final response = await http.get(
      Uri.parse(
        '$baseUrl/recipes/findByIngredients'
        '?ingredients=$ingredientString'
        '&number=5'
        '&apiKey=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
  List recipes = jsonDecode(response.body);

  recipes.sort((a, b) {
    int usedA = a['usedIngredientCount'];
    int missingA = a['missedIngredientCount'];

    int usedB = b['usedIngredientCount'];
    int missingB = b['missedIngredientCount'];

    // 1️ Match percentage
    double scoreA = usedA / (usedA + missingA);
    double scoreB = usedB / (usedB + missingB);

    int scoreCompare = scoreB.compareTo(scoreA);
    if (scoreCompare != 0) return scoreCompare;

    // 2 Fewer missing ingredients
    int missingCompare = missingA.compareTo(missingB);
    if (missingCompare != 0) return missingCompare;

    // 3️ More likes
    return b['likes'].compareTo(a['likes']);
  });
  for (var recipe in recipes) {
    int used = recipe['usedIngredientCount'];
    int missing = recipe['missedIngredientCount'];
    int total = used + missing;

    double matchScore =
        total == 0 ? 0 : used / total;

    //  Penalize large recipes
    double complexityPenalty = total / 20; // tweakable

  recipe['finalScore'] = matchScore - complexityPenalty;
}
// 2️ Sort ONCE
recipes.sort((a, b) {
  return b['finalScore'].compareTo(a['finalScore']);
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
