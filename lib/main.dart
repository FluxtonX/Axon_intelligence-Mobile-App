import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/storage/local_storage.dart';
import 'core/network/api_client.dart';
import 'features/auth/data/auth_repository.dart';
import 'core/blocs/user_mode_cubit.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/theme.dart';
import 'core/router/app_router.dart';
import 'features/hire/presentation/bloc/hire_bloc.dart';
import 'features/hire/data/repositories/mock_hire_repository.dart';
import 'features/proposals/presentation/bloc/proposals_bloc.dart';
import 'features/gig_creation/presentation/bloc/gig_creation_bloc.dart';
import 'features/projects/presentation/bloc/client_projects_bloc.dart';
import 'features/profile/data/repositories/profile_repository.dart';
import 'features/profile/presentation/bloc/profile_cubit.dart';
import 'features/projects/data/repositories/project_repository.dart';
import 'features/find_work/presentation/bloc/find_work_bloc.dart';
import 'features/find_work/presentation/bloc/find_work_event.dart';
import 'features/proposals/data/repositories/proposal_repository.dart';
import 'features/proposals/presentation/bloc/submit_proposal_bloc.dart';
import 'features/contracts/data/repositories/contract_repository.dart';
import 'features/contracts/presentation/bloc/contracts_bloc.dart';
import 'features/discover/data/repositories/discover_repository.dart';
import 'features/messages/data/repositories/messages_repository.dart';
import 'features/messages/presentation/blocs/conversations_bloc.dart';
import 'features/messages/presentation/blocs/conversations_event.dart';
import 'features/contracts/data/repositories/reviews_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localStorage = await LocalStorage.init();
  final apiClient = ApiClient(localStorage);
  final authRepository = AuthRepository(apiClient, localStorage);
  final profileRepository = ProfileRepository(apiClient);
  final projectRepository = ProjectRepository(apiClient);
  final proposalRepository = ProposalRepository(apiClient);
  final contractRepository = ContractRepository(apiClient);
  final discoverRepository = DiscoverRepository(apiClient);
  final messagesRepository = MessagesRepository(apiClient);
  final reviewsRepository = ReviewsRepository(apiClient);

  // Lock to portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status + nav bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(AxonIntelligenceApp(
    authRepository: authRepository, 
    profileRepository: profileRepository,
    projectRepository: projectRepository,
    proposalRepository: proposalRepository,
    contractRepository: contractRepository,
    discoverRepository: discoverRepository,
    messagesRepository: messagesRepository,
    reviewsRepository: reviewsRepository,
    apiClient: apiClient,
  ));
}

class AxonIntelligenceApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;
  final ProjectRepository projectRepository;
  final ProposalRepository proposalRepository;
  final ContractRepository contractRepository;
  final DiscoverRepository discoverRepository;
  final MessagesRepository messagesRepository;
  final ReviewsRepository reviewsRepository;
  final ApiClient apiClient;

  const AxonIntelligenceApp({
    super.key, 
    required this.authRepository, 
    required this.profileRepository,
    required this.projectRepository,
    required this.proposalRepository,
    required this.contractRepository,
    required this.discoverRepository,
    required this.messagesRepository,
    required this.reviewsRepository,
    required this.apiClient,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: profileRepository),
        RepositoryProvider.value(value: projectRepository),
        RepositoryProvider.value(value: proposalRepository),
        RepositoryProvider.value(value: contractRepository),
        RepositoryProvider.value(value: discoverRepository),
        RepositoryProvider.value(value: messagesRepository),
        RepositoryProvider.value(value: reviewsRepository),
        RepositoryProvider.value(value: apiClient),
      ],
      child: MultiBlocProvider(
        providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(profileRepository)..loadProfile(),
        ),
        BlocProvider<UserModeCubit>(
          create: (context) => UserModeCubit(),
        ),
        BlocProvider<HireBloc>(
          create: (context) => HireBloc(proposalRepository, contractRepository),
        ),
        BlocProvider<ProposalsBloc>(
          create: (context) => ProposalsBloc(proposalRepository),
        ),
        BlocProvider<SubmitProposalBloc>(
          create: (context) => SubmitProposalBloc(proposalRepository),
        ),
        BlocProvider<ContractsBloc>(
          create: (context) => ContractsBloc(contractRepository, reviewsRepository),
        ),
        BlocProvider<ConversationsBloc>(
          create: (context) => ConversationsBloc(messagesRepository)..add(const FetchConversations()),
        ),
        BlocProvider<GigCreationBloc>(
          create: (context) => GigCreationBloc(),
        ),
        BlocProvider<ClientProjectsBloc>(
          create: (context) => ClientProjectsBloc(projectRepository)..add(LoadClientProjectsEvent()),
        ),
        BlocProvider<FindWorkBloc>(
          create: (context) => FindWorkBloc(projectRepository: projectRepository)..add(LoadProjectsEvent()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Axon Intelligence',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: appRouter,
      ),
    ));
  }
}
