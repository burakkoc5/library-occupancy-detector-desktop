import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/library_provider.dart';
import '../../features/authentication/domain/user.dart';

class LibraryAssignmentPage extends StatefulWidget {
  final User? targetUser;
  const LibraryAssignmentPage({super.key, this.targetUser});

  @override
  State<LibraryAssignmentPage> createState() => _LibraryAssignmentPageState();
}

class _LibraryAssignmentPageState extends State<LibraryAssignmentPage> {
  Set<String> selectedLibraries = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userToManage =
          widget.targetUser ?? context.read<AuthProvider>().currentUser;
      if (userToManage != null) {
        setState(() {
          selectedLibraries = Set.from(userToManage.managedLibraries);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userToManage =
        widget.targetUser ?? context.read<AuthProvider>().currentUser;
    if (userToManage == null) {
      return const Scaffold(
        body: Center(child: Text('No user selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.targetUser != null
            ? 'Assign Libraries to ${userToManage.email}'
            : 'Manage My Libraries'),
        actions: [
          TextButton(
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              await authProvider.updateManagedLibraries(
                userToManage.email,
                selectedLibraries.toList(),
              );
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
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
              final isSelected = selectedLibraries.contains(library.id);

              return Card(
                child: CheckboxListTile(
                  title: Text(library.name),
                  subtitle:
                      Text('Total Capacity: ${library.totalChairs} seats'),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedLibraries.add(library.id);
                      } else {
                        selectedLibraries.remove(library.id);
                      }
                    });
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
