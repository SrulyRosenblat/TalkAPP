import 'package:flutter/material.dart';
import 'package:talk_app/database_middleware.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:talk_app/widgets/BuildMessage.dart';
// ...

class Favorites extends StatefulWidget {
  final User user;

  const Favorites({super.key, required this.user});

  @override
  FavoritesState createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  late Stream<Map<String, dynamic>> _favoritesStream;

  @override
  void initState() {
    super.initState();
    _favoritesStream = favoriteStream(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: _favoritesStream,
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
            List<dynamic> translatedTexts =
                snapshot.data?['translatedTexts'] ?? [];
            List<dynamic> originalTexts = snapshot.data?['originalTexts'] ?? [];
            List<dynamic> sounds = snapshot.data?['sounds'] ?? [];
            List<dynamic> roles = snapshot.data?['roles'] ?? [];
            List<dynamic> ids = snapshot.data?['messageIDs'] ?? [];
            return ListView.builder(
              itemCount: translatedTexts.length,
              itemBuilder: (context, index) {
                return buildMessage(
                    translatedTexts[index],
                    originalTexts[index],
                    sounds[index],
                    roles[index],
                    true,
                    ids[index] as int,
                    context);
              },
            );
          }
        },
      ),
    );
  }
}
