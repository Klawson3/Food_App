import 'package:flutter/material.dart';
import 'spoonacular_service.dart';
import 'recipe_detail_page.dart';
import 'key_ingredient_page.dart';
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
/// Builds a Scaffold with an AppBar and a ListView of ListTile
/// Each ListTile represents a recipe, with the title being the name of the
/// recipe and the subtitle being a Column with the following children:
/// - A Row with an amber star icon and the final score of the recipe
/// - A Row with a green checkmark icon and the relevant ingredients the user has
/// - If the user still needs some ingredients, a Row with a red close icon and
///   the relevant ingredients the user still needs. When tapped, navigates to
///   the RecipeDetailPage with the recipe and its details.
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Recipe for you")),
    body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: recipeDisplayData.length,
            itemBuilder: (context, index) {
              final data = recipeDisplayData[index];
              final recipe = data['recipe'] as Map<String, dynamic>;
              final relevantHave = data['have'] as List<String>;
              final relevantNeed = data['need'] as List<String>;

              return GestureDetector(
                onTap: () async {
                  final details =
                      await widget.service.getRecipeDetails(recipe['id']);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailPage(
                        recipe: recipe,
                        details: details,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: Image.network(
                          recipe['image'],
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(recipe['finalScore']
                                    .toStringAsFixed(2)),
                             ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "You have: ${relevantHave.join(", ")}",
                              style: const TextStyle(fontSize: 13),
                            ),
                            if (relevantNeed.isNotEmpty)
                              Text(
                                "Missing: ${relevantNeed.join(", ")}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        IngredientPage(),
                  ),
                );
              },
              child: const Text("Restart"),
            ),
          ),
        ),
      ],
    ),
  );
} // close build

} //close _ResultPageState