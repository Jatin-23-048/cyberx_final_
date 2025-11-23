import 'package:flutter/material.dart';
import '../models/threat.dart';
import 'threat_card.dart';

class RecentAlertsCard extends StatelessWidget {
  final List<Threat> threats;

  const RecentAlertsCard({
    Key? key,
    required this.threats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: threats
          .map((threat) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ThreatCard(threat: threat),
          ))
          .toList(),
    );
  }
}
