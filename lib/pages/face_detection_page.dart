import 'package:ai_playground/util/colors.dart';
import 'package:ai_playground/view_model/face_detection_viewmodel.dart';
import 'package:ai_playground/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FaceDetectionPage extends StatefulWidget {
  const FaceDetectionPage({super.key});

  @override
  State<FaceDetectionPage> createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  late FaceDetectionModel viewModel;

  @override
  void initState() {
    viewModel = context.read<FaceDetectionModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPinkColor,
      appBar: AppBar(
        title: const Text(
          'Face Detection',
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
              Consumer<FaceDetectionModel>(
                builder: (context, viewModel, child) {
                  return viewModel.isLoading
                      ? const CircularProgressIndicator(color: darkPinkColor)
                      : viewModel.count == null
                          ? const Text(
                              "No image selected. Please select an image to detect people.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("People detected: ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400)),
                                Text(viewModel.count.toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                              ],
                            );
                },
              ),
              const SizedBox(height: 20),
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
