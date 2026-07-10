import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/email_auth_page.dart';
import '../../features/main_shell/presentation/pages/main_shell_page.dart';
import '../../features/project_creation/presentation/pages/ai_project_creation_page.dart';

/// Axon Intelligence — App Router
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: '/login/email',
      name: 'emailAuth',
      builder: (context, state) => const EmailAuthPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const MainShellPage(),
    ),
    GoRoute(
      path: '/ai_project_creation',
      builder: (context, state) => const AiProjectCreationPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.error}')),
  ),
);
