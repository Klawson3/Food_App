import 'package:flutter/material.dart';
import 'package:food_app/spoonacular_service.dart';
import 'result_page.dart';

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
          builder: (context) => ResultPage(recipes: recipes, service: service),
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
        title: const Text("Enter Main Ingredients"),
      ),

      body: Column(
          children: [
            TextField(
              controller: controller,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;
                setState(() {
                  ingredients.add(controller.text);
                  controller.clear();
                });
              },
              child: const Text("Add Ingredient"),
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