import 'package:flutter/material.dart';
import 'package:talk_app/database_middleware.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

class Favorites extends StatefulWidget {
  final User user;

  const Favorites({super.key, required this.user});

  @override
  FavoritesState createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  late Future<Map<String, dynamic>> _favoritesFuture;
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = getFavorites(widget.user.uid);
    flutterTts = FlutterTts();
  }

  void _speak(String text) async {
    await flutterTts.speak(text);
  }

  Widget buildMessage(String translatedTexts, String originalTexts, String sounds, String roles) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: roles == "assistant" ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (roles == "user") 
            IconButton(
              icon: Icon(Icons.volume_up),
              color: Colors.black,
              onPressed: () => _speak(translatedTexts),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color: roles == "assistant" ? Color(0xFF8A8AFF) : Color(0xFF7AA7FF),
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
                  translatedTexts,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  originalTexts,
                  style: TextStyle(fontSize: 14.0, color: Colors.white70),
                ),
              ],
            ),
          ),
          if (roles == "assistant") 
            IconButton(
              icon: Icon(Icons.volume_up),
              color: Colors.black,
              onPressed: () => _speak(translatedTexts),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching favorites: ${snapshot.error}'),
            );
          } else {
            List<dynamic> translatedTexts = snapshot.data?['translatedTexts'] ?? [];
            List<dynamic> originalTexts = snapshot.data?['originalTexts'] ?? [];
            List<dynamic> sounds = snapshot.data?['sounds'] ?? [];
            List<dynamic> roles = snapshot.data?['roles'] ?? [];
            return ListView.builder(
              itemCount: translatedTexts.length,
              itemBuilder: (context, index) {
                return buildMessage(translatedTexts[index], originalTexts[index], sounds[index], roles[index]);
              },
            );
          }
        },
      ),
    );
  }
}