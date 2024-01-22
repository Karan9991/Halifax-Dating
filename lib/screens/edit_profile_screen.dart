
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:halifax_dating/screens/additionalImagesScreen.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late String _profilePhotoUrl = '';
  late XFile _newProfilePhoto;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Fetch user data from Firestore
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();

    // Populate the UI with the existing data
    setState(() {
      _nameController.text = userData['name'];
      _profilePhotoUrl = userData['photoUrl'];
     
    });
  }

  Future<void> _saveChanges() async {
    // Save changes to Firestore
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    await uploadProfilePhoto(currentUserUid);

    // Navigate back to the profile screen
    Navigator.pop(context);
  }

  Future<void> uploadProfilePhoto(String? currentUserUid) async {
    if (_newProfilePhoto != null) {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$currentUserUid.jpg');

      await storageRef.putFile(File(_newProfilePhoto.path));

      String imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .update({
        'name': _nameController.text,
        'photoUrl': imageUrl,
      });
    }
  }

  
  Future<void> _pickProfilePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _newProfilePhoto = XFile(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InkWell(
                onTap: _pickProfilePhoto,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(_profilePhotoUrl),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),

              AdditionalImagesScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
