import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class TextBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  final String code;

  const TextBubble({
    super.key,
    required this.message,
    required this.isSender,
    this.code = '',
  });

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      elevation: 0,
      clipper: ChatBubbleClipper5(
          type: isSender ? BubbleType.sendBubble : BubbleType.receiverBubble,
          radius: 24),
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      margin: const EdgeInsets.all(10),
      backGroundColor: isSender ? const Color.fromARGB(255, 13, 109, 187) : const Color.fromARGB(255, 164, 203, 235),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: code.isNotEmpty,
                child: Text(code,
                    style: const TextStyle(
                        fontSize: 10, color: Colors.indigo))),
            Text(
              message,
              style: TextStyle(
                  color: isSender ? Colors.white : const Color(0xFF242424)),
            ),
          ],
        ),
      ),
    );
  }
}
