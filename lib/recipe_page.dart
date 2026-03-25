import 'package:flutter/material.dart';
import 'spoonacular_service.dart';

class RecipePage extends StatefulWidget {

  final SpoonacularService service;
  final Map<String, dynamic> bestRecipe;

  //constructor
  const RecipePage({
    super.key,
    required this.service,
    required this.bestRecipe,
  });

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {

  @override
  Widget build(BuildContext context) {
    final recipe = widget.bestRecipe;
    final allIngredients = [
      ...recipe['usedIngredients'].map((i) => i['name']),
      ...recipe['missedIngredients'].map((i) => i['name']),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Your Best Recipe")),
      body: Padding(padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Text(
            widget.bestRecipe['title'],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            "Ingredients: ${allIngredients.join(', ')}",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
    );
  }
}