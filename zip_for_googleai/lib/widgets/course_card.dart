import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252f3d),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3f4451)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  course.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // explicitly set to white
                  ),
                ),
              ),
              if (course.completed)
                const Icon(Icons.check_circle, color: Color(0xFF10B981)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            course.category,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.book, size: 16, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                '${course.lessons} lessons',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.schedule, size: 16, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                '${course.duration}m',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.star, size: 16, color: const Color(0xFFFACC15)),
              const SizedBox(width: 4),
              Text(
                '${course.rating}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: course.progress,
              minHeight: 6,
              backgroundColor: const Color(0xFF3f4451),
              valueColor: AlwaysStoppedAnimation<Color>(
                course.progress >= 0.99
                    ? const Color(0xFF10b981)
                    : const Color(0xFF1e7dd6),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1e7dd6),
                minimumSize: const Size(double.infinity, 36),
              ),
              child: Text(
                course.progress >= 0.99 ? 'Review' : 'Continue',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
