import 'package:flutter/material.dart';
import 'Chat.dart'; 

class ChatSelector extends StatelessWidget {
  const ChatSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String?>> chats = [
      {
        'chatId': '1',
        'title': 'Chat 1',
        'subtitle': 'Last message in this chat...',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Chat'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            title: Text(chat['title'] ?? 'No title'), // Providing a fallback value for null
            subtitle: Text(chat['subtitle'] ?? 'No subtitle'), // Providing a fallback value for null
            onTap: () {
              if (chat['chatId'] != null) { // Checking for null before navigating
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Chat(chatId: chat['chatId']!),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}