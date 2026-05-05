import 'package:flutter/material.dart';
import 'start_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart'; 

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
      
      theme: ThemeData(//makes the non-worked on pages look pretty decent, is replaced with specific schemes on certain pages 
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
