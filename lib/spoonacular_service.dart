
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

  //  Auto-rank recipes
  recipes.sort((a, b) {
    // 1️ Fewest missing ingredients first
    int missingCompare = a['missedIngredientCount']
        .compareTo(b['missedIngredientCount']);
    if (missingCompare != 0) return missingCompare;

    // 2️ More used ingredients next
    int usedCompare = b['usedIngredientCount']
        .compareTo(a['usedIngredientCount']);
    if (usedCompare != 0) return usedCompare;

    // 3️ More likes last
    return b['likes'].compareTo(a['likes']);
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