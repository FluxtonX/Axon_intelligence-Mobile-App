import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/models/chat_message.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/ai_project_repository.dart';
import '../bloc/ai_project_bloc.dart';
import '../bloc/ai_project_event.dart';
import '../bloc/ai_project_state.dart';
import '../widgets/ai_chat_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/user_chat_bubble.dart';

class AiProjectCreationPage extends StatelessWidget {
  const AiProjectCreationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AiProjectBloc(
        AiProjectRepository(context.read<ApiClient>()),
      )..add(const AiProjectStarted()),
      child: const _AiProjectCreationView(),
    );
  }
}

class _AiProjectCreationView extends StatefulWidget {
  const _AiProjectCreationView();

  @override
  State<_AiProjectCreationView> createState() => _AiProjectCreationViewState();
}

class _AiProjectCreationViewState extends State<_AiProjectCreationView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      });
    }
  }

  void _submitMessage(BuildContext context) {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.read<AiProjectBloc>().add(UserMessageSubmitted(text));
      _textController.clear();
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Very light gray (matches Home)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(
              'Axon AI',
              style: AppTypography.headingSmall.copyWith(fontSize: 16, color: AppColors.textDark),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AiProjectBloc, AiProjectState>(
        listener: (context, state) {
          if (state.status == ProjectCreationStatus.typing ||
              state.status == ProjectCreationStatus.waitingForInput) {
            _scrollToBottom();
          } else if (state.status == ProjectCreationStatus.complete) {
            // Navigate to Brief Review
            context.pushReplacement('/project_brief_review');
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  itemCount: state.messages.length + (state.status == ProjectCreationStatus.typing ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.messages.length) {
                      return const TypingIndicator();
                    }

                    final message = state.messages[index];
                    if (message.isAi) {
                      return AiChatBubble(
                        message: message,
                        onOptionSelected: (option) {
                          context.read<AiProjectBloc>().add(OptionSelected(option));
                          _scrollToBottom();
                        },
                      );
                    } else {
                      return UserChatBubble(message: message);
                    }
                  },
                ),
              ),

              // Generating Brief Overlay
              if (state.status == ProjectCreationStatus.generatingBrief)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Compiling project brief...',
                        style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),

              // Input Field
              if (state.status != ProjectCreationStatus.generatingBrief && state.status != ProjectCreationStatus.complete)
                Container(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 16,
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                  ),
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextField(
                            controller: _textController,
                            style: AppTypography.bodyMedium,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _submitMessage(context),
                            decoration: InputDecoration(
                              hintText: 'Type your response...',
                              hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _submitMessage(context),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
