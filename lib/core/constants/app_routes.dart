/// App route name constants — used with go_router
abstract class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String gigDetail = '/gig/:id';
  static const String createGig = '/create-gig';
  static const String orders = '/orders';
  static const String orderDetail = '/orders/:id';
  static const String messages = '/messages';
  static const String conversation = '/messages/:id';
}
