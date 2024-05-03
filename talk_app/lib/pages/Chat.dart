import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3/record_mp3.dart';
import '../database_middleware.dart'; 

class Chat extends StatefulWidget {
  final String chatId;

  const Chat({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool _isRecording = false;
  String? _recordFilePath;

  @override
  void initState() {
    super.initState();
    requestPermission();
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
      await Future.delayed(Duration(milliseconds: 500));  // Allow some time for the file to finalize
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_isRecording ? "Recording..." : "Tap the mic to start recording"),
            FloatingActionButton(
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
            if (_recordFilePath != null) Text('Recorded file: $_recordFilePath')
          ],
        ),
      ),
    );
  }
}
