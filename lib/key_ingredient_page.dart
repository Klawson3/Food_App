import 'package:flutter/material.dart';
import 'package:food_app/spoonacular_service.dart';
import 'question_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'package:animate_do/animate_do.dart';

//This is the page in which the user inputs a single ingredient that they want to use.
class IngredientPage extends StatefulWidget {
  const IngredientPage({super.key});

  @override
  State<IngredientPage> createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  final TextEditingController _controller = TextEditingController();
  final SpoonacularService service = SpoonacularService();
  
  bool isLoading = false;

  Future<void> fetchRecipes() async {
    String input = _controller.text.trim();

    
    if (input.isEmpty) { // Tells the user to input something if they haven't done that and pressed the button 
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
      final recipes = await service.searchByIngredients(ingredients); // Sends the 1-item list to the API

      
      if (!mounted) return;

      
      if (recipes.isEmpty) { //Check if the API returned 0 recipes (ingredient likely not found/misspelled)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("We are unable to find that item in our database... please check your spelling!"),
            backgroundColor: AppColors.carrotOrange, 
            duration: const Duration(seconds: 4), 
          )
        );
        return; 
      }
      
      // Navigate to the next page
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
    } catch (e) { //Catches errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Oops! We had trouble searching for that. Please check your spelling or internet connection and try again."),
          backgroundColor: AppColors.carrotOrange, 
        )
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.fetaWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        //iconTheme: const IconThemeData(color: AppColors.deepSpinach),
        // UI UPDATE: Animated the title sliding down
        title: FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Text(
            "Main Ingredient",
            style: GoogleFonts.nunito(
              fontSize: 26,
              color: AppColors.deepSpinach,
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
        // UI UPDATE: SafeArea ensures content doesn't hit the phone's clock/notch
        child: SafeArea(
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
                        color: AppColors.peppercorn,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 30),

                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
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
                          color: AppColors.deepSpinach,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: "E.g. Chicken, Tofu, Broccoli...",
                          hintStyle: TextStyle(color: AppColors.peppercorn.withOpacity(0.4)),
                          prefixIcon: const Icon(Icons.restaurant, color: AppColors.crispLettuce),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: AppColors.crispLettuce, width: 2),
                          ),
                        ),
                        onSubmitted: (value) => fetchRecipes(),
                      ),
                    ),

                    const SizedBox(height: 50),

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
                    
                    const SizedBox(height: 80), 
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