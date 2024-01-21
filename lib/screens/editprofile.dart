import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<String?> profileImageUrls = List.generate(9, (index) => null);

  Future<void> uploadImage(int index, File imagePath) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/image$index');
      UploadTask uploadTask = storageReference.putFile(imagePath);

      await uploadTask.whenComplete(() async {
        String imageUrl = await storageReference.getDownloadURL();
        setState(() {
          profileImageUrls[index] = imageUrl;
        });
        saveImageUrlsToFirestore();
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> deleteImage(int index) async {
    try {
      String imageUrl = profileImageUrls[index]!;
      if (imageUrl != null) {
        // Delete image from Firebase Storage
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
        // Delete image URL from Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc('user_id') // Replace 'user_id' with the actual user ID
            .update({
          'profile_images': FieldValue.arrayRemove([imageUrl])
        });

        setState(() {
          profileImageUrls[index] = null;
        });
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<void> saveImageUrlsToFirestore() async {
    try {
      // Replace 'user_id' with the actual user ID
      await FirebaseFirestore.instance
          .collection('users')
          .doc('user_id')
          .set({'profile_images': profileImageUrls}, SetOptions(merge: true));
    } catch (e) {
      print('Error saving image URLs to Firestore: $e');
    }
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Displaying Image Containers
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
                  onTap: () {
                    // Implement image selection logic
                  },
                  onLongPress: () {
                    if (profileImageUrls[index] != null) {
                      // Implement delete image logic
                      deleteImage(index);
                    }
                  },
                  child: Container(
                    color: Colors.grey[200],
                    child: profileImageUrls[index] != null
                        ? Image.network(
                            profileImageUrls[index]!,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.add),
                  ),
                );
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save profile changes
                saveImageUrlsToFirestore();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
