import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Account extends StatelessWidget {
  void _createChat(BuildContext context) {
    String userID = user.uid;
    String title = "";
    String language = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('New Chat')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration: const InputDecoration(hintText: "Chat Title"),
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) {
                  language = value;
                },
                decoration: const InputDecoration(hintText: "Chat Language"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  
  final User user;
  final FirebaseAuth auth;

  const Account({super.key, required this.user, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/userimage.png', height: 100),
          Text(
            user.displayName ?? "Anonymous",
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          //Text(user.uid),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _createChat(context);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF7AA7FF)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const SizedBox(
              width: 300, // Adjust the width of the button
              child: Text(
                'Translation History',
                textAlign: TextAlign.center, // Center align the text
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Select your language",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              _createChat(context);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF7AA7FF)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const SizedBox(
              width: 300, // Adjust the width of the button
              child: Text(
                'English',
                textAlign: TextAlign.center, // Center align the text
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Select language to practice",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              _createChat(context);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF7AA7FF)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const SizedBox(
              width: 300, // Adjust the width of the button
              child: Text(
                'English',
                textAlign: TextAlign.center, // Center align the text
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 124),
          ElevatedButton(
            onPressed: auth.signOut,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFF7A7A)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const SizedBox(
              width: 300, // Adjust the width of the button
              child: Text(
                'Log Out',
                textAlign: TextAlign.center, // Center align the text
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
