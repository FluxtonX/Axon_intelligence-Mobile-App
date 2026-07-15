import 'package:flutter_bloc/flutter_bloc.dart';

enum UserMode { client, freelancer }

class UserModeCubit extends Cubit<UserMode> {
  UserModeCubit() : super(UserMode.client);

  void toggleMode() {
    emit(state == UserMode.client ? UserMode.freelancer : UserMode.client);
  }

  void setMode(UserMode mode) {
    emit(mode);
  }
}
