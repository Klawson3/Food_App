import 'package:flutter/material.dart';
import 'spoonacular_service.dart';
import 'allRecipes_page.dart';
import 'recipe_detail_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// RecipePage displays the highest-ranked recipe recommendation
/// generated from the user's available ingredients.
/// 
/// The page presents:
/// - A recipe image
/// - Recipe titles and match score
/// - Ingredients the user has in possesion
/// - Navigation to cooking instructions
/// - Access to additional recipe recommendations
/// 
 
 /// RecipePageState ectends a StatefulWidget inside the RecipePage
 /// that performs navigation and dynamically processes recipe data.
class RecipePage extends StatefulWidget {
  final SpoonacularService service;
  final Map<String, dynamic> bestRecipe;
  final List<String> haveIngredients;
  final List<String> needIngredients;
  final List<dynamic> recipes;
  final Map<int, List<String>> recipeNeedMap;
 
  const RecipePage({
    super.key,
    required this.service,
    required this.bestRecipe,
    required this.haveIngredients,
    required this.needIngredients,
    required this.recipes,
    required this.recipeNeedMap,
  });


  @override
  State<RecipePage> createState() => _RecipePageState();
}

/// Manages recipe processing, ingredient analysis, 
/// and navigation functionality for RecipePage. 
class _RecipePageState extends State<RecipePage> {


/// Existing recipe and ingredient data are passed forward
/// to perserve application state and avpid redundant API calls.
  void seeMore() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          service: widget.service,
          bestRecipe: widget.bestRecipe,
          recipes: widget.recipes,
          haveIngredients: widget.haveIngredients,
          needIngredients: widget.needIngredients,
          recipeNeedMap: widget.recipeNeedMap,
        ),
      ),
    );
  }


/// Fetches detailed recipe information from the API
/// and navigates to the RecipeDetailPage.
/// 
/// This function retrieves ecpanded instructions,
/// ingredient measurements, and additional recipes.
  void cookRecipe() async {
    final details =
        await widget.service.getRecipeDetails(widget.bestRecipe['id']);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailPage(
          recipe: widget.bestRecipe,
          details: details,
        ),
      ),
    );
  }


/// Builds thr UI for the best recipe recommendation.
/// 
/// The interface includes:
/// - Recipe image
/// - Match score display
/// - Ingredient availability analysis
/// - Navigation controls
/// 
/// Ingredient indicators visually distinguish:
/// - Ingredients already available
/// - Nuetral recipe ingredients
  @override
  Widget build(BuildContext context) {
    final recipe = widget.bestRecipe;
    final have = widget.haveIngredients;
    final need = widget.needIngredients;

    // Locate the original recipe object.
    final originalRecipe = widget.recipes.firstWhere(
      (r) => r['id'] == recipe['id'],
      orElse: () => {},
    );
    // Combine used and missing ingredients for 
    // unified ingredient analysis and display.
    final usedAndMissed = [
      ...(originalRecipe['usedIngredients'] ?? []),
      ...(originalRecipe['missedIngredients'] ?? []),
    ];
    // Improves comparison efficiency and consistency.
    final usedAndMissedNames =
        usedAndMissed.map((i) => i['name'].toString().toLowerCase()).toSet();

    // Retrieve the complete ingredient list from the detailed recipe data.
    final extendedIngredients =
        recipe['extendedIngredients'] as List? ?? [];

    // Identify additional user ingredients that may not appear
    // in the API's used ingredient list but are still relevant
    // to recipe's extended ingredient list.
    final extraHave = have.where((h) =>
        !usedAndMissedNames.contains(h.toLowerCase()) &&
        !usedAndMissed.any((i) =>
            i['name'].toString().toLowerCase().contains(h.toLowerCase())) &&
        extendedIngredients.any((ing) =>
            ing['name'].toString().toLowerCase().contains(h.toLowerCase())))
        .map((h) => {'name': h})
        .toList();

    // Merge additional ingredients with original ingredients for final display.
    final allIngredients = [...extraHave, ...usedAndMissed];

    int used = have.length;
    int missing = need.length;
    int total = used + missing;

    // Calculate the recipe match score based on:
    // Available ingredients, missing ingredients, and overall 
    // recipe complexity.
    //
    // Higher score means that the recipe is both feasible and 
    // relatively simple to prepare.
    double matchScore = total == 0 ? 0 : used / total;
    double complexPenalty = total / 30;
    recipe['finalScore'] = matchScore - complexPenalty;

    return Scaffold(
      extendBodyBehindAppBar: true, 
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.deepSpinach),
        toolbarHeight: 60, 
        centerTitle: true,
        title: Text(
          recipe['title'] ?? "Best Recipe Match",
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.nunito(
            fontSize: 22,
            color: AppColors.deepSpinach,
            fontWeight: FontWeight.w800,
            height: 1.2, 
          ),
        ),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // IMAGE
                  // Display the best recipe image to improve visual
                  // consistency and mobile presentation. 
                  if (recipe['image'] != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .15),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            recipe['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // RECIPE TITLE
                  Text(
                    recipe['title'] ?? "",
                    textAlign: TextAlign.center,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: GoogleFonts.nunito(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.deepSpinach,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 10),

                  //INGREDIENT TITLE
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Ingredients:",
                      style: GoogleFonts.nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.deepSpinach,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // INGREDIENT LIST
                  Column(
                    children: allIngredients.map<Widget>((i) {
                      final name = i['name'];

                      final isHave = have.any(
                        (h) => name
                            .toString()
                            .toLowerCase()
                            .contains(h.toLowerCase()),
                      );

                      final isNeed = need.contains(name);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6), 
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Icon(
                                isHave
                                    ? Icons.check_circle
                                    : isNeed
                                        ? Icons.cancel
                                        : Icons.radio_button_unchecked,
                                color: isHave
                                    ? AppColors.crispLettuce
                                    : isNeed
                                        ? AppColors.carrotOrange
                                        : Colors.grey.shade400,
                                size: 26, 
                              ),
                            ),
                            const SizedBox(width: 12),
                            
                              Expanded(
                                child: Text(
                                  name.toString()[0].toUpperCase() + name.toString().substring(1), 
                                  style: GoogleFonts.nunito(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.peppercorn,
                                  ),
                                )
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // BUTTONS
                  SizedBox(
                    width: double.infinity,
                    height: 60, 
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.carrotOrange,
                        foregroundColor: AppColors.fetaWhite,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: cookRecipe,
                      child: Text("Cook", // Navigate to detailed cooking instructions.
                        style: GoogleFonts.nunito(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 60, 
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.deepSpinach,
                        side: const BorderSide(color: AppColors.deepSpinach, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: seeMore,
                      child: Text("See More Recipes", // Navigate to AllRecipePage for additional recipes.
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20), // Bottom padding
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}