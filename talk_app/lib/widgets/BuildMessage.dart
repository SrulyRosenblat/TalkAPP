import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:talk_app/database_middleware.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

FlutterTts flutterTts = FlutterTts();

Widget buildMessage(String translatedText, String originalText, String sound,
    String role, bool isFavorite, int id, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onDoubleTap: () {
        print('double tap ${id}, ${isFavorite}');
        favorite(id);
      },
      child: Row(
        mainAxisAlignment: role == "assistant"
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (role == "user")
            IconButton(
              icon: Icon(Icons.volume_up),
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
                      ? Color(0xFF8A8AFF)
                      : Color(0xFF7AA7FF),
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
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    SizedBox(height: 4),
                    Text(
                      translatedText,
                      style: TextStyle(fontSize: 14.0, color: Colors.white70),
                    ),
                    isFavorite
                        ? SizedBox(
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
                    ? Icon(Icons.favorite, color: Colors.red)
                    : Container(),
              ),
            ],
          ),
          if (role == "assistant")
            IconButton(
              icon: Icon(Icons.volume_up),
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
