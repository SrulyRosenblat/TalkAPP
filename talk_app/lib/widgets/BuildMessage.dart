import 'package:flutter/material.dart';
import 'package:talk_app/database_middleware.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

FlutterTts flutterTts = FlutterTts();

Widget buildMessage(String translatedText, String originalText, String sound,
    String role, bool isFavorite, int id, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onDoubleTap: () {
        print('double tap $id, $isFavorite');
        favorite(id);
      },
      child: Row(
        mainAxisAlignment: role == "assistant"
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (role == "user")
            IconButton(
              icon: const Icon(Icons.volume_up),
              color: Colors.black,
              onPressed: () => playAudio(sound, originalText),
            ),
          Stack(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  color: role == "assistant"
                      ? const Color(0xFF8A8AFF)
                      : const Color(0xFF7AA7FF),
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
                      originalText,
                      style: const TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      translatedText,
                      style: const TextStyle(fontSize: 14.0, color: Colors.white70),
                    ),
                    isFavorite
                        ? const SizedBox(
                            height: 30,
                          )
                        : Container()
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: isFavorite
                    ? const Icon(Icons.favorite, color: Colors.red)
                    : Container(),
              ),
            ],
          ),
          if (role == "assistant")
            IconButton(
              icon: const Icon(Icons.volume_up),
              color: Colors.black,
              // onPressed: () => _speak(translatedTexts),
              onPressed: () => playAudio(sound, originalText),
            ),
        ],
      ),
    ),
  );
}

playAudio(String audioLink, String text) async {
  final player = AudioPlayer();
  await player.play(UrlSource(audioLink)).catchError((error) {
    print('Error playing audio: $error');
    _speak(text);
  });
}

void _speak(String text) async {
  await flutterTts.speak(text);
}
