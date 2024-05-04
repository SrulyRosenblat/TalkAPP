import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3/record_mp3.dart';
import '../database_middleware.dart'; 
import 'dart:async'; 

class Chat extends StatefulWidget {
  final String chatId;

  const Chat({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool _isRecording = false;
  String? _recordFilePath;
  late StreamSubscription<Map<String, dynamic>> chatSubscription;
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    requestPermission();
    initializeChat();
  }

  void initializeChat() {
    int chatIdInt = int.parse(widget.chatId);
    chatSubscription = chatStream(4).listen(
      (chatData) {
        setState(() {
          messages = List.generate(chatData['originalTexts'].length, (index) {
            return {
              'textNative': chatData['originalTexts'][index],
              'textForeign': chatData['translatedTexts'][index],
              'soundUrl': chatData['sounds'][index],
              'isAI': chatData['roles'][index] == 'assistant',
              'isFavorited': chatData['favorited'][index],
            };
          });
        });
        print("Received chat data: $chatData");
        print("Messages look like: $messages");
      },
      onError: (error) {
        print("Error retrieving messages: $error");
      }
    );
  }

  @override
  void dispose() {
    chatSubscription.cancel();
    super.dispose();
  }

  void requestPermission() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Microphone permission not granted');
    }
  }

  void startRecord() async {
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp3';
    RecordMp3.instance.start(filePath, (type) {
      setState(() {});
    });
    setState(() {
      _recordFilePath = filePath;
      _isRecording = true;
    });
  }

  void stopRecord() async {
    bool result = RecordMp3.instance.stop();
    if (result && _recordFilePath != null) {
      await Future.delayed(Duration(milliseconds: 500)); 
      _sendAudioFile(_recordFilePath!);
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _sendAudioFile(String filePath) async {
    try {
      int messageId = await sendMessage(int.parse(widget.chatId), filePath);
      print("Message sent with ID: $messageId");
    } catch (e) {
      print("Failed to send message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) => buildMessage(index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FloatingActionButton(
              onPressed: () {
                if (_isRecording) {
                  stopRecord();
                } else {
                  startRecord();
                }
              },
              child: Icon(_isRecording ? Icons.stop : Icons.mic),
              backgroundColor: _isRecording ? Colors.red : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessage(int index) {
    final message = messages[messages.length - 1 - index];
    return ListTile(
      leading: message['isAI'] ? null : IconButton(
        icon: Icon(Icons.play_arrow),
        onPressed: () {}, // Implement playing the message['soundUrl']
      ),
      trailing: message['isAI'] ? IconButton(
        icon: Icon(Icons.play_arrow),
        onPressed: () {}, // Implement playing the message['soundUrl']
      ) : null,
      title: Text(
        message['textNative'],
        style: TextStyle(color: message['isAI'] ? Colors.blue : Colors.black),
      ),
      subtitle: Text(message['textForeign']),
    );
  }
}
