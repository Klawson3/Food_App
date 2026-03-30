import 'package:flutter/material.dart';
import 'spoonacular_service.dart';
import 'recipe_page.dart';

class QuestionPage extends StatefulWidget {
  final List<dynamic> recipes; //dynamic means the list can contain any type of data
  final SpoonacularService service; //Service to fetch recipe data

  //constructor
  const QuestionPage({
    super.key,
    required this.recipes,
    required this.service,
  });

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int recipeIndex = 0;
  int ingredientIndex = 0;
  int numQuestions = 0;

  List<String> haveIngredients = [];
  List<String> needIngredients = [];

  /*
  [getter] Acts like a variable but recalculates every time it's accessed
  When recipeIndex changes, currentRecipe automatically updates too
  */
  dynamic get currentRecipe => widget.recipes[recipeIndex];
  //[getter] Retrieve the ingredient name at "ingredientIndex" from current recipe's missing ingredients.
  String get currentIngredient {
    List missedList = currentRecipe['missedIngredients'];
    Map ingredient = missedList[ingredientIndex];
    return ingredient['name'];
  }
  
  dynamic bestRecipe;

  void goToRecipePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipePage(
          service: widget.service,
          bestRecipe: bestRecipe,
          haveIngredients: haveIngredients,
          needIngredients: needIngredients,
        ),
      ),
    );
  }

  void onPressedYes() {
    final recipe = currentRecipe;
    final List missedList = recipe['missedIngredients'];
    final ingredient = missedList[ingredientIndex]['name'];

    haveIngredients.add(ingredient);

    final nextNumQuestions = numQuestions + 1;
    final nextIngredientIndex = ingredientIndex + 1;

    bestRecipe = recipe;

    if (nextNumQuestions >= 3 || nextIngredientIndex >= missedList.length) {
      goToRecipePage();
      return;
    }

    setState(() {
      numQuestions = nextNumQuestions;
      ingredientIndex = nextIngredientIndex;
    });
  }

  void onPressedNo() {
    final recipe = currentRecipe;
    final List missedList = recipe['missedIngredients'];
    final ingredient = missedList[ingredientIndex]['name'];

    needIngredients.add(ingredient);

    final nextNumQuestions = numQuestions + 1;
    final nextRecipeIndex = recipeIndex + 1;
    
    if (nextNumQuestions >= 3 || nextRecipeIndex >= widget.recipes.length) {
      bestRecipe ??= currentRecipe; //if bestRecipe is null, assign it to currentRecipe
      goToRecipePage();
      return;
    }
    setState(() {
      numQuestions = nextNumQuestions;
      recipeIndex = nextRecipeIndex;
      ingredientIndex = 0;
    });
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