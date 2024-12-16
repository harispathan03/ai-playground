import 'package:ai_playground/widget/home_button.dart';
import 'package:flutter/material.dart';

import '../util/colors.dart';
import 'emotion_detection_page.dart';
import 'face_detection_page.dart';
import 'face_recognition_page.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FaceDetectionPage())),
                  child:
                      const HomeButton(text: "Face detection - Count people")),
              const SizedBox(height: 10),
              InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FaceRecognitionPage())),
                  child: const HomeButton(text: "Face recognition")),
              const SizedBox(height: 10),
              InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EmotionDetectionPage())),
                  child: const HomeButton(text: "Emotion detection")),
            ],
          ),
        ),
      ),
    );
  }
}
