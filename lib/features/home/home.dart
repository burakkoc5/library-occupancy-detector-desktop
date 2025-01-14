import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/library_provider.dart';
import '../notifications/notifications_page.dart';
import '../occupancy/occupancy_page.dart';
import '../reports/reports_page.dart';
import '../settings/settings_page.dart';
import '../profile/profile_page.dart';

class Home extends StatefulWidget {
  final String title;
  const Home({super.key, required this.title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool _isPinned = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryProvider>().initialize(context);
    });
  }

  final List<({IconData icon, String label, Widget page})> _pages = [
    (
      icon: Icons.notifications,
      label: 'Notifications',
      page: const NotificationsPage(),
    ),
    (
      icon: Icons.people,
      label: 'Occupancy',
      page: const OccupancyPage(),
    ),
    (
      icon: Icons.bar_chart,
      label: 'Reports',
      page: const ReportsPage(),
    ),
    (
      icon: Icons.settings,
      label: 'Settings',
      page: const SettingsPage(),
    ),
    (
      icon: Icons.person,
      label: 'Profile',
      page: const ProfilePage(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        leading: _isPinned
            ? null
            : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
      ),
      body: Row(
        children: [
          if (_isPinned)
            NavigationRail(
              extended: true,
              minExtendedWidth: 200,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.push_pin),
                  onPressed: () {
                    setState(() {
                      _isPinned = false;
                    });
                  },
                ),
              ),
              destinations: _pages
                  .map((page) => NavigationRailDestination(
                        icon: Icon(page.icon),
                        label: Text(page.label),
                      ))
                  .toList(),
            ),
          Expanded(child: _pages[_selectedIndex].page),
        ],
      ),
      drawer: !_isPinned
          ? NavigationDrawer(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.push_pin_outlined),
                    onPressed: () {
                      setState(() {
                        _isPinned = true;
                      });
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                ),
                ..._pages.map(
                  (page) => NavigationDrawerDestination(
                    icon: Icon(page.icon),
                    label: Text(page.label),
                  ),
                ),
              ],
            )
          : null,
    );
  }
}
