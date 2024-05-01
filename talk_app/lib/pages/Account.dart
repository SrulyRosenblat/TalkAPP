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
          Text(user.displayName ?? "Anonymous"),
          Text(user.uid),
          ElevatedButton(onPressed: auth.signOut, child: Text("Log Out"))
        ],
      ),
    );
  }
}
