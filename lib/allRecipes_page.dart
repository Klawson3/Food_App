import 'package:flutter/material.dart';
import 'spoonacular_service.dart';

class ResultPage extends StatefulWidget {
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
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late List<Map<String, dynamic>> recipeDisplayData;

  @override
  void initState() {
    super.initState();

    final sortedRecipes = List<dynamic>.from(widget.recipes);

    for (final recipe in sortedRecipes) {
      final recipeAllNames = [
        ...(recipe['usedIngredients'] as List).map((i) => i['name'] as String),
        ...(recipe['missedIngredients'] as List).map((i) => i['name'] as String),
      ];

      final relevantHave = widget.haveIngredients
          .where((h) => recipeAllNames.any((name) => name.contains(h) || h.contains(name)))
          .toList();

      final relevantNeed = (recipe['missedIngredients'] as List)
          .map((i) => i['name'] as String)
          .where((n) => !widget.haveIngredients.any((h) => n.contains(h) || h.contains(n)))
          .toList();

      int used = relevantHave.length;
      int missing = relevantNeed.length;
      int total = used + missing;
      double matchScore = total == 0 ? 0 : used / total;
      double complexityPenalty = total / 30;
      recipe['finalScore'] = matchScore - complexityPenalty;
    }

    sortedRecipes.sort((a, b) {
      int scoreCompare = b['finalScore'].compareTo(a['finalScore']);
      if (scoreCompare != 0) return scoreCompare;
      return a['missedIngredientCount'].compareTo(b['missedIngredientCount']);
    });

    recipeDisplayData = sortedRecipes.map((recipe) {
      final recipeAllNames = [
        ...(recipe['usedIngredients'] as List).map((i) => i['name'] as String),
        ...(recipe['missedIngredients'] as List).map((i) => i['name'] as String),
      ];

      final relevantHave = widget.haveIngredients
          .where((h) => recipeAllNames.any((name) => name.contains(h) || h.contains(name)))
          .toList();

      final relevantNeed = (recipe['missedIngredients'] as List)
          .map((i) => i['name'] as String)
          .where((n) => !widget.haveIngredients.any((h) => n.contains(h) || h.contains(n)))
          .toList();
      
      return {
        'recipe': recipe,
        'have': relevantHave,
        'need': relevantNeed,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recipe for you")),
      body: ListView.builder(
        itemCount: recipeDisplayData.length,
        itemBuilder: (context, index) {
          final data = recipeDisplayData[index];
          final recipe = data['recipe'] as Map<String, dynamic>;
          final relevantHave = data['have'] as List<String>;
          final relevantNeed = data['need'] as List<String>;

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
                if (relevantNeed.isNotEmpty) ...[
                  Row(children:[
                    const Icon(Icons.close, color: Colors.red, size: 16),
                    const SizedBox(width: 4),
                    Expanded(child: Text("You still need: ${relevantNeed.join(", ")}")),
                  ]),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
