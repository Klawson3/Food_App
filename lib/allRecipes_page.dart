import 'package:flutter/material.dart';
import 'spoonacular_service.dart';

class ResultPage extends StatelessWidget {
  final Map<String, dynamic> bestRecipe;
  final SpoonacularService service;
  final List<dynamic> recipes;
  final List<String> haveIngredients;
  final List<String> needIngredients;

  const ResultPage({
    super.key,
    required this.service,
    required this.bestRecipe,
    required this.recipes,
    required this.haveIngredients,
    required this.needIngredients,
  });

  @override
  Widget build(BuildContext context) {
    recipes.sort((a, b) =>
        b['finalScore'].compareTo(a['finalScore']));
    return Scaffold(
      appBar: AppBar(title: const Text("Recipe for you")),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          final recipeUsedNames = (recipe['usedIngredients'] as List)
              .map((i) => i['name'] as String)
              .toList();
          final relevantHave = haveIngredients
              .where((h) => recipeUsedNames.contains(h))
              .toList();

          return ListTile(
            title: Text(recipe['title']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("⭐ Score: ${recipe['finalScore'].toStringAsFixed(2)}"),
                Text("✅ You have: ${relevantHave.join(", ")}"),
                Text("❌ You still need: ${recipe["missedIngredients"]
                    .map((i) => i['name'])
                    .join(", ")}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
