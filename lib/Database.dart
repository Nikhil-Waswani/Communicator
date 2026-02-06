import 'dart:io' as io;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communicator/services/get_server_key.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
import 'Profile.dart';

class Database {
  String generateID(String organizationName, {String? name}) {
    String id = "";
    String revName = "";
    String revOrg = "";
    if (name != null) {
      for (int i = name.length - 1; i >= 0; i--) {
        if (name[i] == 'z') {
          revName = revName + "z";
        } else {
          revName = revName + String.fromCharCode(name.codeUnitAt(i) + 1);
        }
      }
    }

    for (int i = organizationName.length - 1; i >= 0; i--) {
      if (organizationName[i] == 'z') {
        revOrg = revOrg + "z";
      } else {
        revOrg =
            revOrg + String.fromCharCode(organizationName.codeUnitAt(i) + 1);
      }
    }

    int bigger =
        (revName.length >= revOrg.length) ? revName.length : revOrg.length;
    for (int i = 0; i < bigger; i++) {
      if (i < revName.length) {
        id = id + revName[i];
      }
      if (i < revOrg.length) {
        id = id + revOrg[i];
      }
    }

    id = "${name?.length}" + id + "${organizationName.length}";
    return id;
  }

  List<String> decodeID(String id) {
    // Extract original lengths
    String tempLength = "";

    for (int i = 0; i < id.length; i++) {
      try {
        int.parse(id[i]);
        tempLength = tempLength + id[i];
      } catch (e) {
        break;
      }
    }

    int nameLength = int.parse(tempLength);
    tempLength = "";

    for (int i = 0; i < id.length; i++) {
      try {
        int.parse(id[id.length - 1 - i]);
        tempLength = id[id.length - 1 - i] + tempLength;
      } catch (e) {
        break;
      }
    }

    int orgLength = int.parse(tempLength);
    String middle = id.substring(1, id.length - 1);

    String revName = "";
    String revOrg = "";

    for (int i = 0, nameCount = 0, orgCount = 0; i < middle.length; i++) {
      if (nameCount < nameLength) {
        revName += middle[i];
        nameCount++;
        i++;
      }
      if (orgCount < orgLength && i < middle.length) {
        revOrg += middle[i];
        orgCount++;
      }
    }

    String name = "";
    for (int i = revName.length - 1; i >= 0; i--) {
      name += (revName[i] == 'z')
          ? 'z'
          : String.fromCharCode(revName.codeUnitAt(i) - 1);
    }

    String org = "";
    for (int i = revOrg.length - 1; i >= 0; i--) {
      org += (revOrg[i] == 'z')
          ? 'z'
          : String.fromCharCode(revOrg.codeUnitAt(i) - 1);
    }

    return [name, org];
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createOrganization(String organizationName, String ownerName,
      String password, String year, String location) async {
    await firestore.collection("Organizations").doc(organizationName).set({
      'ID': generateID(organizationName),
      'owner_name': ownerName,
      'owner_ID': generateID(organizationName, name: ownerName),
      'year_of_founded': year,
      'location': location,
      'timestamp': FieldValue.serverTimestamp(),
    });

    registerEmployee(organizationName, ownerName, password);
  }

  Future<void> registerEmployee(
      String organizationName, String empName, String password) async {
    await firestore
        .collection("Organizations")
        .doc(organizationName)
        .collection('users')
        .add({
      'ID': generateID(organizationName, name: empName),
      'name': empName,
      'password': password,
      'profile': "Profile",
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendMsg(String msg, String sender, String receiverId,
      String role, String collectionPath) async {
    DateTime now = DateTime.now();
    await firestore.collection(collectionPath).add({
      'senderId': sender,
      'receiverId': receiverId,
      'text': msg,
      'role': role, // ✅ This allows Gemini to remember history
      'timestamp': Timestamp.fromDate(now),
    });

    // Send push notification
    if (collectionPath == 'GroupMessages') {
      String? myToken = await getReceiverToken(sender);
      List tokens = await getUsersTokens();
      GetServerKey getServerKey = GetServerKey();
      String serverkey = await getServerKey.getServerKeyToken();
      for (var user in tokens) {
        if (user != myToken) {
          sendFcmV1(user, "$sender has just msg you ${Owner!}", msg,
              'communicatordb-bf810', serverkey);
        }
      }
    }
  }

  Stream<QuerySnapshot> loadMessages(String collectionPath) {
    final messagesStream = firestore
        .collection(collectionPath)
        .orderBy('timestamp', descending: false)
        .snapshots();
    return messagesStream;
  }

  void addUser(String user) async {
    await firestore.collection("Users").doc(user).set({'User': user});
  }

  Future<List<String>> getUsersTokens() async {
    List<String> users = [];
    QuerySnapshot snapshot = await firestore.collection('Users').get();
    for (dynamic doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      users.add(data['token']);
    }
    return users;
  }

  void deleteCollection(String collectionPath) async {
    QuerySnapshot snapshot = await firestore.collection(collectionPath).get();

    for (var doc in snapshot.docs) {
      doc.reference.delete();
    }
  }

  void deleteDoc(String collectionPath, String docId) {
    firestore.collection(collectionPath).doc(docId).delete();
  }

  void updateMessage(
      String collectionPath, String docId, String message) async {
    await firestore.collection(collectionPath).doc(docId).update({
      'text': message,
    });
  }
}

Future<void> saveUserToken(String userId) async {
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .set({'token': token}, SetOptions(merge: true));
  }
}

Future<String?> getReceiverToken(String receiverId) async {
  var doc = await FirebaseFirestore.instance
      .collection('Users')
      .doc(receiverId)
      .get();
  return doc.data()?['token'];
}

Future<void> sendFcmV1(String token, String title, String body,
    String projectId, String accessToken) async {
  final url = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/$projectId/messages:send');
  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json'
  };
  final payload = {
    'message': {
      'token': token,
      'notification': {'title': title, 'body': body},
    }
  };

  await http.post(url, headers: headers, body: jsonEncode(payload));
}

Future<String?> createNotificationGroup({
  required String serverKey,
  required String senderId,
  required String groupName,
  required List<String> registrationTokens,
}) async {
  final url = Uri.parse('https://fcm.googleapis.com/fcm/notification');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
    'project_id': senderId,
  };
  print('done1');
  final body = {
    'operation': 'create',
    'notification_key_name': groupName,
    'registration_ids': registrationTokens,
  };
  print('done2');

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(body),
  );
  print('done3');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['notification_key'];
  } else {
    print('❌ Failed: ${response.statusCode}');
    print(response.body);
    return null;
  }
}

// Future<void> pickAndUploadImage({required String userId}) async {
//   final picker = ImagePicker();
//   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//   if (pickedFile != null) {
//     try {
//       Uint8List imageBytes;

//       // Read bytes depending on platform
//       if (kIsWeb) {
//         imageBytes = await pickedFile.readAsBytes(); // Web uses this
//       } else {
//         File imageFile = File(pickedFile.path); // Mobile
//         imageBytes = await imageFile.readAsBytes(); // Mobile also supports this
//       }

//       // Generate unique file name
//       String fileName =
//           "${DateTime.now().millisecondsSinceEpoch}_${path.basename(pickedFile.name)}";

//       // Firebase Storage reference
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child("user_profiles/$userId/$fileName");

//       print('Uploading image...');
//       UploadTask uploadTask = storageRef.putData(imageBytes);
//       TaskSnapshot snapshot = await uploadTask;
//       print('Upload complete.');

//       // Get download URL
//       String downloadURL = await snapshot.ref.getDownloadURL();
//       print('Download URL: $downloadURL');

//       // Save URL to Firestore
//       await FirebaseFirestore.instance
//           .collection("Users")
//           .doc(userId)
//           .set({'profile': downloadURL}, SetOptions(merge: true));

//       Database db = Database();
//       db.sendMsg("Image uploaded and URL saved to Firestore: $downloadURL",
//           'nikhil', '');
//     } catch (e) {
//       Database db = Database();
//       db.sendMsg("Error uploading image: $e", 'nikhil', '');
//     }
//   } else {
//     Database db = Database();
//     db.sendMsg("No image selected.", 'nikhil', '');
//   }
// }

Future<Uint8List> compressImage(Uint8List bytes) async {
  final original = img.decodeImage(bytes);
  if (original == null) throw Exception("Failed to decode image");

  final resized = img.copyResize(original, width: 800); // optional resize
  final compressed = img.encodeJpg(resized, quality: 70); // quality: 0–100

  return Uint8List.fromList(compressed);
}

Future<void> uploadImage() async {
  try {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      print("❌ No image selected.");
      return;
    }

    final fileName =
        'uploaded_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storageRef = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask;

    if (kIsWeb) {
      print("🌐 Running on web");
      Uint8List rawBytes = await image.readAsBytes();
      Uint8List compressedBytes = await compressImage(rawBytes);
      uploadTask = storageRef.putData(
        compressedBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
    } else {
      print("📱 Running on mobile/desktop");
      final io.File file = io.File(image.path);
      Uint8List rawBytes = await file.readAsBytes();
      Uint8List compressedBytes = await compressImage(rawBytes);
      uploadTask = storageRef.putData(
        compressedBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
    }

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      print("🔄 Upload is ${progress.toStringAsFixed(2)}% complete");
    }, onError: (e) {
      print("❌ Upload failed: $e");
    });

    final TaskSnapshot taskSnapshot = await uploadTask;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    print("✅ File uploaded. Download URL: $downloadUrl");

    await FirebaseFirestore.instance
        .collection("User")
        .add({'profile': downloadUrl});
    print("📌 Download URL saved to Firestore.");
  } catch (e) {
    print("❌ Error during image upload: $e");
  }
}
