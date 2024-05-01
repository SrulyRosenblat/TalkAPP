import 'package:flutter/material.dart';
import 'package:talk_app/database_middleware.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Chat.dart'; 

class ChatSelector extends StatelessWidget {
  final User user;

  void _createChat(BuildContext context) {
    String userID = user.uid;
    String title = "";
    String language = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('New Chat')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration: const InputDecoration(hintText: "Chat Title"),
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) {
                  language = value;
                },
                decoration: const InputDecoration(hintText: "Chat Language"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                createChat(userID, language, title);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  const ChatSelector({super.key, required this.user});

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createChat(context),
        tooltip: 'New Chat',
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}