import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/library_provider.dart';
import '../features/occupancy/occupancy_page.dart';
import 'library.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  void initState() {
    super.initState();
    // Fetch libraries when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryProvider>().fetchLibraries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(
      builder: (context, libraryProvider, child) {
        if (libraryProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (libraryProvider.libraries.isEmpty) {
          return const Center(child: Text('No libraries available'));
        }

        return Column(
          children: [
            // Library selector
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<Library>(
                value: libraryProvider.selectedLibrary,
                items: libraryProvider.libraries.map((Library library) {
                  return DropdownMenuItem<Library>(
                    value: library,
                    child: Text(library.name),
                  );
                }).toList(),
                onChanged: (Library? newValue) {
                  if (newValue != null) {
                    libraryProvider.selectLibrary(newValue);
                  }
                },
              ),
            ),
            // Occupancy page
            const Expanded(
              child: OccupancyPage(),
            ),
          ],
        );
      },
    );
  }
}
