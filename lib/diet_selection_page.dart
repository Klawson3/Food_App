import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'key_ingredient_page.dart';
// UI UPDATE: Imported our color palette
import 'app_colors.dart';

class DietSelectionPage extends StatefulWidget {
  const DietSelectionPage({super.key});

  @override
  State<DietSelectionPage> createState() => _DietSelectionPageState();
}

class _DietSelectionPageState extends State<DietSelectionPage> {
  String? selectedDiet;

  final List<String> diets = [
    "None",
    "Vegan",
    "Vegetarian",
    "Keto",
    "High Protein",
    "Paleo",
    "Gluten-Free",
  ];

  // UI UPDATE: Created a new helper method to handle the "smart delay" auto-navigation
  void _handleDietSelection(String diet) {
    setState(() {
      // Instantly update the state so the UI turns green
      selectedDiet = diet;
    });

    // Wait for half a second
    Future.delayed(const Duration(milliseconds: 500), () {
      // check that the widget is still on screen before navigating
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            // Logic preservation: Pushing to the next screen exactly as the old button did
            builder: (context) => IngredientPage(diet: selectedDiet!),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // UI UPDATE: Keeping the background consistent with the Start Page
      backgroundColor: AppColors.fetaWhite,
      
      appBar: AppBar(
        // UI UPDATE: A transparent app bar looks much more modern for setup screens
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        // UI UPDATE: Ensured the default back arrow matches our theme
        iconTheme: const IconThemeData(color: AppColors.deepSpinach), 
        title: Text(
          "Select Your Diet",
          style: GoogleFonts.nunito(
            fontSize: 26,
            color: AppColors.deepSpinach,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),

      // UI UPDATE: Removed the Column and ListView, replaced with a GridView wrapped in Padding
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          // UI UPDATE: gridDelegate tells Flutter how to space out our cards
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two cards per row
            crossAxisSpacing: 15, // Horizontal space between cards
            mainAxisSpacing: 15, // Vertical space between cards
            childAspectRatio: 1.5, // Makes the cards rectangular instead of perfect squares
          ),
          itemCount: diets.length,
          itemBuilder: (context, index) {
            final diet = diets[index];
            final isSelected = selectedDiet == diet; //This checks if the selected diet is the cards diet

            // UI UPDATE: GestureDetector listens for taps on our custom cards
            return GestureDetector( //return makes the itemBuilder give the product back to the GridView
              onTap: () => _handleDietSelection(diet),
              
              // UI UPDATE: AnimatedContainer automatically smoothly fades colors when the state changes
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  // Background color turns to a very light, transparent green when selected
                  color: isSelected ? AppColors.crispLettuce.withOpacity(0.2) : Colors.white,
                  borderRadius: BorderRadius.circular(20), //nice round corners
                  
                  border: Border.all(
                    // Border lights up vibrant green when selected
                    color: isSelected ? AppColors.crispLettuce : Colors.grey.shade300,
                    width: isSelected ? 3 : 1, // Border gets thicker when selected
                  ),
                  
                  boxShadow: [
                    if (!isSelected) // Only show a shadow when UNSELECTED so it looks like it "presses in" when tapped
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                
                // UI UPDATE: The text stays centered in the middle of card
                child: Center(
                  child: Text(
                    diet,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      // Text color shifts to spinach green when selected to maximize contrast
                      color: isSelected ? AppColors.deepSpinach : AppColors.peppercorn,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        
      ),
    );
  }
}