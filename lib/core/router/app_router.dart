import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/email_auth_page.dart';
import '../../features/main_shell/presentation/pages/main_shell_page.dart';
import '../../features/project_creation/presentation/pages/ai_project_creation_page.dart';
import '../../features/project_creation/presentation/pages/project_brief_review_page.dart';
import '../../features/freelancer_profile/presentation/pages/freelancer_profile_page.dart';
import '../../features/messages/presentation/pages/chat_detail_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/help_support_page.dart';
import '../../features/hire/presentation/pages/create_contract_page.dart';
import '../../features/hire/presentation/pages/checkout_page.dart';
import '../../features/hire/presentation/pages/payment_success_page.dart';
import '../../features/proposals/presentation/pages/proposals_list_page.dart';
import '../../features/proposals/presentation/pages/proposal_detail_page.dart';
import '../../features/proposals/domain/entities/proposal_entity.dart';
import '../../features/seller_onboarding/presentation/pages/seller_onboarding_page.dart';
import '../../features/gig_creation/presentation/pages/create_gig_page.dart';
import '../../features/find_work/presentation/pages/submit_proposal_page.dart';

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
    GoRoute(
      path: '/project_brief_review',
      builder: (context, state) => const ProjectBriefReviewPage(),
    ),
    GoRoute(
      path: '/freelancer-profile',
      name: 'freelancerProfile',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final name = extra['name'] as String? ?? 'Sophia Chen';
        final imageUrl = extra['imageUrl'] as String? ?? 'https://i.pravatar.cc/150?img=5';
        return FreelancerProfilePage(name: name, imageUrl: imageUrl);
      },
    ),
    GoRoute(
      path: '/chat/:id',
      name: 'chatDetail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final extra = state.extra;
        String name = 'Freelancer';
        String avatarUrl = 'https://i.pravatar.cc/150?img=5';
        
        if (extra is Map<String, dynamic>) {
           name = extra['name'] as String? ?? 'Freelancer';
           avatarUrl = extra['avatarUrl'] as String? ?? 'https://i.pravatar.cc/150?img=5';
        } else if (extra is String) {
           name = extra;
        }

        return ChatDetailPage(chatId: id, name: name, avatarUrl: avatarUrl);
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/edit_profile',
      name: 'editProfile',
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: '/help_support',
      name: 'helpSupport',
      builder: (context, state) => const HelpSupportPage(),
    ),
    GoRoute(
      path: '/hire',
      name: 'hire',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final id = extra['id'] as String? ?? '123';
        final name = extra['name'] as String? ?? 'Sophia Chen';
        return CreateContractPage(freelancerId: id, freelancerName: name);
      },
    ),
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      builder: (context, state) => const CheckoutPage(),
    ),
    GoRoute(
      path: '/payment_success',
      name: 'paymentSuccess',
      builder: (context, state) => const PaymentSuccessPage(),
    ),
    GoRoute(
      path: '/proposals/:jobId',
      name: 'proposals',
      builder: (context, state) {
        final jobId = state.pathParameters['jobId'] ?? 'job_123';
        return ProposalsListPage(jobId: jobId);
      },
    ),
    GoRoute(
      path: '/proposal_detail',
      name: 'proposalDetail',
      builder: (context, state) {
        final proposal = state.extra as ProposalEntity;
        return ProposalDetailPage(proposal: proposal);
      },
    ),
    GoRoute(
      path: '/seller_onboarding',
      name: 'sellerOnboarding',
      builder: (context, state) => const SellerOnboardingPage(),
    ),
    GoRoute(
      path: '/create_gig',
      name: 'createGig',
      builder: (context, state) => const CreateGigPage(),
    ),
    GoRoute(
      path: '/submit_proposal',
      name: 'submitProposal',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final jobTitle = extra['jobTitle'] as String? ?? 'Project';
        final clientName = extra['clientName'] as String? ?? 'Client';
        return SubmitProposalPage(jobTitle: jobTitle, clientName: clientName);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.error}')),
  ),
);
