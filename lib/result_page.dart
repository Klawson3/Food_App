import 'package:flutter/material.dart';
import 'spoonacular_service.dart';

class ResultPage extends StatelessWidget {
  final List<dynamic> recipes;
  final SpoonacularService service;

  const ResultPage({
    super.key,
    required this.recipes,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recipe for you")),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return ListTile(
            title: Text(recipe['title']),
            subtitle: Text(
              "✅ Used: ${recipe['usedIngredientCount']} ingredient(s) ❌ Missing: ${recipe['missedIngredientCount']} ingredient(s)",
            ),
          );
        },
      ),
    );
  }
}