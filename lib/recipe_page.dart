import 'package:flutter/material.dart';
import 'spoonacular_service.dart';

class RecipePage extends StatefulWidget {
  final SpoonacularService service;
  final Map<String, dynamic> bestRecipe;
  final List<String> haveIngredients;
  final List<String> needIngredients;

  //constructor
  const RecipePage({
    super.key,
    required this.service,
    required this.bestRecipe,
    required this.haveIngredients,
    required this.needIngredients,
  });

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {

  @override
  Widget build(BuildContext context) {
    final recipe = widget.bestRecipe;
    final List missedIngredients = recipe['missedIngredients'];
    final List usedIngredients = recipe['usedIngredients'];
    

    return Scaffold(
      appBar: AppBar(title: const Text("Your Best Recipe")),
      body: Padding(padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.bestRecipe['title'],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            "Ingredients you have:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...usedIngredients.map(
            (ingredient) => Text(
              "✅ ${ingredient['name']}",
              style: const TextStyle(fontSize: 16),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Ingredients you need:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...missedIngredients.map(
            (ingredient) => Text(
              "❌ ${ingredient['name']}",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    ),
    );
  }
}