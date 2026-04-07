import 'package:flutter/material.dart';
import 'spoonacular_service.dart';
import 'bestRecipe_page.dart';

class QuestionPage extends StatefulWidget {
  final List<dynamic> recipes; //dynamic means the list can contain any type of data
  final SpoonacularService service; //Service to fetch recipe data
  final List<String> initialIngredients; // key ingredients

  //constructor
  const QuestionPage({
    super.key,
    required this.recipes,
    required this.service,
    required this.initialIngredients,
  });

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int ingredientIndex = 0;
  int numQuestions = 0;

  List<String> haveIngredients = [];
  List<String> needIngredients = [];

  dynamic bestRecipe;

  @override
  void initState() {
    super.initState();
    haveIngredients = List<String>.from(widget.initialIngredients);
  }

  /*
  [getter] Acts like a variable but recalculates every time it's accessed
  When recipeIndex changes, currentRecipe automatically updates too
  */
  dynamic get currentRecipe => widget.recipes.first;
  //[getter] Retrieve the ingredient name at "ingredientIndex" from current recipe's missing ingredients.
  String get currentIngredient {
    List missedList = currentRecipe['missedIngredients'];

    if (missedList.isEmpty) return "no more ingredients";

    if (ingredientIndex >= missedList.length) {
      ingredientIndex = 0;
    }

    return missedList[ingredientIndex]['name'];
  }

  Future<void> goToRecipePage() async {
    //find recipe with highest rank
    final best = bestRecipe ?? widget.recipes.first;
    final int recipeId = best['id'];

    // Fetch recipe details
    final details = await widget.service.getRecipeDetails(recipeId);

    if (!mounted) return;

    final updatedDetails = Map<String, dynamic>.from(details);

    final allIngredients = [
      ...(updatedDetails['extendedIngredients'] as List)
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipePage(
          service: widget.service,
          recipes: widget.recipes,
          bestRecipe: details, //if bestRecipe is null, use currentRecipe
          haveIngredients: haveIngredients,
          needIngredients: needIngredients,
        ),
      ),
    );
  }

  void onPressedYes() {
    final ingredient = currentIngredient;

    if (!haveIngredients.contains(ingredient)) {
      haveIngredients.add(ingredient);
    }

    numQuestions++;

    reRankRecipes(); //  THIS is the key

    if (numQuestions >= 6) {
      bestRecipe = widget.recipes.first;
      goToRecipePage();
      return;
    }

    setState(() {
      ingredientIndex++;
    });
  }

  void onPressedNo() {
    final ingredient = currentIngredient;

    if (!needIngredients.contains(ingredient)) {
      needIngredients.add(ingredient);
    }

    numQuestions++;

    reRankRecipes(); //  THIS is the key

    if (numQuestions >= 6) {
      bestRecipe = widget.recipes.first;
      goToRecipePage();
      return;
    }

    setState(() {
      ingredientIndex++;
    });
}
  void reRankRecipes() {
  for (var recipe in widget.recipes) {
    int used = recipe['usedIngredientCount'];
    int missing = recipe['missedIngredientCount'];
    int total = used + missing;

    //  Base score (based on user input)
    double matchScore =
        widget.initialIngredients.isEmpty
            ? 0
            : used / widget.initialIngredients.length;

    double complexityPenalty = total / 15;

    double questionScore = 0;

    List usedNames = (recipe['usedIngredients'] as List)
        .map((e) => e['name'])
        .toList();

    List missedNames = (recipe['missedIngredients'] as List)
        .map((e) => e['name'])
        .toList();

    //  Reward ingredients user HAS
    for (var ing in haveIngredients) {
      if (usedNames.contains(ing)) {
        questionScore += 0.3;
      }
    }

    //  Penalize ingredients user DOESN’T HAVE
    for (var ing in needIngredients) {
      if (missedNames.contains(ing)) {
        questionScore -= 0.5;
      }
    }

    recipe['finalScore'] =
        matchScore - complexityPenalty + questionScore;
  }

  //  Sort recipes AFTER updating scores
  widget.recipes.sort((a, b) {
    int scoreCompare =
        b['finalScore'].compareTo(a['finalScore']);
    if (scoreCompare != 0) return scoreCompare;

    return a['missedIngredientCount'] 
        .compareTo(b['missedIngredientCount']);
  });
}

void checkIfPerfectMatch() {
  final topRecipe = widget.recipes.first;
  final missedList = topRecipe['missedIngredients'] as List;

  bool allHave = missedList.every(
    (ing) => haveIngredients.contains(ing['name'])
  );
  if (allHave) {
    bestRecipe = topRecipe;
    goToRecipePage();
  }
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checking Ingredient'),
      ),
      body: Padding(padding: const EdgeInsets.all(25),
      child: Column(children: [
        Text("Do you have $currentIngredient?"),
        const SizedBox(height: 25),
        ElevatedButton(onPressed: onPressedYes, child: const Text("Yes")),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: onPressedNo, child: const Text("No")),
      ],)
      )
    );
  }
}