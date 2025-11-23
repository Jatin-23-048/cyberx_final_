class Report {
  final String id;
  final String threatType;
  final String subject;
  final String description;
  final String status;
  final DateTime timestamp;
  final String? attachmentPath;

  Report({
    required this.id,
    required this.threatType,
    required this.subject,
    required this.description,
    required this.status,
    required this.timestamp,
    this.attachmentPath,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'threatType': threatType,
    'subject': subject,
    'description': description,
    'status': status,
    'timestamp': timestamp.toIso8601String(),
    'attachmentPath': attachmentPath,
  };

  factory Report.fromJson(Map<String, dynamic> json) => Report(
    id: json['id'] ?? '',
    threatType: json['threatType'] ?? '',
    subject: json['subject'] ?? '',
    description: json['description'] ?? '',
    status: json['status'] ?? '',
    timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    attachmentPath: json['attachmentPath'],
  );
}
