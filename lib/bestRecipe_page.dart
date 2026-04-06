import 'package:flutter/material.dart';
import 'spoonacular_service.dart';
import 'allRecipes_page.dart';

class RecipePage extends StatefulWidget {
  final SpoonacularService service;
  final List<dynamic> recipes;
  final Map<String, dynamic> bestRecipe;
  final List<String> haveIngredients;
  final List<String> needIngredients;
  final List<String> initialIngredients;
  //constructor
  const RecipePage({
    super.key,
    required this.service,
    required this.recipes,
    required this.bestRecipe,
    required this.haveIngredients,
    required this.needIngredients,
    required this.initialIngredients,
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
          recipes: widget.recipes,
          service: widget.service,
          haveIngredients: widget.haveIngredients,
          needIngredients: widget.needIngredients,
          initialIngredients: widget.initialIngredients,
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
            (ingredient) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check, size: 20, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ingredient,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Ingredients you need:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...need.map(
            (ingredient) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.cancel, size: 20, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ingredient,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),

          ElevatedButton(onPressed: seeMore, child: const Text("See More")),
        ],
      ),
    ),
    );
  }
}