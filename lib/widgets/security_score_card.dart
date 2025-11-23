import 'package:flutter/material.dart';

class SecurityScoreCard extends StatelessWidget {
  final double score;

  const SecurityScoreCard({
    Key? key,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoreColor = score >= 80
        ? const Color(0xFF10B981)
        : score >= 60
        ? const Color(0xFFFACC15)
        : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1F2937),
            const Color(0xFF111827),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4B5563)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Security Score',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              Text(
                '${score.toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scoreColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFF374151),
              valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Complete "Safe Browsing" module to improve your score',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
