import 'package:flutter/material.dart';
import '../models/threat.dart';
import 'package:intl/intl.dart';

class ThreatCard extends StatelessWidget {
  final Threat threat;

  const ThreatCard({
    Key? key,
    required this.threat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor();
    final timeAgo = _getTimeAgo();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4B5563)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: severityColor.withAlpha(200),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  threat.severity,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF374151),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  threat.status,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            threat.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            threat.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 14,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                threat.region,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.source,
                size: 14,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                threat.source,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                timeAgo,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: severityColor,
              minimumSize: const Size(double.infinity, 36),
            ),
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor() {
    switch (threat.severity) {
      case 'CRITICAL':
        return const Color(0xFFEF4444);
      case 'HIGH':
        return const Color(0xFFF97316);
      case 'MEDIUM':
        return const Color(0xFFFACC15);
      default:
        return const Color(0xFF10B981);
    }
  }

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(threat.timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(threat.timestamp);
    }
  }
}
