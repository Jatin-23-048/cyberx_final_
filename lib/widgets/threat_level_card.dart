import 'package:flutter/material.dart';

class ThreatLevelCard extends StatelessWidget {
  final String threatLevel;

  const ThreatLevelCard({
    Key? key,
    required this.threatLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = _getColorForLevel(threatLevel);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentTextColor = isDark ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withAlpha(100), color.withAlpha(30)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(150)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: color, size: 28),
              const SizedBox(width: 12),
              Text(
                'Current Threat Level',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: contentTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            threatLevel,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: contentTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Increased phishing activity detected globally',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: contentTextColor,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: contentTextColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            child: Text('View Details', style: TextStyle(color: contentTextColor)),
          ),
        ],
      ),
    );
  }

  Color _getColorForLevel(String level) {
    switch (level) {
      case 'Critical':
        return const Color(0xFFEF4444);
      case 'High':
        return const Color(0xFFF97316);
      case 'Medium':
        return const Color(0xFFFACC15);
      case 'Low':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFFFFFFFF);
    }
  }
}
