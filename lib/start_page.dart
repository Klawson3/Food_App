import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'package:animate_do/animate_do.dart'; 

import 'key_ingredient_page.dart';

/// start_page is the entry screen of the application.
///
/// It serves as the initial page where the user begins interacting with the app.
/// The page displays a visually appealing background, the app title, and a
/// primary button that navigates the user to the key ingredient page.
///

/// Displays the UI elements and handles navigation throughout the app.
class StartPage extends StatelessWidget {
  const StartPage({super.key});


/// Builds the UI. Navigation is triggered when the user presses the start button. 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //// Background
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.backgroundGradient
            ),
          ),
          //// Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    "Cook4U",
                    style: GoogleFonts.nunito(
                      fontSize: 60,
                      color: AppColors.carrotOrange,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                // Creates gaps between the display features
                const SizedBox(height: 10),

                FadeIn(
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    "Find recipes for what you have",
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  duration: const Duration(milliseconds: 800),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.carrotOrange,
                      foregroundColor: AppColors.fetaWhite, 
                      // How much space between the text and the edges of the button
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      elevation: 3, // Determines the strength of the buttons shadow.
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Nice rounded corners!
                      ),
                    ),
                    child: Text(
                      "Start Cooking",
                      style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
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