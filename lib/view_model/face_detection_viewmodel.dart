import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetectionModel extends ChangeNotifier {
  int? count;
  bool isLoading = false;
  final FaceDetector faceDetector =
      FaceDetector(options: FaceDetectorOptions(enableTracking: true));

  Future<void> processImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: source);
    setLoading(true);
    await detectFaces(photo);
    setLoading(false);
  }

  Future<void> detectFaces(XFile? imageFile) async {
    if (imageFile == null) return;
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final List<Face> faces = await faceDetector.processImage(inputImage);
    count = faces.length;
    notifyListeners();
    // Handle the detected faces
    // for (Face face in faces) {
    //   // Get the bounding box of the face
    //   final Rect boundingBox = face.boundingBox;

    //   // You can also get other properties of the face, such as landmarks
    //   // Example: final FaceLandmark leftEye = face.landmarks[FaceLandmarkType.leftEye];
    // }
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
