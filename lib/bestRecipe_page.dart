import 'package:flutter/material.dart';
import 'spoonacular_service.dart';
import 'allRecipes_page.dart';
import 'recipe_detail_page.dart';

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

class _RecipePageState extends State<RecipePage> {

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

  @override
  Widget build(BuildContext context) {
    final recipe = widget.bestRecipe;
    final have = widget.haveIngredients;
    final need = widget.needIngredients;

    final originalRecipe = widget.recipes.firstWhere(
      (r) => r['id'] == recipe['id'],
      orElse: () => {},
    );

    final usedAndMissed = [
      ...(originalRecipe['usedIngredients'] ?? []),
      ...(originalRecipe['missedIngredients'] ?? []),
    ];

    final usedAndMissedNames =
        usedAndMissed.map((i) => i['name'].toString().toLowerCase()).toSet();

    final extendedIngredients =
        recipe['extendedIngredients'] as List? ?? [];

    final extraHave = have.where((h) =>
        !usedAndMissedNames.contains(h.toLowerCase()) &&
        !usedAndMissed.any((i) =>
            i['name'].toString().toLowerCase().contains(h.toLowerCase())) &&
        extendedIngredients.any((ing) =>
            ing['name'].toString().toLowerCase().contains(h.toLowerCase())))
        .map((h) => {'name': h})
        .toList();

    final allIngredients = [...extraHave, ...usedAndMissed];

    int used = have.length;
    int missing = need.length;
    int total = used + missing;

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
                    fontSize: 18,
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
                          size: 16,
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(name.toString())),
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
                  child: const Text("Cook"),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: seeMore,
                  child: const Text("See More Recipes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}