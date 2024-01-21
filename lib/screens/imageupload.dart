import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

//  late final _user;
  String? uid;
  List<String?> _imageUrls = List.filled(9, null); // List to store image URLs


  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() async {
    uid = _auth.currentUser!.uid;

    // Fetch user's image URLs from Firestore
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(uid).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      if (userData != null && userData.containsKey('imageUrls')) {
        setState(() {
          _imageUrls = List.from(userSnapshot['imageUrls']);
        });
      }
    }
  }

  Future<void> _uploadImage(int index) async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String imageUrl = await _uploadImageToStorage(imageFile, uid!, index);

      setState(() {
        _imageUrls[index] = imageUrl;
      });

      // Update the image URLs in Firestore
      await _firestore.collection('users').doc(uid).update({
        'imageUrls': _imageUrls,
      });
    }
  }

  Future<String> _uploadImageToStorage(
      File imageFile, String userId, int index) async {
    
    String fileName = '$index.jpg';

    Reference storageReference =
        _storage.ref().child('profile_images/$fileName');
    UploadTask uploadTask = storageReference.putFile(imageFile);

    String? downloadURL;
    await uploadTask.whenComplete(() async {
      // Get download URL
      downloadURL = await storageReference.getDownloadURL();
    });

    return downloadURL!;
  }

  Future<void> _deleteImage(int index) async {
    // Delete image from Firebase Storage
    debugPrint('image urllll $index}');
    try {
      // Delete image from Firebase Storage
      await _storage.ref().child('profile_images/$index.jpg').delete();
    } catch (e) {
      print('Error deleting image: $e');
    }
    setState(() {
      _imageUrls[index] = null;
    });

    // Update the image URLs in Firestore
    await _firestore.collection('users').doc(uid).update({
      'imageUrls': _imageUrls,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Profile Images',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _uploadImage(index),
                  onLongPress: () => _deleteImage(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: _imageUrls[index] != null
                        ? Image.network(_imageUrls[index]!, fit: BoxFit.cover)
                        : Icon(Icons.add, size: 40, color: Colors.black),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
