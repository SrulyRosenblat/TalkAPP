import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String chatId;

  const Chat({super.key, required this.chatId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late List<Map<String, dynamic>> messages; 

  @override
  void initState() {
    super.initState();
    messages = [
      {
        'textNative': 'Hola, qué tal',
        'textForeign': 'Hey, how are you',
        'isAI': false,
      },
      {
        'textNative': 'Estoy muy bien, ¿y tú?',
        'textForeign': 'I am doing great, you?',
        'isAI': true,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                return ListTile(
                  title: Text(
                    message['textNative'],
                    style: TextStyle(
                      color: message['isAI'] ? Colors.grey : Colors.blue,
                    ),
                  ),
                  subtitle: Text(message['textForeign']),
                  trailing: IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () {
                      // Placeholder function for play message
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          _buildMessageInputArea(), 
        ],
      ),
    );
  }

  Widget _buildMessageInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: () {
              // ??
            },
          ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message',
              ),
              // handle message
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              // send message
            },
          ),
        ],
      ),
    );
  }
}
