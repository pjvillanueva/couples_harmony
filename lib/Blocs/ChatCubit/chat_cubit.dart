import 'package:couples_harmony/Models/Prompts/session_step.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessage {
  String role;
  String content;
  String? code;

  ChatMessage({required this.role, required this.content, this.code});

  toJson() => {'role': role, 'content': content};
}

// ignore: must_be_immutable
class ChatState extends Equatable {
  ChatState(
      {required this.messages,
      required this.currentStep,
      required this.sessionStage,
      required this.isLoading,
      required this.feeling,
      required this.wifeFeeling,
      required this.event,
      required this.wifeEvent});

  List<ChatMessage> messages;
  int currentStep;
  SessionStage sessionStage;
  bool isLoading;
  String feeling;
  String wifeFeeling;
  String event;
  String wifeEvent;

  @override
  List<Object> get props => [
        messages,
        currentStep,
        sessionStage,
        isLoading,
        feeling,
        wifeFeeling,
        event,
        wifeEvent
      ];

  ChatState copyWith(
      {List<ChatMessage>? messages,
      int? currentStep,
      SessionStage? sessionStage,
      bool? isLoading,
      String? feeling,
      String? wifeFeeling,
      String? event,
      String? wifeEvent}) {
    return ChatState(
        messages: messages ?? this.messages,
        currentStep: currentStep ?? this.currentStep,
        sessionStage: sessionStage ?? this.sessionStage,
        isLoading: isLoading ?? this.isLoading,
        feeling: feeling ?? this.feeling,
        wifeFeeling: wifeFeeling ?? this.wifeFeeling,
        event: event ?? this.event,
        wifeEvent: wifeEvent ?? this.wifeEvent);
  }
}

class ChatCubit extends Cubit<ChatState> {
  ChatCubit()
      : super(ChatState(
            isLoading: false,
            messages: [
              ChatMessage(role: "assistant", content: "What are you feeling?"),
            ],
            sessionStage: SessionStage.personalFeelings,
            currentStep: 1,
            feeling: '',
            wifeFeeling: '',
            event: '',
            wifeEvent: ''));

  nextStep() {
    emit(state.copyWith(currentStep: state.currentStep + 1));
  }

  nextStage(SessionStage stage) {
    emit(state.copyWith(sessionStage: stage, currentStep: 1));
  }

  backToStep(int stepToReturn) {
    emit(state.copyWith(currentStep: stepToReturn));
  }

  addMessage(ChatMessage message) {
    emit(state.copyWith(messages: [...state.messages, message]));
  }

  setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  setFeeling(String feeling) {
    emit(state.copyWith(feeling: feeling));
  }

  setWifeFeeling(String wifeFeeling) {
    emit(state.copyWith(wifeFeeling: wifeFeeling));
  }

  setEvent(String event) {
    emit(state.copyWith(event: event));
  }

  setWifeEvent(String event) {
    emit(state.copyWith(wifeEvent: event));
  }

  resetChat() {
    emit(state.copyWith(
        isLoading: false,
        messages: [
          ChatMessage(role: "assistant", content: "What are you feeling?"),
        ],
        sessionStage: SessionStage.personalFeelings,
        currentStep: 1,
        feeling: '',
        wifeFeeling: '',
        event: '',
        wifeEvent: ''));
  }
}
