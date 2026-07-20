import 'package:equatable/equatable.dart';

class ProposalEntity extends Equatable {
  final String id;
  final String freelancerId;
  final String freelancerName;
  final String freelancerTitle;
  final String freelancerImageUrl;
  final double freelancerRating;
  final int matchPercentage;
  final String coverLetter;
  final double bidAmount;
  final int estimatedDays;
  final String status;
  final DateTime submittedAt;

  const ProposalEntity({
    required this.id,
    required this.freelancerId,
    required this.freelancerName,
    required this.freelancerTitle,
    required this.freelancerImageUrl,
    required this.freelancerRating,
    required this.matchPercentage,
    required this.coverLetter,
    required this.bidAmount,
    required this.estimatedDays,
    required this.status,
    required this.submittedAt,
  });

  @override
  List<Object?> get props => [
        id,
        freelancerId,
        freelancerName,
        freelancerTitle,
        freelancerImageUrl,
        freelancerRating,
        matchPercentage,
        coverLetter,
        bidAmount,
        estimatedDays,
        status,
        submittedAt,
      ];

  factory ProposalEntity.fromJson(Map<String, dynamic> json) {
    final freelancer = json['freelancer'];
    final profile = freelancer != null ? freelancer['profile'] : null;

    return ProposalEntity(
      id: json['id'] as String,
      freelancerId: json['freelancerId'] as String,
      freelancerName: profile != null ? '${profile['firstName']} ${profile['lastName']}' : 'Unknown',
      freelancerTitle: profile != null && profile['title'] != null ? profile['title'] as String : 'Freelancer',
      freelancerImageUrl: profile != null && profile['avatarUrl'] != null ? profile['avatarUrl'] as String : 'https://i.pravatar.cc/150?img=5',
      freelancerRating: profile != null && profile['averageRating'] != null ? (profile['averageRating'] as num).toDouble() : 0.0,
      matchPercentage: 90, // Hardcoded for now
      coverLetter: json['coverLetter'] as String,
      bidAmount: (json['bidAmount'] as num).toDouble(),
      estimatedDays: json['deliveryDays'] as int,
      status: json['status'] as String? ?? 'PENDING',
      submittedAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
