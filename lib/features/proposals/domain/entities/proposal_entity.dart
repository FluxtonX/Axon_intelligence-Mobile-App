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
        submittedAt,
      ];
}
