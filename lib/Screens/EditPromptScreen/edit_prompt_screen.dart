import 'package:couples_harmony/Blocs/ChatCubit/chat_cubit.dart';
import 'package:couples_harmony/Blocs/PromptCubit/prompt_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPromptsScreen extends StatefulWidget {
  const EditPromptsScreen({super.key});

  @override
  State<EditPromptsScreen> createState() => _EditPromptsScreenState();
}

class _EditPromptsScreenState extends State<EditPromptsScreen> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    final prompts = context.read<PromptCubit>().state;

    // Initialize controllers for each prompt
    prompts.forEach((key, value) {
      _controllers[key] = TextEditingController(text: value);
    });
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitChanges() {
    final promptCubit = context.read<PromptCubit>();
    final chatCubit = context.read<ChatCubit>();

    // Update all prompts in the cubit
    _controllers.forEach((key, controller) {
      promptCubit.editPrompt(key, controller.text);
    });

    //rest chat
    chatCubit.resetChat();

    //pop screen
    Navigator.pop(context);

    // Optionally show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Prompts updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Edit Prompts', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 5, 49, 100),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<PromptCubit, Map<String, String>>(
        builder: (context, prompts) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: prompts.keys.length,
                  itemBuilder: (context, index) {
                    final key = prompts.keys.elementAt(index);
                    final controller = _controllers[key]!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: controller,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: key,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 5, 49, 100),
                        padding: const EdgeInsets.all(20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: _submitChanges,
                      child: const Text('SUBMIT CHANGES',
                          style:
                              TextStyle(fontSize: 12, color: Colors.white)))),
            ],
          );
        },
      ),
    );
  }
}
