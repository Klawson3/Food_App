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
          //// Background
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.backgroundGradient
            ),
          ),
          //// Content
          Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
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

                const SizedBox(height: 10), //Creates gaps between the widger items

                FadeIn(
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    "Find recipes for what you have",
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      color: AppColors.peppercorn,
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
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),//how much space between the text and the edges of the button
                      elevation: 3, //determines the strength of the buttons shadow
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