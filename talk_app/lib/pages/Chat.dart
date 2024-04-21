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
      {
        'textNative': 'Estoy muy bien, ¿y túfffff?',
        'textForeign': 'I am doing great, youfffff?',
        'isAI': true,
      },
      {
        'textNative': 'Hola, qué tallll',
        'textForeign': 'Hey, how are yoiiiiu',
        'isAI': false,
      },
      {
        'textNative': 'Hola, qué tal;;;;;',
        'textForeign': 'Hey, how are you;;;;;',
        'isAI': false,
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
                bool isAI = message['isAI'];
                return Row(
                  mainAxisAlignment: isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
                  children: [
                    if (!isAI) ...[
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () {
                          // Play user's message
                        },
                      ),
                    ],
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6,
                      ),
                      decoration: BoxDecoration(
                        color: isAI ? Color(0xFF8A8AFF) : Color(0xFF7AA7FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: isAI ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['textNative'],
                            style: TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                          Text(
                            message['textForeign'],
                            style: TextStyle(fontSize: 14.0, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    if (isAI) ...[
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () {
                          // Play AI's message
                        },
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
          const Divider(height: 1),
          _buildMicrophoneInputArea(), 
        ],
      ),
    );
  }


  Widget _buildMicrophoneInputArea() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: FloatingActionButton(
          onPressed: () {
            // Implement your speech input handling
          },
          child: const Icon(Icons.mic),
        ),
      ),
    );
  }
}
