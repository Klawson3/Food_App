import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final Map<String, dynamic> details;

  const RecipeDetailPage({
    super.key,
    required this.recipe,
    required this.details,
  });

  @override
/// Builds a recipe detail page with ingredients and instructions.
///
/// The page shows the title of the recipe in the app bar, and a list of
/// ingredients and instructions in the body. If there are no instructions
/// available, it will show a message saying "No instructions available".
  Widget build(BuildContext context) {
    final ingredients = details['extendedIngredients'] ?? [];
    final instructions = details['instructions']?.toString().replaceAll(RegExp(r'<[^>]*>'), '') 
        ?? "No instructions available";

    return Scaffold(
      appBar: AppBar(title: Text(recipe['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Image.network(recipe['image']),
            const SizedBox(height: 20),
            
            if (recipe['image'] != null)
              Image.network(recipe['image']),
            Text(
              "⏱️ ${details['readyInMinutes'] ?? 'N/A'} minutes",
              style: const TextStyle(fontSize: 16),
            ),

            Text(
              "🍽️ Serving Size: ${details['servings'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 15),
            const Text("Ingredients:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            ...ingredients.map((ing) => Text("- ${ing['original']}")),

            const SizedBox(height: 20),

            const Text("Instructions:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            Text(instructions),
          ],
        ),
      ),
    );
  }
}