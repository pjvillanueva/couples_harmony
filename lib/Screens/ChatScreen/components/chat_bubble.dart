import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class TextBubble extends StatelessWidget {
  final String message;
  final bool isSender;

  const TextBubble({
    super.key,
    required this.message,
    required this.isSender,
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
      backGroundColor: isSender ? Colors.purple[800] : Colors.purple[100],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 300),
        child: Text(
          message,
          style: TextStyle(
              color: isSender ? Colors.white : const Color(0xFF242424)),
        ),
      ),
    );
  }
}
