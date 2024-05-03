import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../database_middleware.dart';

class Chat extends StatefulWidget {
  final String chatId;

  const Chat({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late FlutterSoundRecorder _recorder;
  bool _isRecording = false;
  bool _isRecorderInitialized = false;
  String? _recordedUrl;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Microphone permission not granted');
    }
    _recorder = FlutterSoundRecorder();
    await _recorder.openRecorder();
    _isRecorderInitialized = true;
  }

  void _toggleRecording() async {
    if (!_isRecording && _isRecorderInitialized) {
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/temp_record.mp4'; // Using MP4 container
      await _recorder.startRecorder(
        toFile: path,
        codec: Codec.aacMP4, // AAC codec in an MP4 container
      );
      setState(() {
        _isRecording = true;
      });
    } else {
      final path = await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
        _recordedUrl = path; // Save the recorded path
        debugPrint('Recorded path: $_recordedUrl');
        _sendAudioFile(_recordedUrl); // Handle the recorded file
      });
    }
  }

  Future<void> _sendAudioFile(String? filePath) async {
    if (filePath != null && filePath.isNotEmpty) {
      try {
        int messageId = await sendMessage(int.parse(widget.chatId), filePath);
        print("Message sent with ID: $messageId");
      } catch (e) {
        print("Failed to send message: $e");
      }
    }
  }

  @override
  void dispose() {
    if (_isRecorderInitialized) {
      _recorder.closeRecorder();
    }
    super.dispose();
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
            const Text("Press the button to start recording"),
            FloatingActionButton(
              onPressed: _toggleRecording,
              child: Icon(_isRecording ? Icons.stop : Icons.mic),
              backgroundColor: _isRecording ? Colors.red : Colors.blue,
            ),
            if (_recordedUrl != null) Text('Recorded file: $_recordedUrl')
          ],
        ),
      ),
    );
  }
}
