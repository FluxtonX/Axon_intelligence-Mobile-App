import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit(this._repository) : super(ProfileInitial());

  Future<void> loadProfile() async {
    try {
      emit(ProfileLoading());
      final user = await _repository.getCurrentProfile();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
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
      // It might be better to maintain current state and just update loading indicator,
      // but for simplicity we reload the whole profile state.
      emit(ProfileLoading());
      await _repository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        bio: bio,
        title: title,
        hourlyRate: hourlyRate,
        skills: skills,
        avatarUrl: avatarUrl,
      );
      // Reload profile after update
      await loadProfile();
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfileImage(XFile image) async {
    try {
      emit(ProfileLoading());
      
      // Upload avatar to S3
      final avatarUrl = await _repository.uploadAvatar(image);
      
      // Update the profile with the new URL
      await _repository.updateProfile(avatarUrl: avatarUrl);
      
      // Reload profile
      await loadProfile();
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
