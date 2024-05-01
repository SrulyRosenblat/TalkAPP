import 'package:flutter/material.dart';
import 'package:talk_app/database_middleware.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Chat.dart'; 

class ChatSelector extends StatelessWidget {
  final User user;

  void _createChat(BuildContext context) {
    String userID = user.uid;
    String title = "";
    String language = "English";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Create New Chat')),
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
              DropdownButtonFormField<String>(
                isExpanded: true,
                icon: const Icon (
                  Icons.arrow_drop_down_circle,
                  color: Color(0xFF7AA7FF),
                ),
                value: language,
                onChanged: (String? newValue) {
                  language = newValue!;
                },
                items: <String>['English', 'Spanish', 'French', 'German', 'Hebrew', 'Ukrainian']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF7AA7FF), // Blue background color
              borderRadius: BorderRadius.circular(8), // Rounded rectangle corners
            ),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            child: ListTile(
            title: Text(chat['title'] ?? 'No title', style: const TextStyle(color: Colors.white, fontSize: 24)), // Providing a fallback value for null
            subtitle: Text(chat['subtitle'] ?? 'No subtitle', style: const TextStyle(color: Colors.white)), // Providing a fallback value for null
            onTap: () {
              if (chat['chatId'] != null) { // Checking for null before navigating
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Chat(chatId: chat['chatId']!),
                  ),
                );
              }
            },
          ));
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