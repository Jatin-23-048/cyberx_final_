import 'package:flutter/material.dart';
import '../models/discussion.dart';
import 'package:intl/intl.dart';

class DiscussionCard extends StatelessWidget {
  final Discussion discussion;

  const DiscussionCard({
    Key? key,
    required this.discussion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          discussion.authorName,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (discussion.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            size: 14,
                            color: Color(0xFF2563EB),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      discussion.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _getTimeAgo(discussion.timestamp),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            discussion.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            discussion.content,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.thumb_up_outlined, size: 16, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                '${discussion.likes}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.comment_outlined, size: 16, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                '${discussion.replies}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
                child: const Text('Reply', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }
}
