import 'package:flutter/foundation.dart';
import 'package:lod_gui/common/chair.dart';

class Camera {
  final String id;
  final List<Chair> chairs;

  Camera({required this.id, required this.chairs});

  factory Camera.empty() {
    return Camera(id: '', chairs: []);
  }

  factory Camera.fromJson(Map<String, dynamic> json) {
    try {
      final chairsJson = json['chairs'] as List<dynamic>?;
      return Camera(
        id: json['id']?.toString() ?? '',
        chairs: chairsJson
                ?.map(
                    (chair) => Chair.fromJson(Map<String, dynamic>.from(chair)))
                .toList() ??
            [],
      );
    } catch (e) {
      debugPrint('Error parsing camera: $e');
      return Camera.empty();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chairs': chairs.map((chair) => chair.toJson()).toList(),
    };
  }
}
