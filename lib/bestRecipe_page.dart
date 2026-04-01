import 'package:flutter/material.dart';
import 'spoonacular_service.dart';
import 'allRecipes_page.dart';

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

  void seeMore() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          recipes: s
          service: widget.service,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.bestRecipe;
    final have = widget.haveIngredients;
    final need = widget.needIngredients;
    

    return Scaffold(
      appBar: AppBar(title: const Text("Your Best Recipe")),
      body: Padding(padding: const EdgeInsets.all(25),
      child: ListView(
        children: [
          Text(
            recipe['title'],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            "Ingredients you have:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...have.map(
            (ingredient) => Text(
              "✅ $ingredient",
              style: const TextStyle(fontSize: 16),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Ingredients you need:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...need.map(
            (ingredient) => Text(
              "❌ $ingredient",
              style: const TextStyle(fontSize: 16),
            ),
          ),

          ElevatedButton(onPressed: seeMore, child: const Text("See More")),
        ],
      ),
    ),
    );
  }
}