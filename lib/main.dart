import 'package:flutter/material.dart';
import 'diet_selection_page.dart';
import 'start_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart'; // UI UPDATE: Imported central color hub

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodApp Demo',
      theme: ThemeData(
        // UI UPDATE: Applied Feta White as the default background for all screens
        scaffoldBackgroundColor: AppColors.fetaWhite, 
        
        // UI UPDATE: Mapped the "Salad" palette to the global Material ColorScheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.crispLettuce,
          primary: AppColors.deepSpinach,
          secondary: AppColors.carrotOrange,
          surface: AppColors.fetaWhite,
        ),
        
        // UI UPDATE: Tinted the existing Nunito font with Peppercorn black
        textTheme: GoogleFonts.nunitoTextTheme().apply(
          bodyColor: AppColors.peppercorn,
          displayColor: AppColors.deepSpinach,
        ),
      ),
      home: const StartPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // UI UPDATE: explicitly defined MainAxisAlignment
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      // UI UPDATE: The FloatingActionButton will now automatically use the theme's colors!
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}




// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: SpoonTestPage(),
//     );
//   }
// }

// class SpoonTestPage extends StatefulWidget {
//   const SpoonTestPage({super.key});

//   @override
//   State<SpoonTestPage> createState() => _SpoonTestPageState();
// }

// class _SpoonTestPageState extends State<SpoonTestPage> {
//   final SpoonacularService _service = SpoonacularService();
//   List<dynamic> recipes = [];
//   bool isLoading = false;

//   void fetchRecipes() async {
//     setState(() {
//       isLoading = true;
//     });

//     final results = await _service
//         .searchByIngredients(['beef',"onion","garlic", "tomato", "salt", "pepper"]);

//     setState(() {
//       recipes = results;
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchRecipes();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Spoonacular Test')),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: recipes.length,
//               itemBuilder: (context, index) {
//                 final recipe = recipes[index];
//                 return ListTile(
//                   title: Text(recipe['title']),
//                   subtitle: Text(
//                       'Used: ${recipe['usedIngredientCount']} | Missing: ${recipe['missedIngredientCount']}'),
//                   leading: Image.network(recipe['image']),
//                 );
//               },
//             ),
//     );
//   }
// }