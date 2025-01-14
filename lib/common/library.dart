import 'package:lod_gui/common/occupancy.dart';
import 'package:lod_gui/common/chair.dart';
import 'package:flutter/foundation.dart';

class Library {
  final String id;
  final String name;
  final Occupancy occupancy;

  Library({
    required this.id,
    required this.name,
    required this.occupancy,
  });

  factory Library.fromJson(Map<String, dynamic> json) {
    try {
      return Library(
        id: json['id']?.toString() ?? json['name']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        occupancy: json['occupancy'] != null
            ? Occupancy.fromJson(Map<String, dynamic>.from(json['occupancy']))
            : Occupancy.empty(),
      );
    } catch (e) {
      debugPrint('Error parsing library: $e');
      return Library(
        id: '',
        name: '',
        occupancy: Occupancy.empty(),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'occupancy': occupancy.toJson(),
    };
  }

  // Toplam sandalye sayısını döndürür
  int get totalChairs {
    return occupancy.cameras
        .map((camera) => camera.chairs.length)
        .reduce((value, element) => value + element);
  }

  // Boş sandalye sayısını döndürür
  int get emptyChairs {
    return occupancy.cameras
        .map((camera) => camera.chairs.where((chair) => chair.isEmpty).length)
        .reduce((value, element) => value + element);
  }

  // Rezerve edilmiş sandalye sayısını döndürür
  int get holdChairs {
    return occupancy.cameras
        .map(
            (camera) => camera.chairs.where((chair) => chair.isReserved).length)
        .reduce((value, element) => value + element);
  }

  // Dolu sandalye sayısını döndürür
  int get occupiedChairs {
    return occupancy.cameras
        .map(
            (camera) => camera.chairs.where((chair) => chair.isOccupied).length)
        .reduce((value, element) => value + element);
  }

  // Tüm sandalyeleri döndürür
  List<Chair> get seats {
    return occupancy.cameras.expand((camera) => camera.chairs).toList();
  }

  // Override equality operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Library && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
