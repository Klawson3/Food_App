import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'key_ingredient_page.dart';
import 'diet_selection_page.dart';


class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD6F0), Color(0xFFD8B4FF),],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          //Overlay
          Container(
            color: Color.fromARGB(39, 234, 165, 220),
          ),

          //Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "FoodieAI",
                  style: GoogleFonts.nunito(
                    fontSize: 60,
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Cook with what you have",
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 50),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DietSelectionPage(),
                      ),
                    );
                  },
                  child: Text("Start Cooking",
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}