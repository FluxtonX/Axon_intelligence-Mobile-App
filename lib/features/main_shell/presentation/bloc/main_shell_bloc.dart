import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_shell_event.dart';
import 'main_shell_state.dart';

class MainShellBloc extends Bloc<MainShellEvent, MainShellState> {
  MainShellBloc() : super(const MainShellState()) {
    on<TabChanged>((event, emit) {
      emit(state.copyWith(currentIndex: event.tabIndex));
    });
  }
}
