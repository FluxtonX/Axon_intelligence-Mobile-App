import 'package:equatable/equatable.dart';

abstract class MainShellEvent extends Equatable {
  const MainShellEvent();
  @override
  List<Object?> get props => [];
}

class TabChanged extends MainShellEvent {
  const TabChanged(this.tabIndex);
  final int tabIndex;

  @override
  List<Object?> get props => [tabIndex];
}
