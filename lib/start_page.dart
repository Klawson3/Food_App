import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'package:animate_do/animate_do.dart'; 

//import 'diet_selection_page.dart';
import 'key_ingredient_page.dart';

//This is the first page that the user sees when they open the app. 
class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.backgroundGradient
            ),
          ),

          // UI UPDATE: Removed the pink overlay Container to clean up the widget tree.

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // UI UPDATE: Wrapped the Title in a FadeInDown animation
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    "Cook4U",
                    style: GoogleFonts.nunito(
                      fontSize: 60,
                      // UI UPDATE: Applied Deep Spinach to the title
                      color: AppColors.carrotOrange,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // UI UPDATE: Wrapped the Subtitle in a FadeIn animation with a slight delay
                FadeIn(
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    "Find recipes for what you have",
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      // UI UPDATE: Applied Peppercorn black to the subtitle
                      color: AppColors.peppercorn,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // UI UPDATE: Wrapped the Button in a FadeInUp animation so it rises into place
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  duration: const Duration(milliseconds: 800),
                  child: ElevatedButton(
                    // UI UPDATE: Added styleFrom to apply our Carrot Orange color and rounded pill shape
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.carrotOrange,
                      foregroundColor: AppColors.fetaWhite, 
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Nice rounded corners!
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IngredientPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Start Cooking",
                      style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}