import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:halifax_dating/widgets/app_section_card.dart';
import 'package:halifax_dating/widgets/profile.dart';
import 'package:halifax_dating/widgets/profile_basic_info_card.dart';


class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return Text('User data not found');
              } else {
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                var userName = userData['name'] ?? 'No Name';
                var userPhotoUrl = userData['photoUrl'] ?? 'default_photo_url';

                return ProfileBasicInfoCard(
                  userName: userName,
                  userPhotoUrl: userPhotoUrl,
                );
              }
            },
          ),
          const ProfileStatisticsCard(),
          AppSectionCard(),
        ],
      ),
    );
  }

  Future<DocumentSnapshot> getUserData() async {
    // Get the current user's UID
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    // Fetch user data from Firestore
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();
  }
}
