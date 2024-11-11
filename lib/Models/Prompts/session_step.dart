// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';

import 'package:couples_harmony/Blocs/ChatCubit/chat_cubit.dart';
import 'package:couples_harmony/Screens/ChatScreen/chat_screen.dart';
import 'package:couples_harmony/Services/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum StepType { nothing, input, polar, multipleChoices, conditional, rate }

enum SessionStage {
  personalFeelings,
  talkTowife,
  selfAnalysis,
  solutionBuilding
}

ChatService chatService = ChatService();

List<SessionStep> PERSONAL_FEELINGS_STEPS = [
  PersonalFeelingsStep1(),
  PersonalFeelingsStep2(),
  PersonalFeelingsStep3(),
  PersonalFeelingsStep4(),
  PersonalFeelingsStep5(),
  PersonalFeelingsStep6(),
];

List<SessionStep> TALK_TO_WIFE_STEPS = [TalkToWifeStep1()];

List<SessionStep> SELF_ANALYSIS_STEPS = [
  SelfAnalysisStep1(),
  SelfAnalysisStep2(),
  SelfAnalysisStep3(),
  SelfAnalysisStep4(),
  SelfAnalysisStep5(),
];

List<SessionStep> SOLUTION_BUILDING_STEPS = [
  SolutionBuildingStep1(),
  SolutionBuildingStep2(),
  SolutionBuildingStep3(),
];

abstract class SessionStep {
  StepType type = StepType.nothing;
  List<Map<int, String>>? choices;

  Future<void> Run(BuildContext context, String input);
}

class PersonalFeelingsStep1 extends SessionStep {
  @override
  StepType get type => StepType.input;

  @override
  Future<void> Run(BuildContext context, String input) async {
    //add user message
    _addUserMessage(context, input);
    //save feeling
    context.read<ChatCubit>().setFeeling(input);
    //create prompt
    String prompt =
        "The husband's feeling is \"$input\" . Acknowledge the husband's feelings. Your response should be concise, under 200 words. In the end ask if you got it right - must be answerable by \"yes\" or \"no\".'";
    //ask openai
    var response = await chatService.askOpenAI(prompt);
    //add assistant response to conversation history
    _addAssistantMessage(context, response);
    //proceed to step 2
    _nextStep(context);
  }
}

class PersonalFeelingsStep2 extends SessionStep {
  @override
  StepType get type => StepType.polar;

  @override
  List<Map<int, String>>? get choices => [
        {0: "Yes", 1: "No"}
      ];

  @override
  Future<void> Run(BuildContext context, String input) async {
    _addUserMessage(context, _getCondition(input));
    var index = int.parse(input);
    var state = context.read<ChatCubit>().state;
    switch (index) {
      case 0:
        //ask the event that cause this problem
        String prompt =
            "Husband's feeling: ${state.feeling}. Probe one layer deeper. Be a therapist and find out what caused him to feel like this. What happened that he is feeling like this?";
        var response = await chatService.askOpenAI(prompt);
        //add assistant response to conversation history
        _addAssistantMessage(context, response);
        _nextStep(context);
        break;
      case 1:
        //ask again what husband is feeling
        _addAssistantMessage(context, 'What are you feeling?');
        _backToStep(context, 1);
        break;
      default:
    }
  }
}

class PersonalFeelingsStep3 extends SessionStep {
  @override
  StepType get type => StepType.input;

  @override
  Future<void> Run(BuildContext context, String input) async {
    var state = context.read<ChatCubit>().state;
    //add user input
    _addUserMessage(context, input);
    //save event
    context.read<ChatCubit>().setEvent(input);
    //create prompt
    String prompt =
        "This is the response: ${state.event} Analyze his response, sum it up in less than 500 characters. Say sounds like you are feeling ${state.feeling} because ${state.event}, Am I right?";
    //ask openai
    var response = await chatService.askOpenAI(prompt);
    //add assistant response to conversation history
    _addAssistantMessage(context, response);
    _nextStep(context);
  }
}

class PersonalFeelingsStep4 extends SessionStep {
  @override
  StepType get type => StepType.polar;

  @override
  List<Map<int, String>>? get choices => [
        {0: "Yes", 1: "No"}
      ];

  @override
  Future<void> Run(BuildContext context, String input) async {
    _addUserMessage(context, _getCondition(input));
    var index = int.parse(input);
    var state = context.read<ChatCubit>().state;
    switch (index) {
      case 0:
        String prompt =
            "Husband's feeling: ${state.feeling}. Event: ${state.event} . be the best therapist in the world and empathise with his feelings. Say that 'that must be hard.' Make 2 sentences to empathis with his feelings. Then ask 'Did I understand you right?'";
        var response = await chatService.askOpenAI(prompt);
        //add assistant response to conversation history
        _addAssistantMessage(context, response);
        _nextStep(context);
        break;
      case 1:
        //ask again what cause of his feeling
        String prompt =
            "Husband's feeling: ${state.feeling}. Probe one layer deeper. Be a therapist and find out what caused him to feel like this. What happened that he is feeling like this?";
        var response = await chatService.askOpenAI(prompt);
        //add assistant response to conversation history
        _addAssistantMessage(context, response);
        _backToStep(context, 3);
        break;
      default:
    }
  }
}

class PersonalFeelingsStep5 extends SessionStep {
  @override
  StepType get type => StepType.polar;

  @override
  List<Map<int, String>>? get choices => [
        {0: "Yes", 1: "No"}
      ];

  @override
  Future<void> Run(BuildContext context, String input) async {
    _addUserMessage(context, _getCondition(input));
    var index = int.parse(input);
    var state = context.read<ChatCubit>().state;
    switch (index) {
      case 0:
        //Validate his feelings
        //create prompt
        String prompt1 =
            "Validate his feelings. Display 3 or 4 sentences of validation.";
        //ask openai
        var response1 = await chatService.askOpenAI(prompt1);
        //add assistant response to conversation history
        _addAssistantMessage(context, response1);

        //Give him confidence
        //create prompt
        String prompt2 =
            "Give him confidence. Display 3 or 4 sentences of confidence.";
        //ask openai
        var response2 = await chatService.askOpenAI(prompt2);
        //add assistant response to conversation history
        _addAssistantMessage(context, response2);

        //ask about his wife
        //create prompt
        String prompt3 =
            "Asks if the husband know specifics about what his wife's feeling?";
        //ask openai
        var response3 = await chatService.askOpenAI(prompt3);
        //add assistant response to conversation history
        _addAssistantMessage(context, response3);
        //proceed to step 6
        _nextStep(context);
        break;
      case 1:
        //ask again what cause of his feeling
        String prompt =
            "Husband's feeling: ${state.feeling}. Probe one layer deeper. Be a therapist and find out what caused him to feel like this. What happened that he is feeling like this?";
        var response = await chatService.askOpenAI(prompt);
        //add assistant response to conversation history
        _addAssistantMessage(context, response);
        _backToStep(context, 3);
        break;
    }
  }
}

class PersonalFeelingsStep6 extends SessionStep {
  @override
  StepType get type => StepType.multipleChoices;

  @override
  List<Map<int, String>>? get choices => [
        {
          0: 'Yes, I know',
          1: 'No, I don\'t know but I can ask if you help me ask it without getting me in trouble',
          2: 'No, I don\'t know and I don\'t want to ask',
        }
      ];

  @override
  Future<void> Run(BuildContext context, String input) async {
    var index = int.parse(input);
    _addUserMessage(context, _getChoice(input));
    switch (index) {
      case 0:
        //proceed to self analysis steps
        _nextStage(context, SessionStage.selfAnalysis);
        _addAssistantMessage(context, 'What is she feeling?');
        break;
      case 1:
        //proceed to ask wife
        _nextStage(context, SessionStage.talkTowife);
        _addAssistantMessage(context, 'Feature not yet implemented');
        break;
      case 2:
        //create prompt
        String prompt =
            "Just reask this question. Asks if the husband know specifics about what the wife is feeling?. End with this Sorry, I need the wife's perspective to help. Please select one of the following options: ";
        //ask openai
        var response = await chatService.askOpenAI(prompt);
        //add assistant response to conversation history
        _addAssistantMessage(context, response);
        //back to step 6
        _backToStep(context, 6);
        break;
      default:
    }
  }
}

//talk to wife steps
class TalkToWifeStep1 extends SessionStep {
  @override
  StepType get type => StepType.nothing;

  @override
  Future<void> Run(BuildContext context, String input) async {}
}

//self analysis steps
class SelfAnalysisStep1 extends SessionStep {
  @override
  StepType get type => StepType.input;

  @override
  Future<void> Run(BuildContext context, String input) async {
    //add user message
    _addUserMessage(context, input);
    //save wife feeling
    context.read<ChatCubit>().setWifeFeeling(input);
    //create a prompt
    var prompt =
        'Input: $input. ChatGPT Converts his input into wife feelings .. less than 200 characters {feeling}. Sounds like she is feeling {feeling}" .. Am i right?';

    //ask openai
    var response = await chatService.askOpenAI(prompt);
    //add assistant response to conversation history
    _addAssistantMessage(context, response);
    _nextStep(context);
  }
}

class SelfAnalysisStep2 extends SessionStep {
  @override
  StepType get type => StepType.polar;

  @override
  List<Map<int, String>>? get choices => [
        {0: 'Yes', 1: 'No'},
      ];

  @override
  Future<void> Run(BuildContext context, String input) async {
    _addUserMessage(context, _getCondition(input));
    var index = int.parse(input);
    var state = context.read<ChatCubit>().state;
    switch (index) {
      case 0:
        var prompt =
            'Wife feeling: ${state.wifeFeeling}. Probe one layer deeper. Be a therapist and ask him if he knows what caused her to feel like this. What happened that she is feeling like this. ';
        var response = await chatService.askOpenAI(prompt);
        //add assistant response to conversation history
        _addAssistantMessage(context, response);
        //next step
        _nextStep(context);
        break;
      case 1:
        //ask again what is wife feeling
        _addAssistantMessage(context, 'What is she feeling?');
        //back to step 1
        _backToStep(context, 1);
        break;
    }
  }
}

class SelfAnalysisStep3 extends SessionStep {
  @override
  StepType get type => StepType.input;

  @override
  Future<void> Run(BuildContext context, String input) async {
    var state = context.read<ChatCubit>().state;
    //add user message
    _addUserMessage(context, input);
    //save event
    context.read<ChatCubit>().setWifeEvent(input);
    //create a prompt
    var prompt =
        "Wife Event: $input, Wife feeling: ${state.wifeFeeling}. Analyze his response, sum it up in less than 500 characters. Display 'sounds likee she is feeling {feeling} because {event}' .. Yes or no";

    //ask openai
    var response = await chatService.askOpenAI(prompt);

    //add assistant response to conversation history
    _addAssistantMessage(context, response);

    //next step
    _nextStep(context);
  }
}

class SelfAnalysisStep4 extends SessionStep {
  @override
  StepType get type => StepType.polar;

  @override
  List<Map<int, String>>? get choices => [
        {0: 'Yes', 1: 'No'},
      ];

  @override
  Future<void> Run(BuildContext context, String input) async {
    var state = context.read<ChatCubit>().state;
    var index = int.parse(input);
    //add user message
    _addUserMessage(context, _getCondition(input));
    switch (index) {
      case 0:
        //create prompt
        var prompt =
            "Wife feelings: ${state.wifeFeeling} .Be the best therapist in the world and empathise with his feelings when he hears that his wife is feeling {wife feelings}. Say that 'that must be hard for you when she feels {wife feelings}' Make 2 sentences to empathise with his feelings. Then ask 'Did I understand you right? Do you want to add or change anythings'";

        //ask openai
        var response = await chatService.askOpenAI(prompt);

        //add assistant response to conversation history
        _addAssistantMessage(context, response);

        //next step
        _nextStep(context);
        break;
      case 1:
        var prompt =
            'Wife feeling: ${state.wifeFeeling}. Probe one layer deeper. Be a therapist and ask him if he knows what caused her to feel like this. What happened that she is feeling like this. ';
        var response = await chatService.askOpenAI(prompt);
        //add assistant response to conversation history
        _addAssistantMessage(context, response);
        //next step
        _backToStep(context, 3);
        break;
    }
  }
}

class SelfAnalysisStep5 extends SessionStep {
  @override
  StepType get type => StepType.polar;

  @override
  List<Map<int, String>>? get choices => [
        {0: 'Yes', 1: 'No'},
      ];
  @override
  Future<void> Run(BuildContext context, String input) async {
    _addUserMessage(context, _getCondition(input));
    var index = int.parse(input);
    var state = context.read<ChatCubit>().state;
    switch (index) {
      case 0:
        //ask again what is wife feeling
        var prompt =
            'Wife feeling: ${state.wifeFeeling}. Probe one layer deeper. Be a therapist and ask him if he knows what caused her to feel like this. What happened that she is feeling like this. ';
        var response = await chatService.askOpenAI(prompt);
        //add assistant response to conversation history
        _addAssistantMessage(context, response);
        //next step
        _backToStep(context, 3);

        break;
      case 1:
        //next step
        var prompt1 =
            " Husband feeling: ${state.feeling}. Wife feeling: ${state.wifeFeeling}. Validate his and her feelings. Generate 3 or 4 sentences of validation.";
        var response1 = await chatService.askOpenAI(prompt1);
        //add assistant response to conversation history
        _addAssistantMessage(context, response1);
        //next step
        var prompt2 =
            "Husband feeling: ${state.feeling}. Wife feeling: ${state.wifeFeeling}. Give him conflidence that his feelings matter and that our solutions will be created taking into account his feelings as well as her feeelings. We will find a win win solution for both. Display 3 or 4 sentences of confidence. Then display ' give me a few seconds as I think of win-win solutions' ";
        var response2 = await chatService.askOpenAI(prompt2);
        //add assistant response to conversation history
        _addAssistantMessage(context, response2);
        //next step
        _nextStage(context, SessionStage.solutionBuilding);
        //create solution here
        getCurrentStep(SessionStage.solutionBuilding, 1).Run(context, '');
        break;
    }
  }
}

//solution building steps
class SolutionBuildingStep1 extends SessionStep {
  @override
  StepType get type => StepType.nothing;

  @override
  Future<void> Run(BuildContext context, String input) async {
    var state = context.read<ChatCubit>().state;
    var messagesInJson =
        jsonEncode(state.messages.map((message) => message.toJson()).toList());

    var prompt =
        'Conversation history: $messagesInJson. Base on this conversation history create a win win solution for the husband and wife';

    var response = await chatService.askOpenAI(prompt);
    _addAssistantMessage(context, 'Here is a win win solution for you:');
    _addAssistantMessage(context, response);

    _nextStep(context);
  }
}

class SolutionBuildingStep2 extends SessionStep {
  @override
  StepType get type => StepType.rate;

  @override
  Future<void> Run(BuildContext context, String input) async {
    var index = int.parse(input);
    _addUserMessage(context, input);

    if (index != 10) {
      _backToStep(context, 1);
      getCurrentStep(SessionStage.solutionBuilding, 1).Run(context, '');
    } else {
      //closing session
      _nextStep(context);
      //run
      getCurrentStep(SessionStage.solutionBuilding, 3).Run(context, '');

    }
  }
}

class SolutionBuildingStep3 extends SessionStep {
  @override
  StepType get type => StepType.nothing;

  @override
  Future<void> Run(BuildContext context, String input) async {
    var prompt = "Congratulate user for finding a win win solution. Thank user for using the service. Say good bye.";
    var response = await chatService.askOpenAI(prompt);
    _addAssistantMessage(context, response);
  }
}

_addUserMessage(BuildContext context, String message) {
  context
      .read<ChatCubit>()
      .addMessage(ChatMessage(role: "user", content: message));
}

_addAssistantMessage(BuildContext context, String message) {
  context
      .read<ChatCubit>()
      .addMessage(ChatMessage(role: "assistant", content: message));
}

_nextStep(BuildContext context) {
  context.read<ChatCubit>().nextStep();
}

_backToStep(BuildContext context, int step) {
  context.read<ChatCubit>().backToStep(step);
}

_nextStage(BuildContext context, SessionStage stage) {
  context.read<ChatCubit>().nextStage(stage);
}

_getCondition(String input) {
  if (input == '1') return 'No';
  if (input == '0') return 'Yes';
  return 'Error';
}

_getChoice(String input) {
  if (input == '0') return 'Yes, I know';
  if (input == '1') {
    return 'No, I don\'t know but I can ask if you help me ask it without getting me in trouble';
  }
  if (input == '2') return 'No, I don\'t know and I don\'t want to ask';
  return 'Error';
}
