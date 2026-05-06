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
  final Map<int, List<String>> recipeNeedMap;   // Map to store missing ingredients per recipe ID
 

 /// ResultPage displays a list of recipe recommendations reanked
 /// by how well they match the user's available ingredient.
 /// 
 /// Each recipe is evaluated using a custom scoring algorithm that
 /// considers ingredient availability and overal recipe complexity.
 /// The page allows users to compare multiple recipes together and select
 /// the one they want to view in detail.

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

/// A StatefuleWidget is used to store and process
/// recipe data for rendering and interaction.
/// Manages the processed recipe data, including scoring, sorting, 
/// and display.

class _ResultPageState extends State<ResultPage> {
  late List<Map<String, dynamic>> recipeDisplayData;
  @override


/// Initializes the page by processing and ranking recipes.
/// 
/// 1. Copies the original recipe list
/// 2. Computes a match score for each recipe
/// 3. Applies a complexity penalty based on ingredient count
/// 4. Sorts recipes by score (highest match)
/// 5. Prepares structured data for UI display
 

  void initState() {
    super.initState();

    // Creates copy of list
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
      double matchScore = total == 0 ? 0 : (used / total) * 100;
      double simplicityBonus = (1 / (total + 1)) * 10; // Tweakable bonus for simpler recipes
      recipe['finalScore'] = (matchScore + simplicityBonus).clamp(0,100); // Final score out of 100
    }

    // Sort recipe by descending score 
    sortedRecipes.sort((a, b) {
      int scoreCompare = b['finalScore'].compareTo(a['finalScore']);
      if (scoreCompare != 0) return scoreCompare;
      return a['missedIngredientCount'].compareTo(b['missedIngredientCount']);
    });

    // Buiild display-friendly data structure with relevant have/need lists for each recipe
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
        'recipe': recipe,  // Full recipe object
        'have': relevantHave, // Filtired "you have"
        'need': relevantNeed, // Filtired "you need"
      };
    }).toList();
  }

  @override
  /// UI BUILD:
  /// Displays list of recipes as cards
  /// Each card shows:
  /// - Image
  /// - Title
  /// - Match %
  /// - Ingredients user has
  /// - Ingredients user is missing
  /// Clicking a card opens detailed recipe page


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Recipe for you")),
    body: Column(
      children: [
        
        // Recipie list 
        Expanded(
          child: ListView.builder(
            itemCount: recipeDisplayData.length,
            itemBuilder: (context, index) {
              final data = recipeDisplayData[index];
              final recipe = data['recipe'] as Map<String, dynamic>;
              final relevantHave = data['have'] as List<String>;
              final relevantNeed = data['need'] as List<String>;

              return GestureDetector(
                // Fetch full details and navigate to detail page
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
                // Card UI
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
                      // Recipie image 
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
                                Text("${recipe['finalScore'].toStringAsFixed(0)}% Match"),
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

        // Restart button goes back to ingredient selection page
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