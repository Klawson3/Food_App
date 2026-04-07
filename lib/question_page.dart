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
  int recipeIndex = 0;
  int ingredientIndex = 0;
  int numQuestions = 0; 
  final int maxQuestions = 6;
  Map<int, List<String>> recipeNeedMap = {};


  List<String> haveIngredients = [];
  List<String> needIngredients = [];

  @override
  void initState() {
    super.initState();
    haveIngredients = List<String>.from(widget.initialIngredients);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (missedList.isEmpty) {
        goToRecipePage();
      }
    });
  }


  /*
  [getter] Acts like a variable but recalculates every time it's accessed
  When recipeIndex changes, currentRecipe automatically updates too
  */
  dynamic get currentRecipe => widget.recipes[recipeIndex];

  List get missedList => currentRecipe['missedIngredients'] ?? [];
  //[getter] Retrieve the ingredient name at "ingredientIndex" from current recipe's missing ingredients.
  String get currentIngredient {
    if (missedList.isEmpty) return "no more ingredients";

    if (ingredientIndex >= missedList.length) {
      return "no more ingredients";
    }
    return missedList[ingredientIndex]['name'];
  }

  Future<void> goToRecipePage() async {
    //find recipe with highest rank
    recipeNeedMap[recipeIndex] = List.from(needIngredients);

    // Find the recipe with the least number of needed ingredients
    int bestIndex = recipeNeedMap.entries
      .reduce((a, b) => a.value.length <= b.value.length ? a : b)
      .key;

    final bestRecipe = widget.recipes[bestIndex];
    final details = await widget.service.getRecipeDetails(bestRecipe['id']);

    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => RecipePage(
        service: widget.service,
        bestRecipe: details,
        haveIngredients: haveIngredients,
        needIngredients: needIngredients,
        recipes: widget.recipes,
      ),
    ));
  }


  void moveToNextRecipe() {
    recipeNeedMap[recipeIndex] = List.from(needIngredients);
  
    if (recipeIndex < widget.recipes.length - 1) {
      setState(() {
        recipeIndex++;
        ingredientIndex = 0;
        needIngredients = [];
        
      });
    } else {
      goToRecipePage(); 
    }
  }


  void onPressedYes() {
    final ingredient = currentIngredient;
    
    if (!haveIngredients.contains(ingredient)) {
      haveIngredients.add(ingredient);
    }

    numQuestions++;

    if (numQuestions >= maxQuestions) {
      goToRecipePage();
      return;
    }

    setState(() {
      if (ingredientIndex >= missedList.length - 1) {
        moveToNextRecipe(); // Move to the next recipe
      } else {
        ingredientIndex++;
      }
    });
  }

  void onPressedNo() {
    final ingredient = currentIngredient;
    numQuestions++;

    if (!needIngredients.contains(ingredient)) {
      needIngredients.add(ingredient);
    }

    if (numQuestions >= maxQuestions) {
      goToRecipePage();
      return;
    }

    setState(() {
      if (ingredientIndex >= missedList.length - 1) {
        moveToNextRecipe(); 
      } else {
        ingredientIndex++;
      }
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