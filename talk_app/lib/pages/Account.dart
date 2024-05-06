import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';
import 'package:talk_app/pages/SettingModel/Theme.dart';
import 'package:talk_app/pages/SettingModel/ThemeWidget.dart';


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
    final themeProvider = Provider.of<ThemeProvider>(context);

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
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text('Toggle Theme', textAlign: TextAlign.start),
                    ),
                    Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (bool value) {
                        final provider = Provider.of<ThemeProvider>(context, listen: false);
                        provider.toggleTheme(value);
                      },
                    ),
                  ],
                ),
              ),
              // Additional content can be added here
            ],
          ),
          // ElevatedButton(
          //   onPressed: null,
          //   style: ButtonStyle(
          //     backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF7AA7FF)),
          //     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          //   ),
          //   child: const SizedBox(
          //     width: 300,
          //     child: Text(
          //       'Translation History',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(fontSize: 16),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 24),
          // const Text(
          //   "Select your language",
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     _changeLanguage(context);
          //   },
          //   style: ButtonStyle(
          //     backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF7AA7FF)),
          //     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          //   ),
          //   child: const SizedBox(
          //     width: 300,
          //     child: Text(
          //       'English',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(fontSize: 16),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 12),
          // const Text(
          //   "Select language to practice",
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     _changeLanguage(context);
          //   },
          //   style: ButtonStyle(
          //     backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF7AA7FF)),
          //     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          //   ),
          //   child: const SizedBox(
          //     width: 300,
          //     child: Text(
          //       'English',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(fontSize: 16),
          //     ),
          //   ),
          // ),
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


// class Account extends StatefulWidget {
//   final User user;
//   final FirebaseAuth auth;
//
//   const Account({super.key, required this.user, required this.auth});
//
//   @override
//   _AccountState createState() => _AccountState();
// }
//
//
// class _AccountState extends State<Account> {
//   String _language = 'English';
//   String _practiceLanguage = 'English';
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//
//       appBar: AppBar(
//         title: Text('Account Settings', style: TextStyle(fontSize: 40)),
//         centerTitle: true,
//         backgroundColor: Theme.of(context).colorScheme.background,
//       ),
//       body: Center(
//
//           child: Column(
//
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//
//               Icon(Icons.person, size: 100), // Person icon
//               SizedBox(height: 20),
//               Text(widget.user.displayName ?? "Anonymous", style: TextStyle(fontSize: 20)),
//               Text(widget.user.uid),
//               SizedBox(height: 50),
//               Text("Select Language",style: TextStyle(fontSize: 25)),
//               Container(
//                 width: 250,
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),  // Reduced horizontal padding
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.primary,
//                   border: Border.all(color: Colors.blueAccent),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: DropdownButton<String>(
//                   isExpanded: true,
//                   value: _language,
//                   icon: const Icon(Icons.arrow_downward, color: Colors.white),
//                   dropdownColor: Colors.blue,
//                   elevation: 16,
//                   style: const TextStyle(color: Colors.white, fontSize: 20),
//                   underline: Container(
//                     height: 0,
//                   ),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _language = newValue!;
//                     });
//                   },
//                   items: <String>['English', 'Spanish', 'French', 'German']
//                       .map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                 ),
//               ),
//
//             SizedBox(height: 20),
//             Text("Select Language For Practice",style: TextStyle(fontSize: 25)),
//             Container(
//               width: 250,
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),  // Reduced horizontal padding
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary,
//                 //border: Border.all(color: Theme.of(context).colorScheme.secondary),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: DropdownButton<String>(
//                 isExpanded: true,
//                 value: _practiceLanguage,
//                 icon: const Icon(Icons.arrow_downward, color: Colors.white),
//                 dropdownColor: Colors.blue,
//                 elevation: 16,
//                 style: const TextStyle(color: Colors.white, fontSize: 20),
//                 underline: Container(
//                   height: 0,
//                 ),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _practiceLanguage = newValue!;
//                   });
//                 },
//                 items: <String>['English', 'Spanish', 'French', 'German']
//                     .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//               ),
//             ),
//             SizedBox(height: 40),
//             ElevatedButton(
//               // style: ButtonStyle(
//               //   backgroundColor: MaterialStateProperty.all(
//               //       Colors.lightBlue.shade300), // Explicitly setting a blue background
//               // ),
//               onPressed: () => widget.auth.signOut(),
//               child: Text("Log Out", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
//               // style: ButtonStyle(
//               //   backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),  // Replace `Colors.blue` with your desired color
//               // ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }