import 'package:flutter/material.dart';

class UserManualScreen extends StatelessWidget {
  const UserManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Manual",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("📖 Getting Started"),
            _buildListItem(
              "When you open the app, you have two options to sign up:",
              [
                "Enter your name in the text field and click Save",
                "Continue with Google for instant login"
              ],
            ),
            const SizedBox(height: 8),
            _buildNote(
                "Once signed up, you cannot change your username, but you can clear AI history in your profile."),
            const Divider(height: 30),
            _buildSectionTitle("🏠 Home Screen Layout"),
            _buildListItem(
              "At the top, you will see:",
              [
                "The app name 'Communicator'",
                "A profile icon at the top-right corner",
                "From profile, you can clear AI Agent chat history"
              ],
            ),
            const Divider(height: 30),
            _buildSectionTitle("💬 Chats Overview"),
            _buildListItem(
              "There are two chat sections:",
              [
                "AI Chatbot – Responds in Urdu, understands any language input.",
                "Public Group Chat – A shared space for all users to talk."
              ],
            ),
            _buildSubSection("AI Chatbot Features", [
              "Type in any language (English, Urdu, Sindhi, etc.)",
              "AI always replies in Urdu"
            ]),
            _buildSubSection("Public Group Chat Features", [
              "Talk to everyone in the group",
              "Mention '@a.i' to talk to AI – AI replies in Urdu",
              "Edit your messages anytime",
              "Delete messages for everyone",
              "Listen to messages in a Female voice"
            ]),
            const Divider(height: 30),
            _buildSectionTitle("🔔 Notifications"),
            _buildListItem(
              "Receive notifications for every new message in both AI and group chats.",
              [],
            ),
            const Divider(height: 30),
            _buildSectionTitle("⚠ Important Notes"),
            _buildListItem("", [
              "No images or file sharing is supported – text only",
              "All users share the same public group"
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildListItem(String intro, List<String> points) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (intro.isNotEmpty)
            Text(
              intro,
              style: const TextStyle(fontSize: 16),
            ),
          if (points.isNotEmpty) const SizedBox(height: 5),
          ...points.map(
            (point) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("• ", style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubSection(String title, List<String> points) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "   🔹 $title",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ", style: TextStyle(fontSize: 15)),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNote(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
