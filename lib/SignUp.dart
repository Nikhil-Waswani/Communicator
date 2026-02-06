import 'package:communicator/Database.dart';
import 'package:communicator/GetTextField.dart';
import 'package:communicator/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class LessSignup extends StatelessWidget {
  const LessSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Signup(),
    );
  }
}

class _SignupState extends State<Signup> {
  TextEditingController empNameCol = TextEditingController();
  TextEditingController empPassCol = TextEditingController();
  TextEditingController empOrgCol = TextEditingController();

  void signUpDialog(String name, String orgName) {
    String? id;
    Database db = Database();
    id = db.generateID(orgName, name: name);
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text("Congratulations, You have Registered"),
              content: SelectableText("Your Id: $id"),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 13,
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxWidth: 400), // Ensures responsiveness
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                          child: getPerson(Colors.black, null),
                        ),
                        const SizedBox(height: 10),
                        GetTextField("Employee Name", Icons.person, empNameCol),
                        const SizedBox(height: 15),
                        GetTextField("Password", null, empPassCol),
                        const SizedBox(height: 15),
                        GetTextField("Employee Organization name or ID", null,
                            empOrgCol),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 200, // Fixed width for the button
                          child: ElevatedButton(
                            onPressed: () {
                              // Add action here
                              // print("${empNameCol.text} : ${empOrgCol.text}");
                              signUpDialog(empNameCol.text, empOrgCol.text);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: TextButton(
                  onPressed: () {},
                  child: Text("Don't Have Organization. Create here")))
        ],
      ),
    );
  }
}
