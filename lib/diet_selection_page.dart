import 'package:flutter/material.dart';
import 'key_ingredient_page.dart';

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
    "Gluten-Free"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Your Diet"),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: diets.length,
              itemBuilder: (context, index) {
                final diet = diets[index]; 
                return ListTile(
                  title: Text(diet),
                  leading: Radio<String>(
                    value: diet,
                    groupValue: selectedDiet,
                    onChanged: (value) {
                      setState(() {
                        selectedDiet = value;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(100),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedDiet == null
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IngredientPage(diet: selectedDiet!),
                      ),
                    );
                  },
                child: const Text("Continue"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}