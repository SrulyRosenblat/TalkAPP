import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Account extends StatelessWidget {
  final User user;
  final FirebaseAuth auth;

  const Account({super.key, required this.user, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            user.displayName ?? "Anonymous",
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          //Text(user.uid),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              auth.signOut;
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
          const SizedBox(height: 36),
          const Text(
            "Select your language",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              auth.signOut;
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
          const SizedBox(height: 136),
          ElevatedButton(
            onPressed: () {
              auth.signOut;
            },
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
