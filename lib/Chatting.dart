import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communicator/Gemini_services.dart';
import 'package:communicator/GetTextField.dart';
import 'package:communicator/Profile.dart';
import 'package:communicator/Profile2.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:path_provider/path_provider.dart';
import 'database.dart';

Future<File> getLocalFile(String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/$filename');
}

class LessChating extends StatelessWidget {
  String owner;
  LessChating(this.owner, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.deepPurple,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      home: Chatting(owner),
    );
  }
}

class Chatting extends StatefulWidget {
  String owner;

  Chatting(this.owner, {super.key});

  @override
  State<Chatting> createState() => _ChattingState();
}

ScrollController _scrollCol = ScrollController();

void scrollToLast() {
  Future.delayed(Duration(milliseconds: 100), () {
    _scrollCol.animateTo(
      _scrollCol.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  });
}

List messages = [];
Database db = Database();
GeminiServices agent = GeminiServices();

const apiKey = "AIzaSyAaStL5D4OZ5VlGq23gpRTUScdHIlHiCwI";
final model = GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);

dynamic sendIcon = Icon(Icons.send_rounded, color: Colors.white);

class _ChattingState extends State<Chatting> {
  TextEditingController msgCol = TextEditingController();
  dynamic sendAction = () {};
  int currentColor = 1;
  String? tempOwner;

  void getUserCheck(filename) async {
    tempOwner = await readFromFile(filename);
  }

  @override
  void initState() {
    super.initState();
    getUserCheck('UserFile');
    sendAction = sendActionM;
  }

  void sendActionM() async {
    sendAction = null;
    setState(() {
      sendIcon = Image.asset('lib/Assets/loadings.gif');
    });
    if (msgCol.text.trim().isNotEmpty) {
      db.sendMsg(
          msgCol.text,
          widget.owner.toLowerCase(),
          (widget.owner.toLowerCase() != 'A.I agent') ? 'A.I agent' : 'nikhil',
          'user',
          '${widget.owner.toLowerCase()}GPTMessages');
    }
    String temp = msgCol.text;
    msgCol.text = '';
    db.sendMsg(await agent.getResponse(temp), 'A.I agent', widget.owner,
        'model', '${widget.owner}GPTMessages');
    setState(() {
      sendIcon = Icon(Icons.send_rounded, color: Colors.white);
    });
    sendAction = sendActionM;
  }

  void sendMessage(String msg) {
    Database db = Database();
    db.sendMsg(msg, widget.owner, 'Group', 'none', 'GPTMessages');
    setState(() {
      msgCol.text = '';
    });
  }

  void _showEditBox(int index, String message) {
    TextEditingController _editFieldCol = TextEditingController();
    _editFieldCol.text = message;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            border: Border.all(color: Colors.grey.shade700, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _editFieldCol,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Message",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: InputBorder.none,
            ),
          ),
        ),
        actions: [
          MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Text("cancel", style: TextStyle(color: Colors.white))),
          TextButton(
            onPressed: () {
              setState(() {
                if (_editFieldCol.text.trim().isNotEmpty) {
                  messages[index] =
                      TextMessage(_editFieldCol.text.trim(), 0000);
                }
              });
              Navigator.pop(context);
            },
            child: Text("Done", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSelfPressDialog(
      String collectionPath, String docId, String currentMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Message Options"),
        content: const Text("What do you want to do with this message?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close current dialog
              _showEditDialog(collectionPath, docId, currentMessage);
            },
            child: const Text("Edit"),
          ),
          TextButton(
            onPressed: () {
              agent.speak(currentMessage);
              Navigator.pop(context);
            },
            child: const Text("Speak", style: TextStyle(color: Colors.yellow)),
          ),
          TextButton(
            onPressed: () {
              db.deleteDoc(collectionPath, docId);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _showOtherPressDialog(String currentMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Message Options"),
        actions: [
          TextButton(
            onPressed: () async {
              await agent.speak(currentMessage);
              Navigator.pop(context);
            },
            child: const Text("Speak", style: TextStyle(color: Colors.yellow)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(String collectionPath, String docId, String oldMessage) {
    TextEditingController controller = TextEditingController(text: oldMessage);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Message"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              db.updateMessage(collectionPath, docId,
                  controller.text); // your update function
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LessProfile2(widget.owner)));
            },
            icon: Icon(Icons.settings_accessibility),
          )
        ],
        title: Center(
            child: const Text(
          "Communicator",
          style: TextStyle(fontWeight: FontWeight.w900),
        )),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
            color: Colors.black,
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color:
                        (currentColor == 1) ? Colors.grey[900] : Colors.black,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentColor = 1;
                      });
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('lib/Assets/appIcon.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color:
                        (currentColor == 2) ? Colors.grey[900] : Colors.black,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentColor = 2;
                      });
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('lib/Assets/teamwork.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder(
                          stream: db.loadMessages((currentColor == 1)
                              ? '${widget.owner}GPTMessages'
                              : 'GroupMessages'),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              messages = snapshot.data!.docs;
                              scrollToLast();
                              return ListView.builder(
                                itemCount: messages.length,
                                controller: _scrollCol,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot document = messages[index];
                                  Map<String, dynamic> msg =
                                      document.data() as Map<String, dynamic>;
                                  return (currentColor == 2 &&
                                          widget.owner == msg['senderId'])
                                      ? GestureDetector(
                                          onLongPress: () =>
                                              _showSelfPressDialog(
                                            'GroupMessages',
                                            document.id,
                                            msg['text'],
                                          ),
                                          child: GetMessageBox(
                                            msg['text'],
                                            msg['senderId'],
                                            widget.owner.toLowerCase(),
                                          ),
                                        )
                                      : GestureDetector(
                                          onLongPress: () =>
                                              _showOtherPressDialog(
                                                  msg['text']),
                                          child: GetMessageBox(
                                            msg['text'],
                                            msg['senderId'],
                                            widget.owner.toLowerCase(),
                                          ),
                                        );
                                },
                              );
                            } else {
                              return const Center(
                                  child: Text("No messages...",
                                      style: TextStyle(color: Colors.white)));
                            }
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: 8, top: 4, bottom: 8, left: 12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  border: Border.all(
                                      color: Colors.grey.shade700, width: 1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  minLines: 1,
                                  maxLines: 4,
                                  controller: msgCol,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Message",
                                    hintStyle:
                                        TextStyle(color: Colors.grey.shade400),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                                onPressed: (currentColor == 1)
                                    ? sendAction
                                    : () async {
                                        if (msgCol.text.trim().isNotEmpty) {
                                          db.sendMsg(
                                              msgCol.text.trim(),
                                              widget.owner,
                                              'Group',
                                              'none',
                                              'GroupMessages');
                                          String tempInput = msgCol.text.trim();
                                          setState(() {
                                            msgCol.clear();
                                          });
                                          try {
                                            if (tempInput
                                                    .substring(0, 5)
                                                    .toLowerCase() ==
                                                '@a.i ') {
                                              print('temp $tempInput');
                                              db.sendMsg(
                                                  await agent
                                                      .getResponse(tempInput),
                                                  'A.i Agent',
                                                  widget.owner,
                                                  'model',
                                                  'GroupMessages');
                                            }
                                          } catch (e) {}
                                        }
                                      },
                                icon: sendIcon),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
