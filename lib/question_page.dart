import 'package:flutter/material.dart';
import 'spoonacular_service.dart';
import 'bestRecipe_page.dart';
import 'app_colors.dart'; // UI UPDATE: Imported central color hub
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';


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
  final CardSwiperController _swiperController = CardSwiperController();
  int recipeIndex = 0;
  int ingredientIndex = 0;
  final int maxRecipeIndex =3;
  Map<int, List<String>> recipeNeedMap = {};

  List<String> haveIngredients = [];
  List<String> needIngredients = [];
  Set<String> askedIngredients = {};

  @override
  void initState() {
    super.initState();
    haveIngredients = List<String>.from(widget.initialIngredients);
    askedIngredients = Set<String>.from(widget.initialIngredients);
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }
  /*
  [getter] Acts like a variable but recalculates every time it's accessed
  When recipeIndex changes, currentRecipe automatically updates too
  */
  dynamic get currentRecipe => widget.recipes[recipeIndex];

  List get missedList => currentRecipe['missedIngredients'] ?? [];
  //[getter] Retrieve the ingredient name at "ingredientIndex" from current recipe's missing ingredients.
  String get currentIngredient {
    for (int i = ingredientIndex; i < missedList.length; i++) {
      final name = missedList[i]['name'] as String;
      if (!askedIngredients.contains(name)) {
        ingredientIndex = i; // jump to first un-asked ingredient
        return name;
      }
    }
    return "no more ingredients";
}

  Future<void> goToRecipePage() async {
    // store the missing ingredients, labeled by recipe index
    if (!recipeNeedMap.containsKey(recipeIndex)) {
      recipeNeedMap[recipeIndex] = List.from(needIngredients);
    }

    // Find perfect recipe
    final perfect = recipeNeedMap.entries.where((e) => e.value.isEmpty).toList();

    // Find the most matched recipe
    int bestIndex;
    if (perfect.isNotEmpty) {
      bestIndex = perfect.first.key;
    } else {
      // prioritize recipes with higher score (fewer missing, relative more used)
      bestIndex = recipeNeedMap.entries.reduce((a, b) {
        int scoreA = widget.recipes[a.key]['usedIngredientCount'] - a.value.length;
        int scoreB = widget.recipes[b.key]['usedIngredientCount'] - b.value.length;
        return scoreA >= scoreB ? a : b;
      }).key;
    }

    final bestRecipe = widget.recipes[bestIndex];
    final details = await widget.service.getRecipeDetails(bestRecipe['id']);

    if (!mounted) return;

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => RecipePage(
        service: widget.service,
        bestRecipe: details,
        haveIngredients: haveIngredients,
        needIngredients: recipeNeedMap[bestIndex] ?? [], 
        recipes: widget.recipes,
        recipeNeedMap: recipeNeedMap,
      ),
    ));
  }

  void moveToNextRecipe() {
    recipeNeedMap[recipeIndex] = List.from(needIngredients);

    final lastNeed = recipeNeedMap[recipeIndex]!;
    if (lastNeed.isEmpty) {
        goToRecipePage();
        return;
    }

    if (recipeIndex < maxRecipeIndex && recipeIndex < widget.recipes.length - 1) {
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
    askedIngredients.add(ingredient);
    
    if (!haveIngredients.contains(ingredient)) {
      haveIngredients.add(ingredient);
    }

    if (recipeIndex >= maxRecipeIndex) {
      goToRecipePage();
      return;
    }

    if (ingredientIndex >= missedList.length - 1) {
        moveToNextRecipe(); // Move to the next recipe
        return;
    }
    setState(() {
      ingredientIndex++;
    });
  }

  void onPressedNo() {
    final ingredient = currentIngredient;
    askedIngredients.add(ingredient); 

    if (!needIngredients.contains(ingredient)) {
      needIngredients.add(ingredient);
    }

    if (recipeIndex >= maxRecipeIndex) {
      goToRecipePage();
      return;
    }
    if (ingredientIndex >= missedList.length - 1) {
      moveToNextRecipe(); 
      return;
    }
    setState(() {
      ingredientIndex++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.deepSpinach),
        title: Text(
          "Check Ingredients",
          style: GoogleFonts.nunito(
            fontSize: 26,
            color: AppColors.deepSpinach,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // UI UPDATE: Swapped pinks for salad gradient
            colors: [
              AppColors.fetaWhite,
              AppColors.crispLettuce.withOpacity(0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text("Do you have this in\nyour fridge?",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 25,
            fontWeight: FontWeight.w600,
            color: AppColors.peppercorn,
          ),
        ),
        const SizedBox (height: 10),

        Expanded(
          child: Align(
            alignment: const Alignment(0, -0.5),
            child: SizedBox(
              width: 300,
              height: 350,
              child: CardSwiper(
                controller: _swiperController,
                cardsCount: 1,
                numberOfCardsDisplayed: 1,
                onSwipe: (previousIndex, currentIndex, direction) {
                  if (direction == CardSwiperDirection.left) {
                    onPressedNo();
                  } else if (direction == CardSwiperDirection.right) {
                    onPressedYes();
                  }
                  return true;
                },
                cardBuilder: (context, index, horizontalOffset, verticalOffset) {
                  if (currentIngredient == "no more ingredients") {
                    return SizedBox();
                  }
                  final isRight = horizontalOffset > 0;
                  final opacity = (horizontalOffset.abs() / 100).clamp(0.0, 1.0);
                  
                  return Stack(
                    children: [
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: AppColors.fetaWhite,
                          borderRadius: BorderRadius.circular(25),  
                          boxShadow: [                              
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            currentIngredient,
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                              color: AppColors.deepSpinach,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      // Overlay
                      Positioned.fill(
                        child: AnimatedOpacity(
                          duration: Duration.zero,
                          opacity: opacity,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isRight
                                  ? AppColors.crispLettuce.withOpacity(0.4)
                                  : AppColors.carrotOrange.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Icon(
                                isRight ? Icons.check_circle : Icons.cancel,
                                color: Colors.white,
                                size: 80,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },         
              ),
            ),
          ),
        ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 65),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.close, color: AppColors.carrotOrange),
                  const SizedBox(width: 4),
                  Text('Swipe left for No', style: GoogleFonts.nunito(color: AppColors.carrotOrange)),
                ]),
                Row(children: [
                  Text('Swipe right for Yes', style: GoogleFonts.nunito(color: AppColors.crispLettuce)),
                  const SizedBox(width: 4),
                  const Icon(Icons.check, color: AppColors.crispLettuce),
                ]),
              ],
            ),
          ),
        ], 
      ),
    ),
   );
  }
} 