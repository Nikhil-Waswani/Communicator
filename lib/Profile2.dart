import 'package:communicator/Chatting.dart';
import 'package:communicator/Database.dart';
import 'package:communicator/UserManualScreeen.dart';
import 'package:flutter/material.dart';

class LessProfile2 extends StatelessWidget {
  final String owner;
  const LessProfile2(this.owner, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Profile2(owner),
    );
  }
}

class Profile2 extends StatefulWidget {
  final String owner;
  const Profile2(this.owner, {super.key});

  @override
  State<Profile2> createState() => _Profile2State();
}

class _Profile2State extends State<Profile2> {
  final Database _db = Database();
  final TextEditingController namecol = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get device dimensions
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Scale values for responsive sizing
    double baseFontSize = width * 0.045; // font size scales with width
    double iconSize = width * 0.08; // image size scales with width
    double spacing = height * 0.02;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseFontSize),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Middle section
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hello ${widget.owner}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: baseFontSize,
                            ),
                          ),
                          SizedBox(width: spacing / 2),
                          Image.asset(
                            'lib/Assets/heart.png',
                            width: iconSize,
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: spacing),
                  // TextButton(
                  //   onPressed: () {
                  //     _db.deleteCollection('${widget.owner}GPTMessages');
                  //     // agent.resetChat();
                  //   },
                  //   child: Text(
                  //     'Click here to Clean Up A.I Agent History',
                  //     style: TextStyle(fontSize: baseFontSize * 0.85),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

          // Bottom section
          Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserManualScreen()),
                );
              },
              child: Text(
                '-> User Manual <-',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: baseFontSize * 0.9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
