import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Account extends StatelessWidget {
  final User user;
  final FirebaseAuth auth;

  const Account({super.key, required this.user, required this.auth});

  void _changeLanguage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedLanguage = 'English';
        return AlertDialog(
          title: const Center(child: Text('Select a Language')),
          content: DropdownButtonFormField<String>(
            isExpanded: true,
            icon: const Icon (
              Icons.arrow_drop_down_circle,
              color: Color(0xFF7AA7FF),
            ),
            value: selectedLanguage,
            onChanged: (String? newValue) {
              selectedLanguage = newValue!;
            },
            items: <String>['English', 'Spanish', 'French', 'German', 'Hebrew', 'Ukrainian']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF7AA7FF)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const SizedBox(
              width: 300,
              child: Text(
                'Translation History',
                textAlign: TextAlign.center,
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
              _changeLanguage(context);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF7AA7FF)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const SizedBox(
              width: 300,
              child: Text(
                'English',
                textAlign: TextAlign.center,
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
              _changeLanguage(context);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF7AA7FF)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const SizedBox(
              width: 300,
              child: Text(
                'English',
                textAlign: TextAlign.center,
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
              width: 300,
              child: Text(
                'Log Out',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
