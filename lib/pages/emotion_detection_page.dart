import 'package:ai_playground/view_model/emotion_detection_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../util/colors.dart';
import '../widget/custom_button.dart';

class EmotionDetectionPage extends StatefulWidget {
  const EmotionDetectionPage({super.key});

  @override
  State<EmotionDetectionPage> createState() => _EmotionDetectionPageState();
}

class _EmotionDetectionPageState extends State<EmotionDetectionPage> {
  late EmotionDetectionModel viewModel;

  @override
  void initState() {
    viewModel = context.read<EmotionDetectionModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPinkColor,
      appBar: AppBar(
        title: const Text(
          'Emotion Detection',
          style: TextStyle(color: white),
        ),
        foregroundColor: white,
        backgroundColor: darkPinkColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<EmotionDetectionModel>(
                  builder: (context, viewModel, child) {
                if (viewModel.detectedEmotion != null) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Detected Emotion: ",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          viewModel.detectedEmotion!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }
                if (viewModel.loadingMessage != null) {
                  return Column(
                    children: [
                      Text(
                        viewModel.loadingMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const CircularProgressIndicator(color: darkPinkColor),
                      const SizedBox(height: 20),
                    ],
                  );
                }
                return Container();
              }),
              const SizedBox(height: 10),
              InkWell(
                  onTap: () => viewModel.processImage(ImageSource.camera),
                  child: const CustomButton(text: "Capture from Camera")),
              const SizedBox(height: 10),
              InkWell(
                  onTap: () => viewModel.processImage(ImageSource.gallery),
                  child: const CustomButton(text: 'Select from Gallery')),
            ],
          ),
        ),
      ),
    );
  }
}
