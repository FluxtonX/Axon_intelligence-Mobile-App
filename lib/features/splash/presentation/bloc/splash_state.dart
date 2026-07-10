import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

/// Initial state — splash animation is playing
class SplashInitial extends SplashState {
  const SplashInitial();
}

/// Animation complete — navigate to next screen
class SplashNavigateToAuth extends SplashState {
  const SplashNavigateToAuth();
}

/// Already authenticated — navigate to home
class SplashNavigateToHome extends SplashState {
  const SplashNavigateToHome();
}
