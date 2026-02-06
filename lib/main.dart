import 'package:communicator/Chatting.dart';
import 'package:communicator/Database.dart';
import 'package:communicator/Login.dart';
import 'package:communicator/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:communicator/Profile.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('✅ Handling background/terminated message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  agent.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission();

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print(' User granted permission for notifications.');
  } else {
    print(' Notification permission not granted.');
  }

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Database db = Database();

  runApp(LessProfile());
}
