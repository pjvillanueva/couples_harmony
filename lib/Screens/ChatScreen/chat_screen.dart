// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:couples_harmony/Blocs/ChatCubit/chat_cubit.dart';
import 'package:couples_harmony/Blocs/PromptCubit/prompt_cubit.dart';
import 'package:couples_harmony/Models/Prompts/session_step.dart';
import 'package:couples_harmony/Screens/ChatScreen/components/chat_input.dart';
import 'package:couples_harmony/Screens/ChatScreen/components/chat_messages.dart';
import 'package:couples_harmony/Screens/EditPromptScreen/edit_prompt_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                    backgroundImage: AssetImage('assets/images/ai_lady.jpg'),
                  ),
                )),
            leadingWidth: 55,
            title: const Text('Harmony',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            backgroundColor: const Color.fromARGB(255, 5, 49, 100),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (newContext) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                              value: context.read<PromptCubit>()),
                          BlocProvider.value(value: context.read<ChatCubit>())
                        ],
                        child: const EditPromptsScreen(),
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.restart_alt, color: Colors.white),
                onPressed: () => context.read<ChatCubit>().resetChat(),
              )
            ],
          ),
          body: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              SessionStep step =
                  getCurrentStep(state.sessionStage, state.currentStep);

              return Column(
                children: [
                  Expanded(
                      child: ChatMessages(
                          messages: state.messages, messageInProcess: false)),
                  ChatInput(
                      step: step,
                      onSubmit: (response) {
                        step.Run(context, response);
                      }),
                ],
              );
            },
          )),
    );
  }
}

SessionStep getCurrentStep(SessionStage currentStage, int currentStep) {
  switch (currentStage) {
    case SessionStage.personalFeelings:
      return _getStep(PERSONAL_FEELINGS_STEPS, currentStep);
    case SessionStage.talkTowife:
      return _getStep(TALK_TO_WIFE_STEPS, currentStep);
    case SessionStage.selfAnalysis:
      return _getStep(SELF_ANALYSIS_STEPS, currentStep);
    case SessionStage.solutionBuilding:
      return _getStep(SOLUTION_BUILDING_STEPS, currentStep);
    default:
      return PERSONAL_FEELINGS_STEPS[0];
  }
}

SessionStep getNextStep(SessionStage currentStage, int currentStep) {
  switch (currentStage) {
    case SessionStage.personalFeelings:
      return _getStep(PERSONAL_FEELINGS_STEPS, currentStep);
    case SessionStage.talkTowife:
      return _getStep(TALK_TO_WIFE_STEPS, currentStep);
    case SessionStage.selfAnalysis:
      return _getStep(SELF_ANALYSIS_STEPS, currentStep);
    case SessionStage.solutionBuilding:
      return _getStep(SOLUTION_BUILDING_STEPS, currentStep);
    default:
      return PERSONAL_FEELINGS_STEPS[0];
  }
}

// Helper function to check bounds and avoid indexing errors
SessionStep _getStep(List<SessionStep> steps, int currentStep) {
  if (currentStep > 0 && currentStep <= steps.length) {
    return steps[currentStep - 1];
  }
  return steps[0]; // Default to the first step if out of bounds
}
