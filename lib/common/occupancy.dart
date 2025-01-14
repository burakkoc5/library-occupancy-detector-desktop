import 'package:lod_gui/common/camera.dart';
import 'package:flutter/foundation.dart';

class Occupancy {
  final List<Camera> cameras;

  Occupancy({required this.cameras});

  factory Occupancy.empty() {
    return Occupancy(cameras: []);
  }

  factory Occupancy.fromJson(Map<String, dynamic> json) {
    try {
      final camerasJson = json['cameras'] as List<dynamic>?;
      return Occupancy(
        cameras: camerasJson
                ?.map((camera) =>
                    Camera.fromJson(Map<String, dynamic>.from(camera)))
                .toList() ??
            [],
      );
    } catch (e) {
      debugPrint('Error parsing occupancy: $e');
      return Occupancy.empty();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'cameras': cameras.map((camera) => camera.toJson()).toList(),
    };
  }
}
