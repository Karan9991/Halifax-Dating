import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late String _profilePhotoUrl = '';
  List<String> _recievedAdditionalImages = [];
  late List<XFile> _additionalImageUrls;
  late XFile _newProfilePhoto;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _additionalImageUrls = [];
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
      // _additionalImageUrls =
      //     List<XFile>.from(userData['additionalImages'] ?? []);
      _recievedAdditionalImages =
          List<String>.from(userData['additionalImages'] ?? []);
    });
  }

  Future<void> _saveChanges() async {
    // Save changes to Firestore
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    await uploadProfilePhoto(currentUserUid);
    await uploadAdditionalImages(currentUserUid);

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

  Future<void> uploadAdditionalImages(String? currentUserUid) async {
    if (_additionalImageUrls != null) {
      List<String> additionalImageUrls = [];

      for (XFile additionalImage in _additionalImageUrls) {
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('additional_images')
            .child(
                '$currentUserUid/${DateTime.now().millisecondsSinceEpoch}.jpg');

        await storageRef.putFile(File(additionalImage.path));

        String imageUrl = await storageRef.getDownloadURL();
        additionalImageUrls.add(imageUrl);
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .update({
        'name': _nameController.text,
        'additionalImages': additionalImageUrls,
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

  Future<void> _pickAdditionalImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _additionalImageUrls.add(XFile(pickedFile.path));
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
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Editable profile photo
              InkWell(
                onTap: _pickProfilePhoto,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(_profilePhotoUrl),
                ),
              ),
              const SizedBox(height: 16),
              // Editable name
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              // Additional images (up to nine)

              GridView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  if (index < _recievedAdditionalImages.length) {
                    return InkWell(
                      onTap: () {
                        // TODO: Implement image deletion or any other action
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                NetworkImage(_recievedAdditionalImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return InkWell(
                      onTap: _pickAdditionalImage,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Icon(Icons.add, size: 40, color: Colors.grey),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
