class Discussion {
  final String id;
  final String title;
  final String category;
  final String content;
  final String authorId;
  final String authorName;
  final bool isVerified;
  final DateTime timestamp;
  final int replies;
  final int likes;

  Discussion({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.isVerified,
    required this.timestamp,
    required this.replies,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'content': content,
    'authorId': authorId,
    'authorName': authorName,
    'isVerified': isVerified,
    'timestamp': timestamp.toIso8601String(),
    'replies': replies,
    'likes': likes,
  };

  factory Discussion.fromJson(Map<String, dynamic> json) => Discussion(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    category: json['category'] ?? '',
    content: json['content'] ?? '',
    authorId: json['authorId'] ?? '',
    authorName: json['authorName'] ?? '',
    isVerified: json['isVerified'] ?? false,
    timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    replies: json['replies'] ?? 0,
    likes: json['likes'] ?? 0,
  );
}
