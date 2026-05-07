import 'package:flutter/material.dart';
import 'spoonacular_service.dart';
import 'allRecipes_page.dart';
import 'recipe_detail_page.dart';

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
      appBar: AppBar(
        title: Text(recipe['title'] ?? "Best Recipe Match"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // IMAGE
              if (recipe['image'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      recipe['image'],
                      fit: BoxFit.cover,
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
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // SCORE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    (recipe['finalScore'] is num)
                        ? (recipe['finalScore'] as num).toStringAsFixed(2)
                        : "0.00",
                  ),
                ],
              ),

              const SizedBox(height: 20),

              //INGREDIENT TITLE
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Ingredients:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

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
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          isHave
                              ? Icons.check
                              : isNeed
                                  ? Icons.cancel
                                  : Icons.circle,
                          color: isHave
                              ? Colors.green
                              : isNeed
                                  ? Colors.red
                                  : Colors.grey,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                          Expanded(child: Text(name.toString(), 
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // BUTTONS
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: cookRecipe,
                  child: const Text("Cook", 
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: seeMore,
                  child: const Text("See More Recipes", 
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}