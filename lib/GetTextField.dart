import 'package:flutter/material.dart';

class GetTextField extends StatelessWidget {
  GetTextField(this.inputmsg, this.ic, this.col, {super.key});

  final String inputmsg;
  final dynamic? ic;
  final dynamic col;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 3, // Adds depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenWidth * 0.9, // Limits width to 90% of screen size
          ),
          child: Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: TextField(
              controller: col,
              decoration: InputDecoration(
                hintText: inputmsg,
                hintStyle: TextStyle(color: Colors.grey.shade600),
                border: InputBorder.none,
                prefixIcon: ic == null ? null : Icon(ic, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class getPerson extends StatefulWidget {
  getPerson(this.col, this.currentCol, {super.key});

  dynamic col;
  dynamic currentCol;

  @override
  State<getPerson> createState() => getPersonState(col, currentCol);
}

class getPersonState extends State<getPerson> {
  getPersonState(this.col, this.currentCol);

  dynamic col;
  dynamic currentCol;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.5),
      child: Container(
        decoration: BoxDecoration(
            color: col,
            borderRadius: BorderRadius.circular(150),
            border: Border.all(color: Colors.deepPurple.shade300, width: 0)),
        height: double.infinity,
        width: 20,
      ),
    );
  }
}

class GetMessageBox extends StatefulWidget {
  final String msg;
  final String sender;
  final String owner;
  const GetMessageBox(this.msg, this.sender, this.owner, {super.key});

  @override
  State<GetMessageBox> createState() => _GetMessageBoxState();
}

class _GetMessageBoxState extends State<GetMessageBox> {
  @override
  Widget build(BuildContext context) {
    final bool isOwner = widget.sender == widget.owner;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Align(
        alignment: isOwner ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isOwner
                ? Colors.deepPurple.withOpacity(0.85)
                : const Color(0xFF2A2A2A),
            border: Border.all(
              color: isOwner ? Colors.deepPurple : Colors.grey.shade800,
            ),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isOwner ? const Radius.circular(16) : Radius.zero,
              bottomRight: isOwner ? Radius.zero : const Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(1, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isOwner ? 'You' : widget.sender,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade300,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              SelectableText(
                widget.msg,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextMessage {
  String? text;
  int? msgID;

  TextMessage(this.text, this.msgID);
}
