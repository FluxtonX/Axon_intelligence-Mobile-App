import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../discover/presentation/pages/discover_page.dart';
import '../bloc/main_shell_bloc.dart';
import '../bloc/main_shell_event.dart';
import '../bloc/main_shell_state.dart';

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
    // Note: IndexedStack is used to keep the state of the pages alive
    // when switching between tabs.
    final List<Widget> pages = [
      const HomePage(),
      const _PlaceholderPage(title: 'Projects'),
      const DiscoverPage(),
      const _PlaceholderPage(title: 'Messages'),
      const ProfilePage(),
    ];

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/auth');
        }
      },
      child: BlocBuilder<MainShellBloc, MainShellState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(
              index: state.currentIndex,
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
              child: BottomNavigationBar(
                currentIndex: state.currentIndex,
                onTap: (index) {
                  context.read<MainShellBloc>().add(TabChanged(index));
                },
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: AppColors.textSecondary.withValues(alpha: 0.6),
                selectedLabelStyle: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
                unselectedLabelStyle: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
                elevation: 0,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.work_outline_rounded),
                    activeIcon: Icon(Icons.work_rounded),
                    label: 'Projects',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search_rounded),
                    activeIcon: Icon(Icons.search_rounded),
                    label: 'Discover',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble_outline_rounded),
                    activeIcon: Icon(Icons.chat_bubble_rounded),
                    label: 'Messages',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline_rounded),
                    activeIcon: Icon(Icons.person_rounded),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
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
