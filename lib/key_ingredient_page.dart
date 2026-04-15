import 'package:flutter/material.dart';
import 'package:food_app/spoonacular_service.dart';
import 'question_page.dart';
import 'package:google_fonts/google_fonts.dart';

class IngredientPage extends StatefulWidget {
  final String diet;
  const IngredientPage({super.key, required this.diet});


  @override
  State<IngredientPage> createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {

  final TextEditingController controller = TextEditingController();

  final SpoonacularService service = SpoonacularService();
  List<String> ingredients = [];
  bool isLoading = false;

  Future<void> fetchRecipes() async {
    if (ingredients.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final recipes = await service.searchByIngredients(ingredients);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return QuestionPage(recipes: recipes, service: service, initialIngredients: ingredients);
          }
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"))
      );
      // Handle error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Main Ingredient",
        style: GoogleFonts.nunito(
            fontSize: 30,
            color: Colors.deepPurpleAccent,
        ),),
      ),

      body: Column(
          children: [
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
                final results = await service.searchIngredients(textEditingValue.text);
                return results;
              },
              onSelected: (String selection) {
                if (ingredients.length >= 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content : Text("You can add up to 1 ingredient")),
                    );
                  return;
                }
                if (!ingredients.contains(selection)) {
                  setState(() {
                    ingredients.add(selection);
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(ingredients[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          ingredients.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: isLoading ? null : fetchRecipes,
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Icon(Icons.arrow_forward),
        ),
      );
  }
} 