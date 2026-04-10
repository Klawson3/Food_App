import 'package:flutter/material.dart';
import 'spoonacular_service.dart';

class ResultPage extends StatelessWidget {
  final Map<String, dynamic> bestRecipe;
  final SpoonacularService service;
  final List<dynamic> recipes;
  final List<String> haveIngredients;
  final List<String> needIngredients;
  final Map<int, List<String>> recipeNeedMap;

  const ResultPage({
    super.key,
    required this.service,
    required this.bestRecipe,
    required this.recipes,
    required this.haveIngredients,
    required this.needIngredients,
    required this.recipeNeedMap,
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

          final recipeAllNames = [
            ...(recipe['usedIngredients'] as List).map((i) => i['name'] as String),
            ...(recipe['missedIngredients'] as List).map((i) => i['name'] as String),
          ];

          final relevantHave = haveIngredients
              .where((h) => recipeAllNames.any((name) => 
                  name.contains(h) || h.contains(name ?? '')))
              .toList();
          final relevantNeed = recipe['missedIngredients']
              .map((i) => i['name'])
              .where((n) => !haveIngredients.any((h) => n.contains(h) || h.contains(n)))
              .toList();
          
          for (int i = 0; i < recipes.length; i++) {
            int used = relevantHave.length;
            int missing = relevantNeed.length;
            int total = used + missing;
            double matchScore =
                total == 0 ? 0 : used / total;
            //  Penalize large recipes
            double complexityPenalty = total / 30; // tweakable
            recipe['finalScore'] = matchScore - complexityPenalty;
          }

          recipes.sort((a, b) {
            int scoreCompare = b['finalScore'].compareTo(a['finalScore']);
            if (scoreCompare != 0) return scoreCompare;
            return a['missedIngredientCount'].compareTo(b['missedIngredientCount']);
          });

          return ListTile(
            title: Text(recipe['title']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children:[
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Expanded(child: Text(recipe['finalScore'].toStringAsFixed(2))),
                ]),
                Row(children:[
                  const Icon(Icons.check, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  Expanded(child: Text("You have: ${relevantHave.join(", ")}")),
                ]),
                Row(children:[
                  const Icon(Icons.close, color: Colors.red, size: 16),
                  const SizedBox(width: 4),
                  Expanded(child: Text("You still need: ${relevantNeed.join(", ")}")),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }
}
