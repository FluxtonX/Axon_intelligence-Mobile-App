import 'profile_model.dart';

class UserModel {
  final String id;
  final String email;
  final String role;
  final String? authProvider;
  final ProfileModel? profile;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.authProvider,
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'USER',
      authProvider: json['authProvider'] as String?,
      profile: json['profile'] != null ? ProfileModel.fromJson(json['profile']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'authProvider': authProvider,
      'profile': profile?.toJson(),
    };
  }
}
