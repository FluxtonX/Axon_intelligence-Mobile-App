import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the splash screen is first displayed
class SplashStarted extends SplashEvent {
  const SplashStarted();
}
