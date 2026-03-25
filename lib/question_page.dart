import 'package:flutter/material.dart';
import 'spoonacular_service.dart';
import 'result_page.dart';
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
  void onPressedYes() {
    bestRecipe = currentRecipe;
    setState(() {
      numQuestions += 1;
      ingredientIndex += 1;
    });
    
    List missedList = currentRecipe['missedIngredients'];

    if (numQuestions >= 3 || ingredientIndex >= missedList.length) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipePage(
            service: widget.service,
            bestRecipe: bestRecipe,
          ),
        ),
      );
    }
  }

  void onPressedNo() {
    setState(() {
      numQuestions += 1;
      ingredientIndex = 0;
      recipeIndex += 1;
    });

    List missedList = currentRecipe['missedIngredients'];

    
    if (numQuestions >= 3 || ingredientIndex >= missedList.length) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipePage(
            service: widget.service,
            bestRecipe: bestRecipe,
          ),
        ),
      );
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