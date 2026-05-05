import 'package:flutter/material.dart';

// AppColors allows other pages to directly access UI elements (colors/gradients)
// that can be easily called
class AppColors {
  static const Color deepSpinach = Color.fromRGBO(46, 92, 49, 1);
  static const Color crispLettuce = Color.fromARGB(255, 155, 224, 81);
  static const Color carrotOrange = Color.fromRGBO(255, 152, 0, 1);
  static const Color fetaWhite = Color.fromRGBO(249, 251, 231, 1);
  static const Color peppercorn = Color.fromRGBO(30, 33, 29, 1);
  // Because withValues is calculated each time it is called, 
  // backgroundGradient has to be stored as a function, not a variable
  static LinearGradient get backgroundGradient {
    return LinearGradient(
      colors: [
        fetaWhite, 
        crispLettuce.withValues(alpha: 0.3), 
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}