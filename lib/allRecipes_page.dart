import 'package:flutter/material.dart';
import 'spoonacular_service.dart';
import 'recipe_detail_page.dart';
import 'key_ingredient_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class ResultPage extends StatefulWidget {
  final Map<String, dynamic> bestRecipe;
  final SpoonacularService service;
  final List<dynamic> recipes;
  final List<String> haveIngredients;
  final List<String> needIngredients;
  final Map<int, List<String>> recipeNeedMap;   // Map to store missing ingredients per recipe ID.
 

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
      double simplicityBonus = (1 / (total + 1)) * 10; // Tweakable bonus for simpler recipes.
      recipe['finalScore'] = (matchScore + simplicityBonus).clamp(0,100); // Final score out of 100.
    }

    // Sort recipe by descending score. 
    sortedRecipes.sort((a, b) {
      int scoreCompare = b['finalScore'].compareTo(a['finalScore']);
      if (scoreCompare != 0) return scoreCompare;
      return a['missedIngredientCount'].compareTo(b['missedIngredientCount']);
    });

    // Buiild display-friendly data structure with relevant have/need lists for each recipe.
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
        'recipe': recipe,  // Full recipe object.
        'have': relevantHave, // Filtired "you have".
        'need': relevantNeed, // Filtired "you need".
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
    extendBodyBehindAppBar: true,

    appBar: AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: AppColors.deepSpinach),
      title: Text(
        "Recipes for you",
        style: GoogleFonts.nunito(
          fontSize: 26,
          color: AppColors.deepSpinach,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
    
    body: Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: SafeArea(
        child: Column(
          children: [
            
            // Recipie list 
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: recipeDisplayData.length,
                itemBuilder: (context, index) {
                  final data = recipeDisplayData[index];
                  final recipe = data['recipe'] as Map<String, dynamic>;
                  final relevantHave = data['have'] as List<String>;
                  final relevantNeed = data['need'] as List<String>;

                  return GestureDetector(
                    // Fetch full details and navigate to detail page.
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
                      color: AppColors.fetaWhite,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      elevation: 5,
                      shadowColor: Colors.black.withValues(alpha: .3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), 
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recipie image 
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20), 
                            ),
                            child: Image.network(
                              recipe['image'],
                              height: 180, 
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16), 
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe['title'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.nunito(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.deepSpinach,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: AppColors.carrotOrange, size: 24),
                                    const SizedBox(width: 6),
                                    Text(
                                      "${recipe['finalScore'].toStringAsFixed(0)}% Match",
                                      style: GoogleFonts.nunito(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.peppercorn,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "You have: ${relevantHave.join(", ")}",
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: AppColors.peppercorn,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (relevantNeed.isNotEmpty)
                                  Text(
                                    "Missing: ${relevantNeed.join(", ")}",
                                    style: GoogleFonts.nunito(
                                      fontSize: 18,
                                      color: AppColors.carrotOrange,
                                      fontWeight: FontWeight.bold,
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

            // Restart button goes back to ingredient selection page.
            Padding(
              padding: const EdgeInsets.all(20), 
              child: SizedBox(
                width: double.infinity,
                height: 60, 
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepSpinach,
                    foregroundColor: AppColors.fetaWhite,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            IngredientPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Restart",
                    style: GoogleFonts.nunito(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
} // close build

} //close _ResultPageState