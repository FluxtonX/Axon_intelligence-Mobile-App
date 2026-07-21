class ProjectModel {
  final String id;
  final String clientId;
  final String title;
  final String description;
  final double budget;
  final String? timeline;
  final String status;
  final List<String> skills;
  final DateTime createdAt;
  final Map<String, dynamic>? client;
  final int proposalsCount;

  ProjectModel({
    required this.id,
    required this.clientId,
    required this.title,
    required this.description,
    required this.budget,
    this.timeline,
    required this.status,
    this.skills = const [],
    required this.createdAt,
    this.client,
    this.proposalsCount = 0,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      budget: (json['budget'] as num).toDouble(),
      timeline: json['timeline'] as String?,
      status: json['status'] as String,
      skills: (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      client: json['client'] as Map<String, dynamic>?,
      proposalsCount: (json['proposals'] as List?)?.length ?? json['proposalsCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'title': title,
      'description': description,
      'budget': budget,
      'timeline': timeline,
      'status': status,
      'skills': skills,
      'createdAt': createdAt.toIso8601String(),
      if (client != null) 'client': client,
      'proposalsCount': proposalsCount,
    };
  }
}
