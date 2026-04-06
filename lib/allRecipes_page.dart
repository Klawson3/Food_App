import 'package:flutter/material.dart';
import 'spoonacular_service.dart';

class ResultPage extends StatelessWidget {
  final List<dynamic> recipes;
  final SpoonacularService service;
  final List<String> haveIngredients;
  final List<String> needIngredients;
  final List<String> initialIngredients;

  const ResultPage({
    super.key,
    required this.recipes,
    required this.service,
    required this.haveIngredients,
    required this.needIngredients,
    required this.initialIngredients,
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
          return ListTile(
            title: Text(recipe['title']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("⭐ Score: ${recipe['finalScore'].toStringAsFixed(2)}"),

                Text(
                  "✅ You have: ${haveIngredients.join(", ")}",
                ),

                Text(
                  "❌ You still need: ${recipe["missedIngredients"]
                  .map((i) => i['name'])
                  .join(", ")}",

                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
