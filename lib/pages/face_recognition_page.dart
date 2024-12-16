import 'package:ai_playground/view_model/face_recognition_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../util/colors.dart';
import '../widget/custom_button.dart';

class FaceRecognitionPage extends StatefulWidget {
  const FaceRecognitionPage({super.key});

  @override
  State<FaceRecognitionPage> createState() => _FaceRecognitionPageState();
}

class _FaceRecognitionPageState extends State<FaceRecognitionPage> {
  late FaceRecognitionModel viewModel;
  late TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    viewModel = context.read<FaceRecognitionModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPinkColor,
      appBar: AppBar(
        title: const Text(
          'Face Recognition',
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
              Consumer<FaceRecognitionModel>(
                  builder: (context, viewModel, child) {
                if (viewModel.personDetected != null) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Detected Person: ",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          viewModel.personDetected!,
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
              InkWell(
                  onTap: () async {
                    String? name = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Save image in the model'),
                            content: TextField(
                              controller: nameController,
                              autofocus: true,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                  hintText: "Enter name here"),
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text('Save'),
                                onPressed: () {
                                  Navigator.pop(context, nameController.text);
                                  nameController.clear();
                                },
                              ),
                            ],
                          );
                        });
                    if (name != null) {
                      viewModel.saveImage(name, ImageSource.gallery);
                    }
                  },
                  child: const CustomButton(text: "Save Image from gallery")),
              const SizedBox(height: 10),
              InkWell(
                  onTap: () => viewModel.processImage(ImageSource.camera),
                  child: const CustomButton(text: "Capture from Camera")),
              const SizedBox(height: 10),
              InkWell(
                  onTap: () => viewModel.processImage(ImageSource.gallery),
                  child: const CustomButton(text: 'Select from Gallery')),
              const SizedBox(height: 10),
              InkWell(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete Data'),
                            content: const Text(
                                "Are you sure you want to delete all store images data?"),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () {
                                  viewModel.deleteAllData();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: const CustomButton(text: 'Clear stored images data')),
            ],
          ),
        ),
      ),
    );
  }
}
