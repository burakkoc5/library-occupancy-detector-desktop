import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/library_provider.dart';

class ManagedLibrariesPage extends StatelessWidget {
  const ManagedLibrariesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Managed Libraries'),
      ),
      body: Consumer<LibraryProvider>(
        builder: (context, libraryProvider, _) {
          final libraries = libraryProvider.libraries;

          if (libraries.isEmpty) {
            return const Center(child: Text('No libraries found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: libraries.length,
            itemBuilder: (context, index) {
              final library = libraries[index];
              final occupancyRate =
                  (library.occupiedChairs / library.totalChairs * 100).round();

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(library.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('Total Capacity: ${library.totalChairs} seats'),
                      Text('Current Occupancy: $occupancyRate%'),
                    ],
                  ),
                  trailing: Icon(
                    Icons.circle,
                    color: occupancyRate > 80
                        ? Colors.red
                        : occupancyRate > 50
                            ? Colors.orange
                            : Colors.green,
                  ),
                  onTap: () {
                    libraryProvider.selectLibrary(library);
                    // Navigate to library details or management page
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
