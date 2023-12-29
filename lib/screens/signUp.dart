import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:halifax_dating/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slider_button/slider_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  XFile? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
      }
    });
  }

  Future<void> _signUp() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();

      String uid = userCredential.user!.uid;

      if (_image != null) {
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('$uid.jpg');

        await storageRef.putFile(File(_image!.path));

        // Get download URL
        String imageUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': _nameController.text,
          'photoUrl': imageUrl,
        });

        print('user signedup with uid : ${userCredential.user!.uid}');
      } else {
        print('image path null');
      }
    } catch (e) {
      print('Error signing up : $e');
    }
  }

  Future<void> signUp() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();

      String uid = userCredential.user!.uid;

      // Upload image to Firebase Storage
      if (_image != null) {
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('$uid.jpg');

        await storageRef.putFile(File(_image!.path));

        // Get download URL
        String imageUrl = await storageRef.getDownloadURL();

        // Store user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': _nameController.text,
          'photoUrl': imageUrl,
        });
      } else {
        // If no image, store user data in Firestore without photoUrl
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': _nameController.text,
        });
      }

      print('User signed up successfully with UID: $uid');
    } catch (e) {
      print('Error signing up: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Set this to false to avoid resizing on keyboard display

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFD8183), Color(0xFFFB425A)],
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(250.0),
                bottomLeft: Radius.circular(450.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 50.0, right: 16.0, left: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 40),
                    child: Column(
                      children: [
                        Text(
                          AppConstants.ONBOARDING_TITLE1,
                          style: GoogleFonts.leckerliOne(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppConstants.SIGNUP_DESCRIPTION,
                          style: GoogleFonts.leckerliOne(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 5.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10.0,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            image: _image != null
                                ? DecorationImage(
                                    image: FileImage(File(_image!.path)),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _image == null
                              ? Container(
                                  width: 70,
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors
                                        .red, // Set your desired background color
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 90, // Adjust the size as needed
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: IconButton(
                          onPressed: getImage,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 20, right: 20, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(150),
                          bottomLeft: Radius.circular(150)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10.0,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 230, // Set your desired width
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              cursorColor: Colors.red,
                              controller: _nameController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                labelText: 'Name',
                                labelStyle:
                                    GoogleFonts.leckerliOne(color: Colors.red),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              style: GoogleFonts.leckerliOne(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 60.0), // Adjust this value as needed
                          child: Center(
                              child: SliderButton(
                                  width: 240.0,
                                  baseColor: Colors.white,
                                  buttonColor: Colors.red,
                                  backgroundColor:
                                      const Color.fromARGB(255, 254, 207, 195),
                                  highlightedColor:
                                      const Color.fromARGB(255, 255, 166, 156),
                                  action: () {
                                    _signUp();
                                  },
                                  label: Text(
                                    AppConstants.SLIDE_TO_GET_IN,
                                    style: GoogleFonts.leckerliOne(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17),
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ))),
                        ),
                      ],
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
}
