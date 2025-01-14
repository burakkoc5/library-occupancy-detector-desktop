import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/library_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, _) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSettingSection(
                      'Notifications',
                      [
                        _buildSwitchTile(
                          'Occupancy Alerts',
                          'Get notified when library reaches high occupancy',
                          settingsProvider.notificationsEnabled,
                          (value) {
                            settingsProvider.setNotificationsEnabled(value);
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    _buildSettingSection(
                      'Thresholds',
                      [
                        _buildDropdownTile(
                          'Update Frequency',
                          'How often to refresh occupancy data',
                          '${settingsProvider.refreshFrequency} seconds',
                          [
                            '5 seconds',
                            '10 seconds',
                            '30 seconds',
                            '60 seconds'
                          ],
                          (value) {
                            if (value != null) {
                              final seconds = int.parse(value.split(' ')[0]);
                              settingsProvider.setRefreshFrequency(seconds);
                              context
                                  .read<LibraryProvider>()
                                  .updateRefreshTimer();
                            }
                          },
                        ),
                        _buildDropdownTile(
                          'Occupancy Warning Threshold',
                          'When to show warning for high occupancy',
                          '${settingsProvider.occupancyThreshold}%',
                          ['70%', '75%', '80%', '85%', '90%'],
                          (value) {
                            if (value != null) {
                              final threshold =
                                  int.parse(value.replaceAll('%', ''));
                              settingsProvider.setOccupancyThreshold(threshold);
                            }
                          },
                        ),
                        _buildDropdownTile(
                          'Hold Time Threshold',
                          'When to notify about seats on hold',
                          '${settingsProvider.holdTimeThreshold} minutes',
                          [
                            '15 minutes',
                            '30 minutes',
                            '45 minutes',
                            '60 minutes'
                          ],
                          (value) {
                            if (value != null) {
                              final minutes = int.parse(value.split(' ')[0]);
                              settingsProvider.setHoldTimeThreshold(minutes);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    String currentValue,
    List<String> items,
    Function(String?) onChanged,
  ) {
    if (!items.contains(currentValue)) {
      items = List.from(items)..add(currentValue);
      items.sort((a, b) {
        final aNum = int.parse(a.split(' ')[0]);
        final bNum = int.parse(b.split(' ')[0]);
        return aNum.compareTo(bNum);
      });
    }

    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: currentValue,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: onChanged,
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}
