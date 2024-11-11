import 'package:couples_harmony/Models/Prompts/session_step.dart';
import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({super.key, required this.step, this.onSubmit});

  final SessionStep step;
  final Function(String)? onSubmit;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

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
                    borderSide: const BorderSide(color: Colors.pinkAccent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Colors.pinkAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Colors.pink),
                  ),
                  fillColor: Colors.pink[50],
                  filled: true,
                  labelText: '',
                ),
                style: const TextStyle(color: Colors.pinkAccent),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.indigo, size: 35),
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
              backgroundColor: Colors.pink[100],
              shape: const StadiumBorder(
                  side: BorderSide(color: Colors.transparent)),
              onSelected: (val) => onSubmit?.call('0'),
            ),
            const SizedBox(width: 10),
            InputChip(
              label: const Text('No'),
              backgroundColor: Colors.pink[100],
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
            children:
                List<Widget>.generate(step.choices?.first.length ?? 0, (index) {
              final choiceMap = step.choices?.first;
              final choiceText = choiceMap?[index];
              return InputChip(
                label: Text(choiceText ?? ''),
                backgroundColor: Colors.pink[100],
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
  }
}
