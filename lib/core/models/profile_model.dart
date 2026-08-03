import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  static String? _resolveImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    
    // If it's a relative URL
    if (url.startsWith('/uploads/')) {
      final baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://axon-intelligence-backend-in-nest-js.onrender.com/api';
      final host = baseUrl.replaceAll(RegExp(r'/api$'), '');
      return '$host$url';
    }

    // If it's an absolute local URL from a previous IP session (e.g., http://192.168.1.71:3000/uploads/...)
    if (url.startsWith('http://') && url.contains('/uploads/')) {
      final uri = Uri.tryParse(url);
      if (uri != null && (uri.host == 'localhost' || uri.host == '127.0.0.1' || uri.host.startsWith('192.168.') || uri.host.startsWith('10.'))) {
        final baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://axon-intelligence-backend-in-nest-js.onrender.com/api';
        final host = baseUrl.replaceAll(RegExp(r'/api$'), '');
        return '$host${uri.path}';
      }
    }

    return url;
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      avatarUrl: _resolveImageUrl(json['avatarUrl'] as String?),
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
