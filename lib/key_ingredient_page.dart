import 'package:flutter/material.dart';

class IngredientPage extends StatefulWidget {
  const IngredientPage({super.key});

  @override
  State<IngredientPage> createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {

  final TextEditingController controller = TextEditingController();

  List<String> ingredients = [];
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
                  );
                },
              ),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint("Ingredients: $ingredients");
          },
          child: const Icon(Icons.arrow_forward),
        ),
      );
  }
} 