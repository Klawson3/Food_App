import 'package:flutter/material.dart';
import 'spoonacular_service.dart';
import 'bestRecipe_page.dart';
import 'app_colors.dart'; 
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class QuestionPage extends StatefulWidget {
  final List<dynamic> recipes;
  final SpoonacularService service; 
  final List<String> initialIngredients;

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
  final int maxRecipeIndex = 3; 
  Map<int, List<String>> needIngredientsMap = {};

  List<String> haveIngredients = [];
  List<String> needIngredients = [];
  Set<String> askedIngredients = {};

  @override
  void initState() {
    super.initState();
    haveIngredients = List<String>.from(widget.initialIngredients);
    askedIngredients = Set<String>.from(widget.initialIngredients);
  }

  dynamic get currentRecipe => widget.recipes[recipeIndex];

  List get missedList => currentRecipe['missedIngredients'] ?? [];
  
  String get currentIngredient {
    for (int i = ingredientIndex; i < missedList.length; i++) {
      final name = missedList[i]['name'] as String;
      if (!askedIngredients.contains(name)) {
        ingredientIndex = i; 
        return name;
      }
    }
    return "no more ingredients";
  }

  Future<void> goToRecipePage() async {
    if (!needIngredientsMap.containsKey(recipeIndex)) {
      needIngredientsMap[recipeIndex] = List.from(needIngredients);
    }

    final perfect = needIngredientsMap.entries.where((e) => e.value.isEmpty).toList();

    int bestIndex;
    if (perfect.isNotEmpty) {
      bestIndex = perfect.first.key;
    } else {
      bestIndex = needIngredientsMap.entries.reduce((a, b) {
        int scoreA = widget.recipes[a.key]['usedIngredientCount'] - a.value.length;
        int scoreB = widget.recipes[b.key]['usedIngredientCount'] - b.value.length;
        return scoreA >= scoreB ? a : b;
      }).key;
    }

    final bestRecipe = widget.recipes[bestIndex];
    final recipeDetails = await widget.service.getRecipeDetails(bestRecipe['id']);

    if (!mounted) return;

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => RecipePage(
        service: widget.service,
        bestRecipe: recipeDetails,
        haveIngredients: haveIngredients,
        needIngredients: needIngredientsMap[bestIndex] ?? [],
        recipes: widget.recipes,
        recipeNeedMap: needIngredientsMap,
      ),
    ));
  }

  void moveToNextRecipe() {
    needIngredientsMap[recipeIndex] = List.from(needIngredients);

    final lastNeed = needIngredientsMap[recipeIndex]!;
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
        moveToNextRecipe();
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
      extendBodyBehindAppBar: true, 
      
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
          gradient: AppColors.backgroundGradient
        ),
        
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                "Do you have this in\nyour fridge?",
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
                  alignment: const Alignment(0, -0.2), 
                  child: SizedBox(
                    width: 300,
                    height: 350,
                    child: CardSwiper(
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
                          return const SizedBox();
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
                                    color: Colors.black.withValues(alpha: .2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    currentIngredient,
                                    style: const TextStyle(
                                      fontSize: 32, 
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.deepSpinach,
                                      height: 1.2, // Adds nice spacing between wrapped lines
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 4, // Safety net
                                    overflow: TextOverflow.ellipsis, // Adds "..." if it exceeds 4 lines
                                  ),
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
                                        ? AppColors.crispLettuce.withValues(alpha: 0.4)
                                        : AppColors.carrotOrange.withValues(alpha: 0.4),
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

              // The "Swipe Track" Legend
              Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: Container(
                  width: 280, 
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(50), 
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // No Direction Indicator
                      Row(
                        children: [
                          const Icon(Icons.keyboard_double_arrow_left, color: AppColors.carrotOrange, size: 24),
                          const SizedBox(width: 4),
                          const Icon(Icons.close, color: AppColors.carrotOrange, size: 28),
                        ],
                      ),
                      
                      // Gently pulsing swipe hand 
                      Pulse(
                        infinite: true, 
                        duration: const Duration(milliseconds: 1500),
                        child: Icon(
                          Icons.swipe, 
                          color: AppColors.peppercorn.withValues(alpha: .4), 
                          size: 35,
                        ),
                      ),

                      // Yes Direction Indicator
                      Row(
                        children: [
                          const Icon(Icons.check, color: AppColors.crispLettuce, size: 28),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_double_arrow_right, color: AppColors.crispLettuce, size: 24),
                        ],
                      ),
                    ],
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