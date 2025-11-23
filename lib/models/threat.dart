class Threat {
  final String id;
  final String title;
  final String description;
  final String severity;
  final String status;
  final String region;
  final String source;
  final DateTime timestamp;
  final String? cveId;
  final String? mitigation;

  Threat({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.status,
    required this.region,
    required this.source,
    required this.timestamp,
    this.cveId,
    this.mitigation,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'severity': severity,
    'status': status,
    'region': region,
    'source': source,
    'timestamp': timestamp.toIso8601String(),
    'cveId': cveId,
    'mitigation': mitigation,
  };

  factory Threat.fromJson(Map<String, dynamic> json) => Threat(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    severity: json['severity'],
    status: json['status'],
    region: json['region'],
    source: json['source'],
    timestamp: DateTime.parse(json['timestamp']),
    cveId: json['cveId'],
    mitigation: json['mitigation'],
  );
}
