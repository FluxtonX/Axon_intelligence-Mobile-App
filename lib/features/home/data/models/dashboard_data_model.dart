import '../../../../core/models/user_model.dart';
import '../../../contracts/data/models/contract_model.dart';
import '../../../notifications/data/models/notification_model.dart';

class DashboardStats {
  final double totalSpend;
  final int activeContracts;
  final int totalHires;

  DashboardStats({
    required this.totalSpend,
    required this.activeContracts,
    required this.totalHires,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalSpend: (json['totalSpend'] ?? 0).toDouble(),
      activeContracts: json['activeContracts'] ?? 0,
      totalHires: json['totalHires'] ?? 0,
    );
  }
}

class DashboardDataModel {
  final DashboardStats stats;
  final List<ContractModel> submittedContracts;
  final List<NotificationModel> recentActivity;
  final List<UserModel> recommendedTalent;

  DashboardDataModel({
    required this.stats,
    required this.submittedContracts,
    required this.recentActivity,
    required this.recommendedTalent,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      stats: DashboardStats.fromJson(json['stats'] ?? {}),
      submittedContracts: (json['submittedContracts'] as List<dynamic>?)
              ?.map((e) => ContractModel.fromJson(e))
              .toList() ??
          [],
      recentActivity: (json['recentActivity'] as List<dynamic>?)
              ?.map((e) => NotificationModel.fromJson(e))
              .toList() ??
          [],
      recommendedTalent: (json['recommendedTalent'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
