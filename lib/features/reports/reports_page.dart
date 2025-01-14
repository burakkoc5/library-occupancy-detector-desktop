import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/library_provider.dart';
import '../../common/library.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(
      builder: (context, libraryProvider, _) {
        if (libraryProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final libraries = libraryProvider.libraries;
        if (libraries.isEmpty) {
          return const Center(child: Text('No libraries found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Library System Overview',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              _buildSummaryCards(libraries),
              const SizedBox(height: 32),
              _buildOccupancyByLibrary(libraries),
              const SizedBox(height: 32),
              _buildCapacityDistribution(libraries),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCards(List<Library> libraries) {
    final totalOccupied =
        libraries.fold<int>(0, (sum, lib) => sum + lib.occupiedChairs);
    final totalReserved =
        libraries.fold<int>(0, (sum, lib) => sum + lib.holdChairs);
    final totalAvailable =
        libraries.fold<int>(0, (sum, lib) => sum + lib.emptyChairs);

    // Calculate percentages of current usage, not total capacity
    final totalInUse = totalOccupied + totalReserved + totalAvailable;
    final occupiedPercentage = (totalOccupied / totalInUse * 100).round();
    final reservedPercentage = (totalReserved / totalInUse * 100).round();
    final availablePercentage = (totalAvailable / totalInUse * 100).round();

    return Row(
      children: [
        _buildSummaryCard(
          'Total Occupancy',
          '$totalOccupied / $totalInUse',
          '$occupiedPercentage%',
          Colors.red,
          Icons.people,
        ),
        const SizedBox(width: 16),
        _buildSummaryCard(
          'Reserved Seats',
          '$totalReserved seats',
          '$reservedPercentage%',
          Colors.amber,
          Icons.access_time,
        ),
        const SizedBox(width: 16),
        _buildSummaryCard(
          'Available Seats',
          '$totalAvailable seats',
          '$availablePercentage%',
          Colors.green,
          Icons.check_circle,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, String percentage,
      Color color, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                percentage,
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOccupancyByLibrary(List<Library> libraries) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Occupancy by Library',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barGroups: libraries.asMap().entries.map((entry) {
                    final library = entry.value;
                    final occupancyRate =
                        (library.occupiedChairs / library.totalChairs) * 100;
                    final reservedRate =
                        (library.holdChairs / library.totalChairs) * 100;

                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: occupancyRate,
                          color: Colors.red,
                          width: 16,
                        ),
                        BarChartRodData(
                          toY: reservedRate,
                          color: Colors.amber,
                          width: 16,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              libraries[value.toInt()].name,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Occupied', Colors.red),
                const SizedBox(width: 24),
                _buildLegendItem('Reserved', Colors.amber),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapacityDistribution(List<Library> libraries) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Capacity Distribution',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,
                  sections: libraries.map((library) {
                    return PieChartSectionData(
                      value: library.totalChairs.toDouble(),
                      title:
                          '${((library.totalChairs / libraries.fold<int>(0, (sum, lib) => sum + lib.totalChairs)) * 100).round()}%',
                      color: Colors.primaries[
                          libraries.indexOf(library) % Colors.primaries.length],
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: libraries.map((library) {
                return _buildLegendItem(
                  library.name,
                  Colors.primaries[
                      libraries.indexOf(library) % Colors.primaries.length],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
