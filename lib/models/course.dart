class Course {
  final String id;
  final String title;
  final String category;
  final String description;
  final int lessons;
  final int duration;
  final double rating;
  final double progress;
  final bool completed;

  Course({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.lessons,
    required this.duration,
    required this.rating,
    required this.progress,
    this.completed = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'description': description,
    'lessons': lessons,
    'duration': duration,
    'rating': rating,
    'progress': progress,
    'completed': completed,
  };

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    category: json['category'] ?? '',
    description: json['description'] ?? '',
    lessons: json['lessons'] ?? 0,
    duration: json['duration'] ?? 0,
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    completed: json['completed'] ?? false,
  );
}
