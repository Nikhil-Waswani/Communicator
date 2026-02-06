import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Practice extends StatefulWidget {
  const Practice({super.key});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  File? _image;

  void pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    // 1. Get storage reference (location in Firebase Storage)
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('my_image_${DateTime.now().millisecondsSinceEpoch}.jpg');

    // 2. Upload file
    await storageRef.putFile(_image!);

    // 3. Get the download URL
    String downloadURL = await storageRef.getDownloadURL();

    // 4. Save URL in Firestore
    await FirebaseFirestore.instance.collection('images').add({
      'url': downloadURL,
      'uploaded_at': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Updating Image',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (_image != null) ? Image.file(_image!) : Text('No image selected'),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () => pickImage(),
                        child: Text('Pick Image')),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () => _uploadImage(),
                        child: Text('Pick Image')),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
