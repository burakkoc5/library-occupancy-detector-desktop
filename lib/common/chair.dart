import 'package:flutter/foundation.dart';

class Chair {
  final String id;
  final bool isEmpty;
  final bool isOccupied;
  final bool isReserved;

  Chair({
    required this.id,
    required this.isEmpty,
    required this.isOccupied,
    required this.isReserved,
  });

  factory Chair.empty() {
    return Chair(
      id: '',
      isEmpty: true,
      isOccupied: false,
      isReserved: false,
    );
  }

  String get status {
    if (isReserved) return 'hold';
    if (isOccupied) return 'occupied';
    return 'empty';
  }

  factory Chair.fromJson(Map<String, dynamic> json) {
    try {
      return Chair(
        id: json['id']?.toString() ?? '',
        isEmpty: json['isEmpty'] as bool? ?? true,
        isOccupied: json['isOccupied'] as bool? ?? false,
        isReserved: json['isReserved'] as bool? ?? false,
      );
    } catch (e) {
      debugPrint('Error parsing chair: $e');
      return Chair.empty();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isEmpty': isEmpty,
      'isOccupied': isOccupied,
      'isReserved': isReserved,
    };
  }
}
