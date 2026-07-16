class ProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final String? bio;
  final String? title;
  final double? hourlyRate;
  final List<String> skills;
  final double averageRating;
  final int totalReviews;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
    this.bio,
    this.title,
    this.hourlyRate,
    this.skills = const [],
    this.averageRating = 0.0,
    this.totalReviews = 0,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      title: json['title'] as String?,
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble(),
      skills: (json['skills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'title': title,
      'hourlyRate': hourlyRate,
      'skills': skills,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
    };
  }
}
