import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class EmotionDetectionModel extends ChangeNotifier {
  final String modelName = 'assets/emotion_detection.tflite';
  Interpreter? _interpreter;
  String? loadingMessage;
  String? detectedEmotion;
  final List<String> emotionLabels = [
    "Angry",
    "Fear",
    "Happy",
    "Neutral",
    "Sad",
    "Surprised",
  ];

  EmotionDetectionModel() {
    loadModel();
  }

  void setLoadingMessage(String? value) {
    loadingMessage = value;
    notifyListeners();
  }

  // Load the TensorFlow Lite model
  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(modelName);
    List<int>? inputShape = _interpreter!.getInputTensor(0).shape;
    TensorType inputType = _interpreter!.getInputTensor(0).type;
    List<int>? outputShape = _interpreter!.getOutputTensor(0).shape;
    TensorType outputType = _interpreter!.getOutputTensor(0).type;
    notifyListeners();
    log("Emotion Detection Model loaded successfully");
    log("Model Input Shape: $inputShape");
    log("Model Input Type: $inputType");
    log("Model Output Shape: $outputShape");
    log("Model Output Type: $outputType");
  }

  Future<Float32List> preprocessImage(XFile imageFile) async {
    final file = File(imageFile.path);
    final Uint8List imageBytes = await file.readAsBytes();

    // Decode and resize image to 224x224
    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) throw Exception("Failed to decode image.");

    img.Image resizedImage =
        img.copyResize(originalImage, width: 224, height: 224);

    // Normalize pixel values to [0, 1] and create Float32List
    Float32List inputImage = Float32List(224 * 224 * 3);
    int pixelIndex = 0;

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        img.Pixel pixel = resizedImage.getPixel(x, y);
        inputImage[pixelIndex++] = pixel.r.toDouble() / 255.0;
        inputImage[pixelIndex++] = pixel.g.toDouble() / 255.0;
        inputImage[pixelIndex++] = pixel.b.toDouble() / 255.0;
      }
    }

    return inputImage;
  }

  String getEmotionFromOutput(List<double> output) {
    int maxIndex = output.indexOf(output.reduce(math.max));
    return emotionLabels[maxIndex];
  }

  Future<void> processImage(ImageSource source) async {
    detectedEmotion = null;

    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(source: source);

    if (imageFile != null) {
      try {
        final Float32List processedImage = await preprocessImage(imageFile);
        final String? emotion = await runModel(processedImage);
        detectedEmotion = emotion;
        notifyListeners();
      } catch (e, stackTrace) {
        debugPrint("Error during image processing: $e");
        debugPrint("Stack trace: $stackTrace");
      }
    }
  }

  Future<String?> runModel(Float32List inputImage) async {
    try {
      if (_interpreter == null) {
        throw Exception("Interpreter is not loaded.");
      }

      // Reshape the input for the model
      var input = inputImage.reshape([1, 224, 224, 3]);

      // Allocate space for the output
      var output = List.filled(6, 0.0).reshape([1, 6]);

      // Run the model
      _interpreter!.run(input, output);

      // Flatten the output to a list of doubles
      List<double> outputList = List<double>.from(output[0]);

      // Get the emotion label
      return getEmotionFromOutput(outputList);
    } catch (e, stackTrace) {
      debugPrint("Error running model: $e");
      debugPrint("Stack trace: $stackTrace");
    }
    return null;
  }
}
