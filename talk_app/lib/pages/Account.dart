import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Account extends StatefulWidget {
  final User user;
  final FirebaseAuth auth;

  const Account({super.key, required this.user, required this.auth});

  @override
  _AccountState createState() => _AccountState();
}


class _AccountState extends State<Account> {
  String _language = 'English';
  String _practiceLanguage = 'English';

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text('Account Settings', style: TextStyle(fontSize: 40)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Center(

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Icon(Icons.person, size: 100), // Person icon
              SizedBox(height: 20),
              Text(widget.user.displayName ?? "Anonymous", style: TextStyle(fontSize: 20)),
              Text(widget.user.uid),
              SizedBox(height: 50),
              Text("Select Language",style: TextStyle(fontSize: 25)),
              Container(
                width: 250,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),  // Reduced horizontal padding
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _language,
                  icon: const Icon(Icons.arrow_downward, color: Colors.white),
                  dropdownColor: Colors.blue,
                  elevation: 16,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _language = newValue!;
                    });
                  },
                  items: <String>['English', 'Spanish', 'French', 'German']
                      .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
              ),

            SizedBox(height: 20),
            Text("Select Language For Practice",style: TextStyle(fontSize: 25)),
            Container(
              width: 250,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),  // Reduced horizontal padding
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                //border: Border.all(color: Theme.of(context).colorScheme.secondary),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: _practiceLanguage,
                icon: const Icon(Icons.arrow_downward, color: Colors.white),
                dropdownColor: Colors.blue,
                elevation: 16,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                underline: Container(
                  height: 0,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _practiceLanguage = newValue!;
                  });
                },
                items: <String>['English', 'Spanish', 'French', 'German']
                    .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              // style: ButtonStyle(
              //   backgroundColor: MaterialStateProperty.all(
              //       Colors.lightBlue.shade300), // Explicitly setting a blue background
              // ),
              onPressed: () => widget.auth.signOut(),
              child: Text("Log Out", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
              // style: ButtonStyle(
              //   backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),  // Replace `Colors.blue` with your desired color
              // ),
            )
          ],
        ),
      ),
    );
  }
}