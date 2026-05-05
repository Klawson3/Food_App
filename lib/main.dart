import 'package:flutter/material.dart';
import 'start_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart'; 

//Run this page to make the App start
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodApp Demo',
      
      //This color scheme is the default but is explicitly overriden on certain pages
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.fetaWhite, 
        
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.crispLettuce,
          primary: AppColors.deepSpinach,
          secondary: AppColors.carrotOrange,
          surface: AppColors.fetaWhite,
        ),
        
        textTheme: GoogleFonts.nunitoTextTheme().apply(
          bodyColor: AppColors.peppercorn,
        ),
      ),
      
      home: const StartPage(),
    );
  }
}
