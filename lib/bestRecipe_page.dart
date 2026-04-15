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

  void cookRecipe() async {
    final details = 
      await widget.service.getRecipeDetails(widget.bestRecipe['id']);
    if (!mounted) return;

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => RecipeDetailPage(
          recipe: widget.bestRecipe, 
          details: details,),),
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
      !usedAndMissed.any((i) =>                         
          i['name'].toString().toLowerCase().contains(h.toLowerCase())
        ) &&
        extendedIngredients.any((ing) =>
          ing['name'].toString().toLowerCase().contains(h.toLowerCase())
        )
    ).map((h) => {'name': h}).toList();

    final allIngredients = [...extraHave, ...usedAndMissed];

    return Scaffold(
      appBar: AppBar(title: Text(recipe['title'])),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // make image rounded square
            if (recipe['image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(recipe['image'],
                  fit: BoxFit.cover, ),
                ),
              ),

              const SizedBox(height:20),

              Text(
                recipe['title']?? "Recipe",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer, size: 18),
                  const SizedBox(width: 5),
                  Text("${recipe['readyInMinutes'] ?? 'N/A'} minutes"),
                  const SizedBox(width: 20),
                  const Icon(Icons.restaurant, size: 18),
                  const SizedBox(width: 5),
                  Text("${recipe['servings'] ?? 'N/A'} servings"),
              ]),
              

              const SizedBox(height: 20),

              Align (
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Ingredients:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            //Wrap text
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: have.map<Widget>((ingredient) => Chip(
                label: Text(ingredient),
                backgroundColor: Colors.green.shade100,
              )).toList(),
            ),

            const Spacer(),

            Column(
              children: [
                //cook button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: cookRecipe, 
                    child: const Text("Cook"),),
                ),

                const SizedBox(height: 10),
                // see more recipes
                SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: seeMore,
              child: const Text("See More Recipes"),
            ),
          ),
        ],
      ),

            ...allIngredients.map((i) {
              final name = i ['name'];
              if (have.any((h) => name.contains(h) || h.contains(name))) {
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
          const SizedBox(height: 20),
          const Text("Instructions:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            recipe['instructions']?.toString().replaceAll(RegExp(r'<[^>]*>'), '')
                ?? "No instructions available",
          ),
          ElevatedButton(onPressed: seeMore, child: const Text("See More")),
        ],
      ),
    ),
  );
  }
}