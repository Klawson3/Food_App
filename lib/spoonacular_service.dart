
import 'dart:convert';
import 'package:http/http.dart' as http;

class SpoonacularService {
  final String apiKey = '6c86fd3ac4d6461c99b4fadd891e5b67';
  final String baseUrl = 'https://api.spoonacular.com';

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