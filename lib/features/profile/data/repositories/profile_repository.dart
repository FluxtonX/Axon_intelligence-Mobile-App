import '../../../../core/models/user_model.dart';
import '../../../../core/network/api_client.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository(this._apiClient);

  Future<UserModel> getCurrentProfile() async {
    try {
      final response = await _apiClient.dio.get('/users/me');
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? title,
    double? hourlyRate,
    List<String>? skills,
    String? avatarUrl,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['firstName'] = firstName;
      if (lastName != null) data['lastName'] = lastName;
      if (bio != null) data['bio'] = bio;
      if (title != null) data['title'] = title;
      if (hourlyRate != null) data['hourlyRate'] = hourlyRate;
      if (skills != null) data['skills'] = skills;
      if (avatarUrl != null) data['avatarUrl'] = avatarUrl;

      await _apiClient.dio.patch('/users/me/profile', data: data);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
