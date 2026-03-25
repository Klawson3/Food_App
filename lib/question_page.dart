import 'package:flutter/material.dart';
import 'result_page.dart';

class QuestionPage extends StatelessWidget {
  final String question;

  QuestionPage({required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Do you have this ingredient?'),
      ),
      body: Center(
        child: Text(question),
      ),
    );
  }
}