import 'package:flutter/material.dart';
import 'spoonacular_service.dart';
import 'allRecipes_page.dart';

class RecipePage extends StatefulWidget {
  final SpoonacularService service;
  final Map<String, dynamic> bestRecipe;
  final List<String> haveIngredients;
  final List<String> needIngredients;
  final List<dynamic> recipes;
  final Map<int, List<String>> recipeNeedMap;

  //constructor
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
      ...originalRecipe['usedIngredients'] ?? [],
      ...originalRecipe['missedIngredients'] ?? [],
    ];

    final usedAndMissedNames = usedAndMissed.map((i) => i['name'].toString().toLowerCase()).toSet();

    final extendedIngredients = recipe['extendedIngredients'] as List? ?? [];

    final extraHave = have.where((h) =>
      !usedAndMissedNames.contains(h.toLowerCase()) &&
      extendedIngredients.any((ing) =>
        ing['name'].toString().toLowerCase().contains(h.toLowerCase())
      )
    ).map((h) => {'name': h}).toList();

    final allIngredients = [...extraHave, ...usedAndMissed];

    return Scaffold(
      appBar: AppBar(title: Text(recipe['title'])),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: [
            ...allIngredients.map((i) {
              final name = i ['name'];
              if (have.contains(name)) {
                return Row(children: [
                  const Icon(Icons.check, color: Colors.green),
                  const SizedBox(width: 10),
                  Text(name),
                ]);
              } else if (need.contains(name)) {
              return Row(children: [
                const Icon(Icons.cancel, color: Colors.red),
                const SizedBox(width: 10),
                Text(name),
              ]);
            } else {
              return Row(children: [
                const Icon(Icons.circle, size: 8),
                const SizedBox(width: 10),
                Text(name),
              ]);
            }
          }),
          ElevatedButton(onPressed: seeMore, child: const Text("See More")),
        ],
      ),
    ),
  );
  }
}