

import 'dart:convert';
import 'package:http/http.dart' as http;

class MealDBService {
  final String baseUrl =
      'https://www.themealdb.com/api/json/v1/1';


  Future<List<dynamic>> searchByIngredient(String ingredient) async {
    final response = await http.get(
      Uri.parse('$baseUrl/filter.php?i=$ingredient'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to load meals');
    }
  }


  Future<Map<String, dynamic>> getMealDetails(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/lookup.php?i=$id'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'][0];
    } else {
      throw Exception('Failed to load meal details');
    }
  }
}