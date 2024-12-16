// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FaceModel {
  final String? name;
  final List<double>? faceData;

  FaceModel({this.name, this.faceData});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'faceData': faceData != null ? json.encode(faceData) : null
    };
  }

  factory FaceModel.fromMap(Map<String, dynamic> map) {
    return FaceModel(
        name: map['name'] != null ? map['name'] as String : null,
        faceData: map['faceData'] != null
            ? List<double>.from(json.decode(map['faceData'])
                as List<dynamic>) // Convert JSON string back to List<double>
            : null);
  }

  String toJson() => json.encode(toMap());

  factory FaceModel.fromJson(String source) =>
      FaceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  FaceModel copyWith({
    String? name,
    List<double>? faceData,
  }) {
    return FaceModel(
        name: name ?? this.name, faceData: faceData ?? this.faceData);
  }

  @override
  String toString() => 'FaceModel(name: $name, faceData: $faceData)';
}
