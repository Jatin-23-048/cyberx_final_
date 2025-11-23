import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/threat_card.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Threat Alerts'),
        elevation: 0,
      ),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final filters = ['All', 'ACTIVE', 'MONITORING', 'RESOLVED'];
          final filteredThreats = _selectedFilter == 'All'
              ? state.threats
              : state.getThreats(filter: _selectedFilter);

          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: filters.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => _selectedFilter = filter);
                          },
                          backgroundColor: const Color(0xFF252f3d),
                          selectedColor: const Color(0xFF1e7dd6),
                          labelStyle: TextStyle(
                            color: Colors.white, // Updated color to white
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredThreats.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ThreatCard(threat: filteredThreats[index]),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
