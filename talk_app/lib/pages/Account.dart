import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';
import 'package:talk_app/pages/SettingModel/Theme.dart';

class Account extends StatelessWidget {
  final User user;
  final FirebaseAuth auth;

  const Account({super.key, required this.user, required this.auth});
  void showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Color'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Red'),
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .updateColor(Colors.red);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Blue'),
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .updateColor(Colors.blue);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Green'),
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .updateColor(Colors.green);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Yellow'),
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .updateColor(Colors.yellow);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Purple'),
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .updateColor(Colors.purple);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Default'),
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .updateColor(Colors.white);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // theme: ThemeData(
    //   colorSchemeSeed: Colors.red,
    // );
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/userimage.png', height: 100),
          Text(
            user.email ?? "Anonymous",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .background, // Set the background color of the container
                borderRadius: BorderRadius.circular(
                    10.0), // Adjust the corner radius as needed
                boxShadow: [
                  // Optional: Add a shadow for depth
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 1), // Changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child:
                              //padding: EdgeInsets.only(left: 20),
                              Text(
                            'Toggle Theme',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: 20),
                          ),
                          //)
                          // Text('Toggle Theme', textAlign: TextAlign.start),
                        ),
                        Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (bool value) {
                            final provider = Provider.of<ThemeProvider>(context,
                                listen: false);
                            provider.toggleTheme(value);
                          },
                          // activeColor:Theme.of(context).colorScheme.primary,
                          activeColor: Colors.white,
                          activeTrackColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                  // Additional content can be added here
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .background, // Set the background color of the container
                borderRadius: BorderRadius.circular(
                    10.0), // Adjust the corner radius as needed
                boxShadow: [
                  // Optional: Add a shadow for depth
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 1), // Changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child:
                              //padding: EdgeInsets.only(left: 20),
                              Text(
                            'Change Theme Color',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: 20),
                          ),
                          //)
                          // Text('Toggle Theme', textAlign: TextAlign.start),
                        ),
                        ElevatedButton(
                          onPressed: () => showColorPicker(context),
                          style: ButtonStyle(),
                          child: const Text('>'),
                        ),
                      ],
                    ),
                  ),
                  // Additional content can be added here
                ],
              ),
            ),
          ),
          const SizedBox(height: 124),
          ElevatedButton(
            onPressed: auth.signOut,
            style: ButtonStyle(
              // backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFF7A7A)),
              // foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primary),
              foregroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.secondary),
            ),
            child: SizedBox(
              width: 300,
              child: Text(
                'Log Out',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
