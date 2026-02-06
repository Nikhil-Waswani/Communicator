import 'package:communicator/Chatting.dart';
import 'package:communicator/Database.dart';
import 'package:communicator/GetTextField.dart';
import 'package:communicator/services/firebase_auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<String?> readFromFile(String filename) async {
  try {
    final file = await getLocalFile(filename);
    return await file.readAsString();
  } catch (e) {
    return null;
  }
}

class LessProfile extends StatelessWidget {
  const LessProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Profile(),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

String? Owner;

class _ProfileState extends State<Profile> {
  void initState() {
    super.initState();
    checkingUser();
  }

  Future<File> getLocalFile(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$filename');
  }

  void checkingUser() async {
    String? temp = await readFromFile('UserFile');
    setState(() {
      Owner = temp;
      (Owner != null) ? saveUserToken(Owner!) : null;
      (Owner != null)
          ? Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => LessChating(Owner!)))
          : null;
    });
  }

  Future<void> saveToFile(String filename, String content) async {
    final file = await getLocalFile(filename);
    await file.writeAsString(content);
  }

  Database _db = Database();

  TextEditingController namecol = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SignUp",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (Owner != null)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Heloo $Owner",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Image.asset(
                            'lib/Assets/heart.png',
                            width: 30,
                          )
                        ],
                      )
                    : Text(''),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GetTextField("Your Name..", Icons.person, namecol),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      Owner = namecol.text;
                      if (Owner!.trim() != '') {
                        setState(() {
                          saveUserToken(Owner!.toLowerCase());
                          namecol.clear();
                          saveToFile('UserFile', Owner!);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LessChating(Owner!.toLowerCase())));
                        });
                      }
                    },
                    child: Text("Save")),
              ],
            ),
          ),

          // Divider before Google Sign In
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 1,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: 10),

          ElevatedButton(
            onPressed: () async {
              try {
                final user = await authService.signInWithGoogle();
                if (user != null) {
                  Owner = user.displayName!.toLowerCase();
                  saveUserToken(Owner!.toLowerCase());
                  namecol.clear();
                  saveToFile('UserFile', Owner!.toLowerCase());
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LessChating(Owner!.toLowerCase())));
                }
              } catch (e) {
                setState(() {
                  namecol.text = 'ERROR: $e';
                });
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'lib/Assets/google.png',
                  height: 24,
                  width: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Continue with Google',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}
