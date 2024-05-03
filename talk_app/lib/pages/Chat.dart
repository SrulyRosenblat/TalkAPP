import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../database_middleware.dart';


class Chat extends StatefulWidget {
  final String chatId;

  const Chat({super.key, required this.chatId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late List<Map<String, dynamic>> messages;
  late stt.SpeechToText _speech;
  late FlutterTts flutterTts;
  ValueNotifier<bool> isListening = ValueNotifier(false);
  late StreamSubscription<Future<Map<String, dynamic>>> chatSubscription; 

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    flutterTts = FlutterTts();
    initializeChat();
  }

  void initializeChat() {
    int chatIdInt = int.parse(widget.chatId);
    chatSubscription = chatStream(2).listen(
      (chatDataFuture) {
        chatDataFuture.then((chatData) {
          print("Received chat data: $chatData");
          setState(() {
            if (chatData['originalTexts'] != null && chatData['originalTexts'].isNotEmpty) {
              messages = List.generate(chatData['originalTexts'].length, (index) {
                return {
                  'textNative': chatData['originalTexts'][index],
                  'textForeign': chatData['translatedTexts'][index],
                  'soundUrl': chatData['sounds'][index],
                  'isAI': chatData['roles'][index] == 'AI',
                  'isFavorited': chatData['favorited'][index]
                };
              });
            } else {
              messages = [];
            }
            print("CURRENT SMS retrieval: $messages");
          });
        }).catchError((error) {
          print("Error retrieving messages: ${error.toString()}");
        });
      },
    );
  }

  @override
  void dispose() {
    chatSubscription.cancel();
    super.dispose();
  }

  void _speak(String text) async {
    await flutterTts.speak(text);
  }

  void _listen() async {
    var microphoneStatus = await Permission.microphone.status;
    if (!microphoneStatus.isGranted) {
      await Permission.microphone.request();
    }

    if (await Permission.microphone.isGranted) {
      if (!isListening.value) {
        bool available = await _speech.initialize();
        if (available) {
          isListening.value = true;
          _speech.listen(
            onResult: (val) {
              if (val.finalResult) { 
                setState(() {
                  messages.add({
                    'textNative': val.recognizedWords,
                    'textForeign': 'Translation pending...',
                    'soundUrl': "",
                    'isAI': false,
                    'isFavorited': ""
                  });
                  print('Added message: ${val.recognizedWords}');
                });
              }
            },
          );
        }
      } else {
        isListening.value = false;
        _speech.stop();
      }
    } else {
      print("MIC ACCESS NOT GRANTED ;(");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(
        'Chat',
        style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0031AF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(child: buildMessages()),
          const Divider(height: 1),
          buildMicrophoneInputArea(), // Now using ValueListenableBuilder
        ],
      ),
    );
  }

  Widget buildMessages() {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) => buildMessage(index),
    );
  }

  Widget buildMessage(int index) {
    final message = messages[messages.length - 1 - index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: message['isAI'] ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (!message['isAI']) 
            IconButton(
              icon: Icon(Icons.volume_up),
              color: Colors.black,
              onPressed: () => _speak(message['textNative']),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color: message['isAI'] ? Color(0xFF8A8AFF) : Color(0xFF7AA7FF),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  spreadRadius: 1,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['textNative'],
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  message['textForeign'],
                  style: TextStyle(fontSize: 14.0, color: Colors.white70),
                ),
              ],
            ),
          ),
          if (message['isAI']) 
            IconButton(
              icon: Icon(Icons.volume_up),
              color: Colors.black,
              onPressed: () => _speak(message['textNative']),
            ),
        ],
      ),
    );
  }

  Widget buildMicrophoneInputArea() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: ValueListenableBuilder<bool>(
          valueListenable: isListening,
          builder: (_, isListening, __) {
            return FloatingActionButton(
              onPressed: _listen,
              backgroundColor: isListening ? Colors.red : Colors.blue,
              child: Icon(isListening ? Icons.mic_off : Icons.mic),
            );
          },
        ),
      ),
    );
  }
}
