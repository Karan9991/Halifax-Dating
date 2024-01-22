

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdditionalImagesScreen extends StatefulWidget {
  @override
  _AdditionalImagesScreenState createState() => _AdditionalImagesScreenState();
}

class _AdditionalImagesScreenState extends State<AdditionalImagesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

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

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Uploading...'),
              ],
            ),
          );
        },
      );

      try {
        String imageUrl = await _uploadImageToStorage(imageFile, uid!, index);

        setState(() {
          _imageUrls[index] = imageUrl;
        });

        // Update the image URLs in Firestore
        await _firestore.collection('users').doc(uid).update({
          'imageUrls': _imageUrls,
        });
      } catch (e) {
        print('Error uploading image: $e');
      } finally {
        Navigator.pop(context); // Close the upload progress dialog
      }
    }
  }

  Future<String> _uploadImageToStorage(
      File imageFile, String userId, int index) async {
    String fileName = '$index.jpg';
    String? downloadURL;

    Reference storageReference =
        _storage.ref().child('profile_images/$fileName');
    UploadTask uploadTask = storageReference.putFile(imageFile);

    // Get the task snapshot to monitor the upload progress
    TaskSnapshot taskSnapshot = await uploadTask.snapshot;

    // Listen to changes in the task state (optional)
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = snapshot.bytesTransferred / snapshot.totalBytes;
      print('Upload progress: $progress');
      // You can update your progress bar UI here
    });

    // Wait for the upload to complete
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
    return 
    // Scaffold(
    //   body: 
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
                      ),
                    ),
                    child: _imageUrls[index] != null
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(40.0),
                                  bottomLeft: Radius.circular(40.0),
                                ),
                                child: Image.network(
                                  _imageUrls[index]!,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                top:
                                    0.0, // Adjusted value to accommodate the size of the close icon
                                right:
                                    0.0, // Adjusted value to accommodate the size of the close icon
                                child: GestureDetector(
                                  onTap: () => _deleteImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Icon(
                              Icons.camera_enhance,
                              size: 50,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
   //   ),
    );
  }
}
