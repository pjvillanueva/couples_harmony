import 'package:couples_harmony/Blocs/ChatCubit/chat_cubit.dart';
import 'package:couples_harmony/Screens/ChatScreen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const CouplesHarmony());
}

class CouplesHarmony extends StatelessWidget {
  const CouplesHarmony({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Therapy Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: BlocProvider(
        create: (context) => ChatCubit(),
        child: const ChatScreen(),
      ),
    );
  }
}
