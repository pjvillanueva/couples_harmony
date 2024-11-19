import 'package:couples_harmony/Models/Prompts/default_prompts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromptCubit extends Cubit<Map<String, String>> {
  PromptCubit() : super(DEFAULT_PROMPT);

  // Method to retrieve a specific prompt
  String? getPrompt(String key) {
    return state[key];
  }

  // Method to edit a specific prompt
  void editPrompt(String key, String newValue) {
    if (state.containsKey(key)) {
      final updatedPrompts = Map<String, String>.from(state)..[key] = newValue;
      emit(updatedPrompts);
    }
    //TODO: Update prompts too in db
    

  }

  //Method to retrieve prompts from db
  void initialize() {
    //TODO: retrive prompts from db
    emit(DEFAULT_PROMPT);
  }
}
