import 'package:couples_harmony/Blocs/ChatCubit/chat_cubit.dart';
import 'package:couples_harmony/Models/Prompts/session_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({super.key, required this.step, this.onSubmit});

  final SessionStep step;
  final Function(String)? onSubmit;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    final state = context.read<ChatCubit>().state;
    if (!state.isLoading) {
      if (step.type == StepType.input) {
        return Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    fillColor: Colors.blue[50],
                    filled: true,
                    labelText: '',
                  ),
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send,
                    color: Color.fromARGB(255, 5, 49, 100), size: 35),
                onPressed: () {
                  onSubmit?.call(_controller.text);
                  _controller.clear();
                },
              ),
            ],
          ),
        );
      } else if (step.type == StepType.polar) {
        return Container(
          padding: const EdgeInsets.all(20),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputChip(
                label: const Text('Yes'),
                backgroundColor: Colors.blue[100],
                shape: const StadiumBorder(
                    side: BorderSide(color: Colors.transparent)),
                onSelected: (val) => onSubmit?.call('0'),
              ),
              const SizedBox(width: 10),
              InputChip(
                label: const Text('No'),
                backgroundColor: Colors.blue[100],
                shape: const StadiumBorder(
                    side: BorderSide(color: Colors.transparent)),
                onSelected: (val) => onSubmit?.call('1'),
              ),
            ],
          ),
        );
      } else if (step.type == StepType.multipleChoices) {
        return Container(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List<Widget>.generate(step.choices?.first.length ?? 0,
                  (index) {
                final choiceMap = step.choices?.first;
                final choiceText = choiceMap?[index];
                return InputChip(
                  label: Text(choiceText ?? ''),
                  backgroundColor: Colors.blue[100],
                  shape: const StadiumBorder(
                    side: BorderSide(color: Colors.transparent),
                  ),
                  onSelected: (isSelected) {
                    onSubmit?.call(index.toString());
                  },
                );
              }),
            ));
      } else if (step.type == StepType.rate) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List<Widget>.generate(10, (index) {
              final rateValue = (index + 1).toString();
              return InputChip(
                label: Text(rateValue),
                backgroundColor: Colors.blue[100],
                shape: const StadiumBorder(
                  side: BorderSide(color: Colors.transparent),
                ),
                onSelected: (isSelected) {
                  onSubmit?.call(rateValue);
                },
              );
            }),
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Harmony is typing...'),
        ),
      );
    }
  }
}
