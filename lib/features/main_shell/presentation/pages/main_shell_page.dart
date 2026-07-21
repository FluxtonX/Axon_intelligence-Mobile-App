import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../discover/presentation/pages/discover_page.dart';
import '../../../messages/presentation/pages/messages_page.dart';
import '../../../projects/presentation/pages/projects_page.dart';
import '../../../find_work/presentation/pages/find_work_page.dart';
import '../bloc/main_shell_bloc.dart';
import '../bloc/main_shell_event.dart';
import '../bloc/main_shell_state.dart';
import '../../../../core/blocs/user_mode_cubit.dart';
import '../../../seller_dashboard/presentation/pages/seller_dashboard_page.dart';

class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainShellBloc(),
      child: const _MainShellView(),
    );
  }
}

class _MainShellView extends StatelessWidget {
  const _MainShellView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/auth');
        }
      },
      child: BlocBuilder<UserModeCubit, UserMode>(
        builder: (context, userMode) {
          final isFreelancer = userMode == UserMode.freelancer;

          final List<Widget> pages = isFreelancer
              ? [
                  const SellerDashboardPage(),
                  const FindWorkPage(),
                  const ProjectsPage(), // Using ProjectsPage for active orders for now
                  const MessagesPage(),
                  const ProfilePage(),
                ]
              : [
                  const HomePage(),
                  const ProjectsPage(),
                  const DiscoverPage(),
                  const MessagesPage(),
                  const ProfilePage(),
                ];

          final items = isFreelancer
              ? const [
                  BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
                  BottomNavigationBarItem(icon: Icon(Icons.search_rounded), activeIcon: Icon(Icons.search_rounded), label: 'Find Work'),
                  BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long_rounded), label: 'Orders'),
                  BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), activeIcon: Icon(Icons.chat_bubble_rounded), label: 'Messages'),
                  BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'Profile'),
                ]
              : const [
                  BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(Icons.work_outline_rounded), activeIcon: Icon(Icons.work_rounded), label: 'Projects'),
                  BottomNavigationBarItem(icon: Icon(Icons.people_outline_rounded), activeIcon: Icon(Icons.people_rounded), label: 'Talent'),
                  BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), activeIcon: Icon(Icons.chat_bubble_rounded), label: 'Messages'),
                  BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'Profile'),
                ];

          return BlocBuilder<MainShellBloc, MainShellState>(
            builder: (context, state) {
              // Safely clamp the index to prevent out-of-bounds errors when switching modes
              final safeIndex = state.currentIndex >= pages.length ? 0 : state.currentIndex;

              return Scaffold(
                body: IndexedStack(
                  index: safeIndex,
                  children: pages,
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: BottomNavigationBar(
                      currentIndex: safeIndex,
                      onTap: (index) {
                        context.read<MainShellBloc>().add(TabChanged(index));
                      },
                      backgroundColor: Colors.white,
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: AppColors.primary,
                      unselectedItemColor: AppColors.textSecondary.withValues(alpha: 0.6),
                      selectedLabelStyle: AppTypography.caption.copyWith(fontWeight: FontWeight.w600, fontSize: 10),
                      unselectedLabelStyle: AppTypography.caption.copyWith(fontWeight: FontWeight.w500, fontSize: 10),
                      elevation: 0,
                      items: items,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Temporary placeholder for unbuilt tabs
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title Page Coming Soon')),
    );
  }
}
