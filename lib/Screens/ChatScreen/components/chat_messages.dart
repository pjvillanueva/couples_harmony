import 'package:couples_harmony/Blocs/ChatCubit/chat_cubit.dart';
import 'package:couples_harmony/Screens/ChatScreen/components/chat_bubble.dart';
import 'package:couples_harmony/Screens/ChatScreen/components/typing_indicator.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  final List<ChatMessage> messages;
  final bool messageInProcess;

  const ChatMessages(
      {super.key, required this.messages, required this.messageInProcess});

  @override
  ChatMessagesState createState() => ChatMessagesState();

  toJson() => {'messages': messages, 'messageInProcess': messageInProcess};
}

class ChatMessagesState extends State<ChatMessages> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void didUpdateWidget(ChatMessages oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length ||
        widget.messageInProcess != oldWidget.messageInProcess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int dynamicMessagesCount =
        widget.messages.length + (widget.messageInProcess ? 1 : 0);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 24),
      reverse: false,
      shrinkWrap: true,
      itemCount: dynamicMessagesCount,
      itemBuilder: (context, index) {
        if (widget.messageInProcess && index == widget.messages.length) {
          return const TypingIndicator();
        }

        if (index < widget.messages.length) {
          final message = widget.messages[index];

          return TextBubble(
            message: message.content,
            isSender: message.role == "user" ? true : false,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
