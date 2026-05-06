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
  //map to store missing ingredients per recipe ID
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
  //stores processed recipe data with caluclated scores+ filtired ingridient list
  @override

  void initState() {
    super.initState();
    // creates copy so dont mutate og list directly
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
      double simplicityBonus = (1 / (total + 1)) * 10; // tweakable bonus for simpler recipes
      recipe['finalScore'] = (matchScore + simplicityBonus).clamp(0,100); // final score out of 100
    }
    // sort recipise by descending score 
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
        'recipe': recipe,  //full recipe object
        'have': relevantHave, // filtired "you have"
        'need': relevantNeed, // filtired "you need"
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
        //recipie list 
        Expanded(
          child: ListView.builder(
            itemCount: recipeDisplayData.length,
            itemBuilder: (context, index) {
              final data = recipeDisplayData[index];
              final recipe = data['recipe'] as Map<String, dynamic>;
              final relevantHave = data['have'] as List<String>;
              final relevantNeed = data['need'] as List<String>;

              return GestureDetector(
                //when recupie is tapped. fetch full details and navigate to detail page
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
                ///card UI
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
                      //recipie image 
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
        ///restart button goes back to ingredient selection
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