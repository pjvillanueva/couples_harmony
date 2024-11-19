// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:couples_harmony/Blocs/ChatCubit/chat_cubit.dart';
import 'package:couples_harmony/Blocs/PromptCubit/prompt_cubit.dart';
import 'package:couples_harmony/Helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final String apiKey = OPEN_AI_API_KEY;

  Future<String> askOpenAI(BuildContext context, String promptCode,
      {bool addConversataion = false}) async {
    //set loading to true
    context.read<ChatCubit>().setLoading(true);
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4',
        'messages': [
          {
            'role': 'system',
            'content':
                'You are a compassionate and insightful marriage counselor, here to help couples navigate relationship challenges with empathy and understanding. Reply as a friend'
          },
          {'role': 'user', 'content': getPrompt(context, promptCode, addConversataion)},
        ],
        'temperature': 0.7,
        'max_tokens': 1000,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      //set loading to false
      context.read<ChatCubit>().setLoading(false);
      return data['choices'][0]['message']['content'];
    } else {
      return 'Error has occurred';
    }
  }
}

String getPrompt(
    BuildContext context, String promptCode, bool addConversation) {
  var chatState = context.read<ChatCubit>().state;

  final husbandFeeling = chatState.feeling;
  final husbandEvent = chatState.event;

  final wifeFeeling = chatState.wifeFeeling;
  final wifeEvent = chatState.wifeEvent;

  final components = <String>[];

  if (addConversation) {
    var messagesInJson = jsonEncode(
        chatState.messages.map((message) => message.toJson()).toList());

    components.add(messagesInJson);
  } else {
    if (husbandFeeling.isNotEmpty) {
      components.add('Husband feeling: $husbandFeeling');
    }
    if (husbandEvent.isNotEmpty) {
      components.add('because of this event: $husbandEvent.');
    }
    if (wifeFeeling.isNotEmpty) {
      components.add('Wife feeling: $wifeFeeling');
    }
    if (wifeEvent.isNotEmpty) {
      components.add('because of this event: $wifeEvent');
    }
  }

  final prompt = context.read<PromptCubit>().getPrompt(promptCode) ?? '';

  return components.join(' ') + prompt;
}
