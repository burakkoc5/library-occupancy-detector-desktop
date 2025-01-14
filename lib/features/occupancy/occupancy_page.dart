import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/library.dart';
import '../../core/providers/library_provider.dart';

class OccupancyPage extends StatelessWidget {
  const OccupancyPage({super.key});

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

        final selectedLibrary =
            libraryProvider.selectedLibrary ?? libraries.first;

        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120,
                  child: LibraryListView(
                    libraries: libraries,
                    selectedLibrary: selectedLibrary,
                    onLibrarySelected: libraryProvider.selectLibrary,
                  ),
                ),
                const SizedBox(height: 32),
                LibraryDetailsView(
                  library: selectedLibrary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LibraryListView extends StatelessWidget {
  final List<Library> libraries;
  final Library selectedLibrary;
  final Function(Library) onLibrarySelected;

  const LibraryListView({
    super.key,
    required this.libraries,
    required this.selectedLibrary,
    required this.onLibrarySelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth < 600 ? 200.0 : 300.0;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: libraries.length,
          itemBuilder: (context, index) {
            final library = libraries[index];
            return SizedBox(
              width: cardWidth,
              child: LibraryCard(
                library: library,
                isSelected: library.id == selectedLibrary.id,
                onTap: () => onLibrarySelected(library),
              ),
            );
          },
        );
      },
    );
  }
}

class LibraryCard extends StatelessWidget {
  final Library library;
  final bool isSelected;
  final VoidCallback onTap;

  const LibraryCard({
    super.key,
    required this.library,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final occupancyRate = library.occupiedChairs / library.totalChairs;

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.white,
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300]!,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                library.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${library.occupiedChairs}/${library.totalChairs}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  StatusBadgeMini(occupancyRate: occupancyRate),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusBadgeMini extends StatelessWidget {
  final double occupancyRate;

  const StatusBadgeMini({
    super.key,
    required this.occupancyRate,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    if (occupancyRate > 0.8) {
      color = Colors.red;
      icon = Icons.warning_rounded;
    } else if (occupancyRate > 0.5) {
      color = Colors.orange;
      icon = Icons.info_rounded;
    } else {
      color = Colors.green;
      icon = Icons.check_circle_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}

class LibraryDetailsView extends StatelessWidget {
  final Library library;
  static const occupiedColor = Colors.red;
  static const reservedColor = Colors.amber;
  static const availableColor = Colors.green;

  const LibraryDetailsView({
    super.key,
    required this.library,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  library.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Capacity: ${library.totalChairs}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getStatusColor(
                        library.occupiedChairs / library.totalChairs)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(
                        library.occupiedChairs / library.totalChairs),
                    color: _getStatusColor(
                        library.occupiedChairs / library.totalChairs),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(library.occupiedChairs / library.totalChairs * 100).round()}% Occupied',
                    style: TextStyle(
                      color: _getStatusColor(
                          library.occupiedChairs / library.totalChairs),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatusCard(
              'Available',
              library.emptyChairs,
              availableColor,
              Icons.check_circle_rounded,
            ),
            const SizedBox(width: 16),
            _buildStatusCard(
              'Reserved',
              library.holdChairs,
              reservedColor,
              Icons.access_time_rounded,
            ),
            const SizedBox(width: 16),
            _buildStatusCard(
              'Occupied',
              library.occupiedChairs,
              occupiedColor,
              Icons.person_rounded,
            ),
          ],
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: library.emptyChairs.toDouble(),
                  color: availableColor,
                  title: '${library.emptyChairs}',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: library.holdChairs.toDouble(),
                  color: reservedColor,
                  title: '${library.holdChairs}',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: library.occupiedChairs.toDouble(),
                  color: occupiedColor,
                  title: '${library.occupiedChairs}',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
              sectionsSpace: 0,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(
    String title,
    int count,
    Color color,
    IconData icon,
  ) {
    return SizedBox(
      width: 200,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(double occupancyRate) {
    if (occupancyRate > 0.8) {
      return occupiedColor;
    } else if (occupancyRate > 0.5) {
      return reservedColor;
    } else {
      return availableColor;
    }
  }

  IconData _getStatusIcon(double occupancyRate) {
    if (occupancyRate > 0.8) {
      return Icons.warning_rounded;
    } else if (occupancyRate > 0.5) {
      return Icons.info_rounded;
    } else {
      return Icons.check_circle_rounded;
    }
  }
}
