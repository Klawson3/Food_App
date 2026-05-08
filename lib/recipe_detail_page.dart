import 'package:flutter/material.dart';
import "package:url_launcher/url_launcher.dart";
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// RecipeDetailPage displays the instructions of a particular recipe and the 
/// ingredient list specific to that recipe.
class RecipeDetailPage extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final Map<String, dynamic> details;

  const RecipeDetailPage({
    super.key,
    required this.recipe,
    required this.details,
  });

  Future<void> openRecipeLink(String url) async {
    final Uri uri = Uri.parse(url);

    if(await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode:LaunchMode.externalApplication,
      );
    }
  }

  @override
  /// Builds a recipe detail page with ingredients and instructions.
  ///
  /// The page shows the title of the recipe in the app bar, and a list of
  /// ingredients and instructions in the body. If there are no instructions
  /// available, it will show a message saying "No instructions available".
  Widget build(BuildContext context) {
    final ingredients = details['extendedIngredients'] ?? [];
    final instructions = details['instructions']?.toString().replaceAll(RegExp(r'<[^>]*>'), '') 
        ?? "No instructions available";
    final sourceUrl = details['sourceUrl'];
    
    return Scaffold(
      backgroundColor: AppColors.fetaWhite,
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.deepSpinach),
        toolbarHeight: 60, 
        title: Text(
          recipe['title'],
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.ellipsis,

          style: GoogleFonts.nunito(
            fontSize: 22,
            color: AppColors.deepSpinach,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        )
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  IMAGE HEADER
            if (recipe['image'] != null)
              Stack(
                children: [
                  Image.network(
                    recipe['image'],
                    width: double.infinity,
                    height: 250, 
                    fit: BoxFit.cover,
                  ),
                ],
              ),

            Padding(
              padding: const EdgeInsets.all(10), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  //  TITLE
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      recipe['title'],
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: GoogleFonts.nunito(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.deepSpinach,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  //  TIME + SERVINGS
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 30,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.crispLettuce.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, 
                          children: [
                            Column(
                              children: [
                                const Icon(Icons.timer_outlined, size: 50, color: AppColors.deepSpinach),
                                const SizedBox(height: 4),
                                Text("${details['readyInMinutes'] ?? 'N/A'} min",
                                  style: GoogleFonts.nunito(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.deepSpinach,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 50), // Spacing between the two columns
                            Column(
                              children: [
                                const Icon(Icons.restaurant_outlined, size: 50, color: AppColors.deepSpinach),
                                const SizedBox(height: 4),
                                Text("Serves ${details['servings'] ?? 'N/A'}",
                                  style: GoogleFonts.nunito(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.deepSpinach,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ),
                  ),
                  
                  const SizedBox(height:25),
                  
                  if (sourceUrl != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => openRecipeLink(sourceUrl),
                        icon: const Icon(Icons.play_circle_fill, size: 30),
                        label: Text("Watch / Full Recipe Guide",
                          style: GoogleFonts.nunito(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.carrotOrange,
                          foregroundColor: AppColors.fetaWhite,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 20),

                  //  INGREDIENTS
                  Text(
                    "Ingredients",
                    style: GoogleFonts.nunito(
                      fontSize: 24, 
                      fontWeight: FontWeight.w800,
                      color: AppColors.deepSpinach,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ...ingredients.map<Widget>((ing) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                // Automatically capitalizes the first letter of the ingredient
                                ing['original'][0].toUpperCase() + ing['original'].substring(1),
                                style: GoogleFonts.nunito(
                                  fontSize: 18,
                                  color: AppColors.peppercorn,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: 15),

                  //  INSTRUCTIONS
                  Text("Instructions",
                    style: GoogleFonts.nunito(
                      fontSize: 24, 
                      fontWeight: FontWeight.w800,
                      color: AppColors.deepSpinach,
                    ),
                  ),

                const SizedBox(height: 15),

                Text(instructions,
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    color: AppColors.peppercorn,
                    height: 1.6, 
                  ),
                ),
                
                const SizedBox(height: 40), // Bottom padding
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }
}