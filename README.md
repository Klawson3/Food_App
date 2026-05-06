# food_app

A new Flutter project.

Overview

Our Cook4U food app is a Flutter based mobile application that helps users generate recipes based on ingredients they already have. This app is particularly targeted towards college students who may be restricted by fiscal means and don't have a lot of time to prepare extravagant dishes. By leveraging the Spoonacular API, the app identifies the best possible recipe match and provides alternative options, detailed ingredients, and step-by-step cooking instructions. The goal of this project is to simplify meal planning, reduce food waste, and create an intuitive user experience for discovering recipes. 

Features

Ingredient-Based Search: user inputs ingredient they currently have.

Best Match Algorithm: recipes are ranked using a scoring system based on ingredient match and complexity.

Interactive Questions Page: further matches the ingredients of the user to a recipe.

Match Scoring System: each recipe is assigned a score to indicate how well it matches the user's ingredients.

Detailed Recipe View: ingredients, cooking time, servings, and instructions.

Alternative Recipes: additional recipe options for user to explore.



Technology Used:
Flutter(Dart)
Spoonacular API


How It Works:

1. User enters available ingredient
2. Questions Page gathers more information
3. App sends request to Spoonacular API
4. Best Recipe is returned and processed
5. User can see additional recipes with a match score calculated for each recipe
6. Recipes are sorted based on score
7. User can view detailed instructions and explore more recipe options


App Flow:

Start Page --> Ingredient Input --> Best Recipe --> 
--> Cook (button) --> Recipe Detail Page
--> See More --> All Recipes Page


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
