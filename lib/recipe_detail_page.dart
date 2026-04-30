import 'package:flutter/material.dart';
import "package:url_launcher/url_launcher.dart";
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
      appBar: AppBar(title: Text(recipe['title'])),
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
                  height: 220,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
      ],
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  TITLE
                  Text(
            recipe['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  //  TIME + SERVINGS
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.timer),
                              const SizedBox(height: 4),
                              Text("${details['readyInMinutes'] ?? 'N/A'} min"),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.restaurant),
                              const SizedBox(height: 4),
                              Text("Serves ${details['servings'] ?? 'N/A'}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height:20),
                  
                  if (sourceUrl != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => openRecipeLink(sourceUrl),
                        icon: const Icon(Icons.play_circle_fill),
                        label: const Text("Watch / Full Recipe Guide"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  //  INGREDIENTS
                  const Text(
                    "Ingredients",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ...ingredients.map<Widget>((ing) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.circle, size: 6),
                            const SizedBox(width: 8),
                            Expanded(child: Text(ing['original'])),
                          ],
                        ),
                      )),

                  const SizedBox(height: 20),

                  //  INSTRUCTIONS
                  const Text(
                  "Instructions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Text(
                  instructions,
                  style: const TextStyle(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }
}