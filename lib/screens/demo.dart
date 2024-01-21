// import 'dart:async';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class PhotoUploadScreen extends StatefulWidget {
//   @override
//   _PhotoUploadScreenState createState() => _PhotoUploadScreenState();
// }

// class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   FirebaseStorage _storage = FirebaseStorage.instance;
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<File?> _imageList = List.generate(9, (index) => null);
//   List<String> _imageUrls = [];

//   @override
//   void initState() {
//     super.initState();
//     // Call a method to load images from Firebase when the screen initializes
//     _loadImagesFromFirebase();
//   }

//   Future<void> _loadImagesFromFirebase() async {
//     String uid = _auth.currentUser!.uid;

//     // Retrieve the list of image URLs from Firestore
//     DocumentSnapshot userDoc =
//         await _firestore.collection('users').doc(uid).get();
//     setState(() {
//       _imageUrls = List<String>.from(userDoc['images'] ?? []);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Photo Upload"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             crossAxisSpacing: 8.0,
//             mainAxisSpacing: 8.0,
//           ),
//           itemCount: 9,
//           itemBuilder: (context, index) {
//             return _buildImageContainer(index);
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildImageContainer(int index) {
//     if (index < _imageUrls.length) {
//       // Display image if available
//       return Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//         ),
//         child: Stack(
//           alignment: Alignment.topRight,
//           children: [
//             // Image.file(_imageList[0]!),
//             Image.network(
//               _imageUrls[index],
//               fit: BoxFit.cover,
//             ),
//             IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () {
//                 _deleteImage(index);
//               },
//             ),
//           ],
//         ),
//       );
//     }
//      else if (_imageList[index] != null) {
//       return Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//         ),
//         child: Stack(
//           alignment: Alignment.topRight,
//           children: [
//             Image.file(_imageList[index]!),
//             IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () {
//                 _deleteImage(index);
//               },
//             ),
//           ],
//         ),
//       );
//     }
//     else {
//       // Display placeholder if no image available
//       return Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//         ),
//         child: IconButton(
//           icon: Icon(Icons.add),
//           onPressed: () {
//             _pickImage(index);
//           },
//         ),
//       );
//     }
//   }

//   Future<void> _pickImage(int index) async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _imageList[index] = File(pickedFile.path);
//       });

//       // Upload the picked image to Firebase Storage
//       await _uploadImageToStorage(index);
//     }
//   }

//   Future<void> _uploadImageToStorage(
//     int index,
//   ) async {
//     File imageFile = _imageList[index]!;
//     String uid = _auth.currentUser!.uid;
//     String imagePath = 'images/$uid/image$index.jpg';
//     Reference storageReference = _storage.ref().child(imagePath);
//     UploadTask uploadTask = storageReference.putFile(imageFile);

//     await uploadTask.whenComplete(() async {
//       // Get download URL
//       String downloadURL = await storageReference.getDownloadURL();

//       // Update Firestore with the download URL
//       _firestore.collection('users').doc(uid).update({
//         'images': FieldValue.arrayUnion([downloadURL]),
//       });
//     });
//   }

//   Future<void> _deleteImage(int index) async {
//     debugPrint('delete image called $index');
//     debugPrint(' image list 0 ${_imageList[index]}');

//     debugPrint(' image list index ${_imageList[index]}');

//     debugPrint(' image list $_imageList');

//     String uid = _auth.currentUser!.uid;

//     // Check if the image at the given index exists
//     //if (_imageList[index] != null) {
//     debugPrint('if delete image called $index');

//     // Delete the image from Firebase Storage
//     String imagePath = 'images/$uid/image$index.jpg';
//     Reference storageReference = _storage.ref().child(imagePath);
//     await storageReference.delete();

//     // Remove the image from the local list
//     setState(() {
//       _imageList[index] = null;
//     });

//     // Get the current list of images from Firestore
//     DocumentSnapshot userDoc =
//         await _firestore.collection('users').doc(uid).get();
//     List<String> currentImages = List<String>.from(userDoc['images'] ?? []);

//     // Remove the deleted image URL from Firestore
//     if (currentImages.length > index) {
//       String deletedImageUrl = currentImages[index];
//       await _firestore.collection('users').doc(uid).update({
//         'images': FieldValue.arrayRemove([deletedImageUrl]),
//       });
//     }
//     // } else {
//     //   debugPrint('else delete image called $index');
//     // }
//   }
// }

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploadScreen extends StatefulWidget {
  @override
  _PhotoUploadScreenState createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<File?> _imageList = List.generate(9, (index) => null);
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    // Call a method to load images from Firebase when the screen initializes
    _loadImagesFromFirebase();
  }

  // Future<void> _loadImagesFromFirebase() async {
  //   String uid = _auth.currentUser!.uid;

  //   // Retrieve the list of image URLs from Firestore
  //   DocumentSnapshot userDoc =
  //       await _firestore.collection('users').doc(uid).get();
  //   debugPrint('checkingggggg ${userDoc.toString()}');

  //   DocumentSnapshot<Map<String, dynamic>> test =
  //       await _firestore.collection('users').doc(uid).get();

  //   List<String> tt = List.from(test['s']);

  //   debugPrint('checkingggggg 2 ${test['1']}');

  //   // setState(() {
  //   //   _imageUrls = List<String>.from(userDoc['0'] ?? []);
  //   // });
  // }
  Future<void> _loadImagesFromFirebase() async {
    try {
      String uid = _auth.currentUser!.uid;

      // Retrieve the list of image URLs from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      debugPrint('checkingggggg ${userDoc.toString()}');

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        List<String> urls = [];

        for (var key in userData.keys) {
          if (key != 'name' && key != 'photoUrl') {
            urls.add(userData[key]);
          }
        }
        debugPrint('printing list $urls');
        setState(() {
          _imageUrls = urls;
        });
      }
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo Upload"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            return _buildImageContainer(index);
          },
        ),
      ),
    );
  }

  Widget _buildImageContainer(int index) {
    if (index < _imageUrls.length) {
      // Display image if available
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            // Image.file(_imageList[0]!),
            Image.network(
              _imageUrls[index],
              fit: BoxFit.cover,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteImage(index);
              },
            ),
          ],
        ),
      );
    } else if (_imageList[index] != null) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Image.file(_imageList[index]!),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteImage(index);
              },
            ),
          ],
        ),
      );
    } else {
      // Display placeholder if no image available
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _pickImage(index);
          },
        ),
      );
    }
  }

  Future<void> _pickImage(int index) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageList[index] = File(pickedFile.path);
      });

      // Upload the picked image to Firebase Storage
      await _uploadImageToStorage(index);
    }
  }

  Future<void> _uploadImageToStorage(
    int index,
  ) async {
    File imageFile = _imageList[index]!;
    String uid = _auth.currentUser!.uid;
    String imagePath = 'images/$uid/image$index.jpg';

    Reference storageReference = _storage.ref().child(imagePath);
    UploadTask uploadTask = storageReference.putFile(imageFile);

    await uploadTask.whenComplete(() async {
      // Get download URL
      String downloadURL = await storageReference.getDownloadURL();

      // Update Firestore with the download URL
      _firestore.collection('users').doc(uid).update({
        //  '$index': FieldValue.arrayUnion([downloadURL]),
        '$index': downloadURL,
      });
    });
  }``

  Future<void> _deleteImage(int index) async {
    String uid = _auth.currentUser!.uid;

    // Check if the image at the given index exists
    //if (_imageList[index] != null) {

    // Delete the image from Firebase Storage
    String imagePath = 'images/$uid/image$index.jpg';
    Reference storageReference = _storage.ref().child(imagePath);
    await storageReference.delete();

    // Remove the image from the local list
    setState(() {
      _imageList[index] = null;
    });

    // Get the current list of images from Firestore

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();

    //  if (userDoc.exists) {
    Map<String, dynamic> currentImages = userDoc.data() as Map<String, dynamic>;
    List<String> urls = [];

    // for (var key in userData.keys) {
    //   if (key != 'name' && key != 'photoUrl') {
    //     urls.add(userData[key]);
    //   }
    // }
    // debugPrint('printing list $urls');
    // setState(() {
    //   _imageUrls = urls;
    // });
    // }
    //2
    // List<String> currentImages = List<String>.from(userDoc['$index'] ?? []);
    // Get a reference to the user's document
    DocumentReference userDocRef = _firestore.collection('users').doc(uid);

    // Update Firestore to remove the specified key (image)
    await userDocRef.update({
      '$index': FieldValue.delete(),
    });
    // Remove the deleted image URL from Firestore
    // if (currentImages.length > index) {
    //   String deletedImageUrl = currentImages[index];
    //   await _firestore.collection('users').doc(uid).update({
    //     'images': FieldValue.arrayRemove([deletedImageUrl]),

    //     // index: deletedImageUrl,
    //   });
    // }
    // } else {
    //   debugPrint('else delete image called $index');
    // }
  }

  Future<void> _deleteImagee(int index) async {
    String uid = _auth.currentUser!.uid;

    // Check if the image at the given index exists
    //if (_imageList[index] != null) {

    // Delete the image from Firebase Storage
    String imagePath = 'images/$uid/image$index.jpg';
    Reference storageReference = _storage.ref().child(imagePath);
    await storageReference.delete();

    // Remove the image from the local list
    setState(() {
      _imageList[index] = null;
    });

    // Get the current list of images from Firestore

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    List<String> currentImages = List<String>.from(userDoc['$index'] ?? []);

    // Remove the deleted image URL from Firestore
    if (currentImages.length > index) {
      String deletedImageUrl = currentImages[index];
      await _firestore.collection('users').doc(uid).update({
        'images': FieldValue.arrayRemove([deletedImageUrl]),

        // index: deletedImageUrl,
      });
    }
    // } else {
    //   debugPrint('else delete image called $index');
    // }
  }
}
