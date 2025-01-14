import 'package:flutter/material.dart';

class OccupancyStats {
  final DateTime date;
  final int occupiedSeats;
  final int totalSeats;

  OccupancyStats({
    required this.date,
    required this.occupiedSeats,
    required this.totalSeats,
  });

  double get occupancyRate => occupiedSeats / totalSeats;
}

class HourlyStats {
  final int hour;
  final int averageOccupancy;
  final int totalSeats;

  HourlyStats({
    required this.hour,
    required this.averageOccupancy,
    required this.totalSeats,
  });

  double get occupancyRate => averageOccupancy / totalSeats;
}

class ReportsProvider with ChangeNotifier {
  // Mock data for the last 30 days
  List<OccupancyStats> getDailyStats() {
    final now = DateTime.now();
    final List<OccupancyStats> stats = [];

    for (int i = 30; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      // Generate mock data with some variation
      final occupiedSeats = 30 + (date.weekday * 5) + (date.hour ~/ 2);
      stats.add(OccupancyStats(
        date: date,
        occupiedSeats: occupiedSeats,
        totalSeats: 100,
      ));
    }
    return stats;
  }

  // Mock data for hourly statistics
  List<HourlyStats> getHourlyStats() {
    final List<HourlyStats> stats = [];

    // Library operating hours (8 AM to 10 PM)
    for (int hour = 8; hour <= 22; hour++) {
      // Generate mock data with peak hours
      int averageOccupancy;
      if (hour >= 10 && hour <= 16) {
        // Peak hours
        averageOccupancy = 70 + (hour % 3 * 10);
      } else {
        // Off-peak hours
        averageOccupancy = 30 + (hour % 3 * 10);
      }

      stats.add(HourlyStats(
        hour: hour,
        averageOccupancy: averageOccupancy,
        totalSeats: 100,
      ));
    }
    return stats;
  }

  // Get peak hours (hours with highest average occupancy)
  List<int> getPeakHours() {
    final hourlyStats = getHourlyStats();
    hourlyStats.sort((a, b) => b.occupancyRate.compareTo(a.occupancyRate));
    return hourlyStats.take(3).map((stat) => stat.hour).toList();
  }

  // Get average daily occupancy rate
  double getAverageOccupancyRate() {
    final dailyStats = getDailyStats();
    return dailyStats
            .map((stat) => stat.occupancyRate)
            .reduce((a, b) => a + b) /
        dailyStats.length;
  }
}
