import 'package:ai_playground/widget/home_button.dart';
import 'package:flutter/material.dart';

import '../util/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPinkColor,
      appBar: AppBar(
        title: const Text(
          'AI Playground',
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        foregroundColor: white,
        backgroundColor: darkPinkColor,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HomeButton(text: "Face detection - Count people"),
              SizedBox(height: 10),
              HomeButton(text: "Face recognition"),
              SizedBox(height: 10),
              HomeButton(text: "Emotion detection"),
            ],
          ),
        ),
      ),
    );
  }
}
