import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String contractId;
  final String reviewerId;
  final String revieweeId;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final ReviewerData? reviewer;

  const ReviewEntity({
    required this.id,
    required this.contractId,
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.reviewer,
  });

  @override
  List<Object?> get props => [
        id,
        contractId,
        reviewerId,
        revieweeId,
        rating,
        comment,
        createdAt,
        reviewer,
      ];

  factory ReviewEntity.fromJson(Map<String, dynamic> json) {
    return ReviewEntity(
      id: json['id'] as String,
      contractId: json['contractId'] as String,
      reviewerId: json['reviewerId'] as String,
      revieweeId: json['revieweeId'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      reviewer: json['reviewer'] != null ? ReviewerData.fromJson(json['reviewer']) : null,
    );
  }
}

class ReviewerData extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;

  const ReviewerData({
    required this.id,
    this.firstName,
    this.lastName,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, avatarUrl];

  factory ReviewerData.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>?;
    return ReviewerData(
      id: json['id'] as String,
      firstName: profile?['firstName'] as String?,
      lastName: profile?['lastName'] as String?,
      avatarUrl: profile?['avatarUrl'] as String?,
    );
  }
}
