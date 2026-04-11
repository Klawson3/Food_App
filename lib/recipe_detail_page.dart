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