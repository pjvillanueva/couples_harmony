import 'dart:convert';
import 'package:couples_harmony/Helpers/constants.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final String apiKey = OPEN_AI_API_KEY;

  Future<String> askOpenAI(String prompt) async {
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
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.7,
        'max_tokens': 1000,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      return 'Error has occurred';
    }
  }
}
