import 'package:flutter/material.dart';
import 'package:food_app/spoonacular_service.dart';
import 'question_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'package:animate_do/animate_do.dart';

/// KeyIngredientsPage allows the user to input a single main ingredient they currently have.
/// Users enter their ingredient into a search bar/text field.
/// Users can proceed to the questions page after they enter their ingredient.

/// StatefulWidget is used because the list of ingredients
/// changes over time based on user input.
class IngredientPage extends StatefulWidget {
  const IngredientPage({super.key});

  @override
  State<IngredientPage> createState() => _IngredientPageState();
}

/// Manages the state of the ingredient input.
/// Includes user inout, ingredient list, and API calls.
class _IngredientPageState extends State<IngredientPage> {
  
  // Captures user input from the TextField
  final TextEditingController _controller = TextEditingController();

  // Service used to fetch recipes from Spoonacular API.
  final SpoonacularService service = SpoonacularService();
  
  bool isLoading = false; 

  ////SEARCH FUCTION
  Future<void> fetchRecipes() async {
    String input = _controller.text.trim();

    if (input.isEmpty) { 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter an ingredient!"),
          backgroundColor: AppColors.carrotOrange, 
        )
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    List<String> ingredients = [input];

    try {
      final recipes = await service.searchByIngredients(ingredients); // Sends the 1-item list to the API.

      if (!mounted) return; // Makes sure the screen still exists before proceeding.
      
      if (recipes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("We are unable to find that item in our database... please check your spelling!"),
            backgroundColor: AppColors.carrotOrange, 
            duration: const Duration(seconds: 4), 
          )
        );
        return; 
      }
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return QuestionPage(
              recipes: recipes, 
              service: service, 
              initialIngredients: ingredients 
            );
          }
        ),
      );
    } catch (e) { // Will catch errors if they occur in the previous block
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Oops! We had trouble searching for that. Please check your spelling or internet connection and try again."),
          backgroundColor: AppColors.carrotOrange, 
        )
      );
    } finally { // This will always run at the end to signal that the the search function has ended,
                // no matter how it ends.
      setState(() {
        isLoading = false;
      });
    }
  }

  ////ACTUAL DISPLAY
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Text(
            "Main Ingredient",
            style: GoogleFonts.nunito(
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        centerTitle: true,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient
        ),
        child: SafeArea( // SafeArea ensures content doesn't hit the phone's clock/notch
          child: FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center( 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "What's ONE ingredient you would like to use?",
                      style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 30),

                    //Area for the user to input their ingredient. 
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller, 
                        textCapitalization: TextCapitalization.words,
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: "E.g. Chicken, Tofu, Broccoli...",
                          hintStyle: TextStyle(color: AppColors.peppercorn.withValues(alpha: 0.4)),
                          prefixIcon: const Icon(Icons.restaurant, color: AppColors.crispLettuce),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 20),
                          border: OutlineInputBorder( //displays nothing but focusedBorder needs this
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder( //the border when the using is inputting text
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: AppColors.crispLettuce, width: 2),
                          ),
                        ),
                        onSubmitted: (value) => fetchRecipes(), //Search runs when enter is pressed
                      ),
                    ),

                    const SizedBox(height: 50),

                    //Button the user can press when an ingredient is entered.
                    SizedBox(
                      width: double.infinity, 
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.carrotOrange,
                          foregroundColor: AppColors.fetaWhite,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: isLoading ? null : fetchRecipes, 
                        child: isLoading
                            ? const CircularProgressIndicator(color: AppColors.fetaWhite)
                            : Text(
                                "Find Recipes",
                                style: GoogleFonts.nunito(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 50), 
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}