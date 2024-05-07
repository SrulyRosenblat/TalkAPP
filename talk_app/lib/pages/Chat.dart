import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:talk_app/widgets/BuildMessage.dart';
import '../database_middleware.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class Chat extends StatefulWidget {
  final int chatId;

  const Chat({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool _isRecording = false;
  String? _recordFilePath;
  late StreamSubscription<Map<String, dynamic>> chatSubscription;
  List<Map<String, dynamic>> messages = [];
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    requestPermission();
    initializeChat();
  }

  void initializeChat() {
    int chatIdInt = widget.chatId;
    print('id $chatIdInt');
    // Replace 4 with chatIdInt
    chatSubscription = chatStream(chatIdInt).listen((chatData) {
      setState(() {
        print("LOOK ->$chatData");
        messages = List.generate(chatData['originalTexts'].length, (index) {
          return {
            'textNative': chatData['originalTexts'][index],
            'textForeign': chatData['translatedTexts'][index],
            'soundUrl': chatData['sounds'][index],
            'role': chatData['roles'][index],
            'isFavorited': chatData['favorited'][index],
            'id': chatData['messageIDs'][index]
          };
        });
      });
      print("Received chat data: $chatData");
      print("Messages look like: $messages");
    }, onError: (error) {
      print("Error retrieving messages: $error");
    });
  }

  @override
  void dispose() {
    chatSubscription.cancel();
    audioPlayer.dispose();
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
    String filePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp3';
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
      await Future.delayed(const Duration(milliseconds: 500));
      _sendAudioFile(_recordFilePath!);
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _sendAudioFile(String filePath) async {
    try {
      // Replace 4 with: int.parse(widget.chatId)
      int messageId = await sendMessage(widget.chatId, filePath);
      print("Message sent with ID: $messageId");
    } catch (e) {
      print("Failed to send message: $e");
    }
  }

  void playSound(String url) async {
    await audioPlayer.play(UrlSource(url));
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
              itemCount: messages.length,
              itemBuilder: (context, index) => buildMessage(
                  messages[index]['textForeign'],
                  messages[index]['textNative'],
                  messages[index]['soundUrl'],
                  messages[index]['role'],
                  messages[index]['isFavorited'],
                  messages[index]['id'],
                  context),
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
              backgroundColor: _isRecording ? Colors.red : Colors.blue,
              child: Icon(_isRecording ? Icons.stop : Icons.mic),
            ),
          ),
        ],
      ),
    );
  }

//   Widget buildMessage(int index) {
//     final message = messages[messages.length - 1 - index];
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment:
//             message['isAI'] ? MainAxisAlignment.start : MainAxisAlignment.end,
//         children: [
//           if (!message['isAI'])
//             IconButton(
//               icon: Icon(Icons.volume_up),
//               color: Colors.black,
//               onPressed: () => playSound(message['soundUrl']),
//             ),
//           GestureDetector(
//             onDoubleTap: () {
//               print('double tap ${message['id']}, ${message['isFavorited']}');
//               favorite(message['id']);
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.7,
//               ),
//               decoration: BoxDecoration(
//                 color: message['isAI'] ? Color(0xFF8A8AFF) : Color(0xFF7AA7FF),
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     blurRadius: 3,
//                     spreadRadius: 1,
//                     color: Colors.black.withOpacity(0.1),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     message['textNative'],
//                     style: TextStyle(fontSize: 16.0, color: Colors.white),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     message['textForeign'],
//                     style: TextStyle(fontSize: 14.0, color: Colors.white70),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (message['isAI'])
//             IconButton(
//               icon: Icon(Icons.volume_up),
//               color: Colors.black,
//               onPressed: () => playSound(message['soundUrl']),
//             ),
//         ],
//       ),
//     );
//   }
}
