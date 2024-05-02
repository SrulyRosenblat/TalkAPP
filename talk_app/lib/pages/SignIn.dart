import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
      GoogleProvider(
          clientId:
              '955906548828-45uo9e260j1oi4cmqt8gs051etnl6hjp.apps.googleusercontent.com'),
    ]);

    // final providers = [EmailAuthProvider()];

    return SignInScreen(
        // providers: providers,
        );
  }
}
