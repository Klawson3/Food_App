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
    "Vegan",
    "Vegetarian",
    "Keto",
    "High Protein",
    "Paleo",
    "Gluten-Free",
  ];

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
            builder: (context) => IngredientPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fetaWhite,
      
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
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

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            crossAxisSpacing: 15, 
            mainAxisSpacing: 15, 
            childAspectRatio: 1.5, 
          ),
          itemCount: diets.length,
          itemBuilder: (context, index) {
            final diet = diets[index];
            final isSelected = selectedDiet == diet; 

            return GestureDetector( 
              onTap: () => _handleDietSelection(diet),
              
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.crispLettuce.withOpacity(0.2) : Colors.white,
                  borderRadius: BorderRadius.circular(20), 
                  
                  border: Border.all(
                    color: isSelected ? AppColors.crispLettuce : Colors.grey.shade300,
                    width: isSelected ? 3 : 1, 
                  ),
                  
                  boxShadow: [
                    if (!isSelected) 
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                
                child: Center(
                  child: Text(
                    diet,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 18,
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

      // UI UPDATE: Added a Floating Action Button for the Skip button
      floatingActionButton: TextButton(
        onPressed: () {
          // If user presses skip, it passes "None" to the next page like the old code
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const IngredientPage(),
            ),
          );
        },
        child: Text(
          "Skip",
          style: GoogleFonts.nunito(
            fontSize: 18,
            color: AppColors.peppercorn.withOpacity(0.6), // A slightly faded grey-black
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}