import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:ai_playground/util/sqlite_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../model/face_model.dart';

class FaceRecognitionModel extends ChangeNotifier {
  final String modelName = 'assets/mobilefacenet.tflite';
  Interpreter? _interpreter;
  double threshold = 0.9;
  List<FaceModel> knownFaces = [];
  SqliteHelper sqliteHelper = SqliteHelper();
  String? loadingMessage;
  String? personDetected;

  FaceRecognitionModel() {
    loadModel();
  }

  void setLoadingMessage(String? value) {
    loadingMessage = value;
    notifyListeners();
  }

  // Load the TensorFlow Lite model
  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(modelName);
    knownFaces = await sqliteHelper.readAll();
    List<int>? inputShape = _interpreter!.getInputTensor(0).shape;
    TensorType inputType = _interpreter!.getInputTensor(0).type;
    List<int>? outputShape = _interpreter!.getOutputTensor(0).shape;
    TensorType outputType = _interpreter!.getOutputTensor(0).type;
    notifyListeners();
    log("Model loaded successfully");
    log("Model Input Shape: $inputShape");
    log("Model Input Type: $inputType");
    log("Model Output Shape: $outputShape");
    log("Model Output Type: $outputType");
  }

  Future<void> saveImage(String name, ImageSource source) async {
    personDetected = null;
    setLoadingMessage("Saving image data to the database\nPlease wait...");
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(source: source);
    if (imageFile != null) {
      final Float32List processedImage = await preprocessImage(imageFile);
      final Float32List? outputVector = await runModel(processedImage);
      if (outputVector != null) {
        FaceModel faceModel = FaceModel(name: name, faceData: outputVector);
        await sqliteHelper.add(faceModel);
        knownFaces.add(faceModel);
      }
    }
    var list = await sqliteHelper.readAll();
    log(list.toString());
    setLoadingMessage(null);
  }

  Future<void> deleteAllData() async {
    setLoadingMessage("Deleting data...Please wait");
    personDetected = null;
    await sqliteHelper.clear();
    setLoadingMessage(null);
  }

  // Pick image from camera or gallery and process it
  Future<void> processImage(ImageSource source) async {
    personDetected = null;
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(source: source);
    if (imageFile != null) {
      final Float32List processedImage = await preprocessImage(imageFile);
      final Float32List? outputVector = await runModel(processedImage);
      if (outputVector != null) {
        personDetected = recognizeFace(outputVector, knownFaces, threshold);
        notifyListeners();
      }
    }
  }

  Future<Float32List> preprocessImage(XFile imageFile) async {
    final File file = File(imageFile.path);
    final Uint8List imageBytes = await file.readAsBytes();

    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) throw Exception("Failed to decode image.");

    img.Image resizedImage =
        img.copyResize(originalImage, width: 112, height: 112);

    Float32List inputImage = Float32List(112 * 112 * 3);
    int pixelIndex = 0;

    for (int y = 0; y < 112; y++) {
      for (int x = 0; x < 112; x++) {
        img.Pixel pixel = resizedImage.getPixel(x, y);
        inputImage[pixelIndex++] = pixel.r.toInt() / 255.0;
        inputImage[pixelIndex++] = pixel.g.toInt() / 255.0;
        inputImage[pixelIndex++] = pixel.b.toInt() / 255.0;
      }
    }

    return inputImage;
  }

  Float32List normalizeEmbedding(Float32List embedding) {
    double norm = math.sqrt(embedding.fold(0.0, (sum, val) => sum + val * val));
    return Float32List.fromList(embedding.map((val) => val / norm).toList());
  }

  Future<Float32List?> runModel(Float32List inputImage) async {
    try {
      _interpreter?.close();
      _interpreter = await Interpreter.fromAsset(modelName);

      if (_interpreter == null) {
        return null;
      }
      var input = inputImage.reshape([1, 112, 112, 3]);
      var output = List.filled(1 * 192, 0.0).reshape([1, 192]);
      _interpreter?.run(input, output);
      Float32List outputList =
          Float32List.fromList(output.expand<double>((e) => e).toList());
      Float32List normalizedOutput = normalizeEmbedding(outputList);
      return normalizedOutput;
    } catch (e, stackTrace) {
      log("Error running model: $e");
      log("Stack trace: $stackTrace");
    }
    return null;
  }

  double euclideanDistance(List<double> vector1, List<double> vector2) {
    double sum = 0.0;
    for (int i = 0; i < vector1.length; i++) {
      sum += (vector1[i] - vector2[i]) * (vector1[i] - vector2[i]);
    }
    return math.sqrt(sum);
  }

  String recognizeFace(List<double> newFaceVector, List<FaceModel> knownFaces,
      double threshold) {
    String recognizedLabel = "Unknown";
    double minDistance = double.infinity;

    for (FaceModel faceModel in knownFaces) {
      double distance = euclideanDistance(newFaceVector, faceModel.faceData!);
      if (distance < minDistance && distance < threshold) {
        minDistance = distance;
        recognizedLabel = faceModel.name!;
      }
    }
    return recognizedLabel;
  }
}
