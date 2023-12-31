import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:halifax_dating/widgets/discoverScreenButtons.dart';
import 'package:swipe_cards/swipe_cards.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  List<DocumentSnapshot> users = [];
  int currentIndex = 0;
  late MatchEngine _matchEngine;
  String? currentUserId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('init called');
    initialize();
  }

  Future<void> initialize() async {
    await call();
  }

  Future<void> call() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      currentUserId = user.uid;
    }
    _matchEngine = MatchEngine(swipeItems: _buildSwipeItems(users));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            users = snapshot.data!.docs;
            // Update the _matchEngine when the underlying data changes
            _matchEngine = MatchEngine(swipeItems: _buildSwipeItems(users));

            return SwipeCards(
              matchEngine: _matchEngine,
              onStackFinished: () {
                // Handle stack finished
              },
              itemBuilder: (context, index) => UserCard(users[index]),
              likeTag: Icon(Icons.favorite, color: Colors.blue, size: 50),
              nopeTag: Icon(Icons.close, color: Colors.blue, size: 50),
              superLikeTag: Icon(Icons.star, color: Colors.blue, size: 50),
              fillSpace: true,
              upSwipeAllowed: true,
              leftSwipeAllowed: true,
              rightSwipeAllowed: true,
              itemChanged: (item, index) {
                // Handle item changed
              },
            );
          },
        ),
        buildButtons(),
      ],
    );
  }

  Widget buildButtons() {
    return Stack(
      children: [
        buildButton(
            icon: Icons.message,
            onPressed: () {
              // Handle message button press
            },
            top: 380,
            right: 5,
            color: Colors.orange),
        buildButton(
            icon: Icons.favorite,
            onPressed: () {
              _matchEngine.currentItem?.like();
              // Handle favorite button press
            },
            top: 450,
            right: 35,
            color: Colors.green),
        buildButton(
            icon: Icons.star,
            onPressed: () {
              _matchEngine.currentItem?.superLike();
              // Handle star button press
            },
            top: 510,
            right: 85,
            color: Colors.blue),
        buildButton(
            icon: Icons.close,
            onPressed: () {
              // Handle close button press
              _matchEngine.currentItem?.nope();
            },
            top: 550,
            right: 150,
            color: Theme.of(context).primaryColor),
        buildButton(
            icon: Icons.replay,
            onPressed: () {
              // Handle close button press
              _matchEngine.rewindMatch();
              _rewindAction();
            },
            top: 580,
            right: 217,
            color: Colors.yellow),
      ],
    );
  }

  List<SwipeItem> _buildSwipeItems(List<DocumentSnapshot> users) {
    return users
        .map((user) => SwipeItem(
              content: UserCard(user),
              likeAction: () {
                _likeUser(user.id);
                // Handle like action
                print('Liked user at index $currentIndex');
              },
              nopeAction: () {
                _dislikeUser(user.id);
                // Handle nope action
                print('Disliked user at index $currentIndex');
              },
              superlikeAction: () {
                _superlikeUser(user.id);
                // Handle super like action
                print('Superliked user at index $currentIndex');
              },
            ))
        .toList();
  }

  Future<void> _likeUser(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('likes')
        .doc(userId)
        .set({'liked': true});
  }

  Future<void> _dislikeUser(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('dislikes')
        .doc(userId)
        .set({'disliked': true});
  }

  Future<void> _superlikeUser(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('superlikes')
        .doc(userId)
        .set({'superliked': true});
  }

  Future<void> _rewindAction() async {
    if (_matchEngine.currentItem != null) {
      String previousUserId = _matchEngine.currentItem!.content.user.id;
      await _removeInteraction(previousUserId, 'likes');
      await _removeInteraction(previousUserId, 'dislikes');
      await _removeInteraction(previousUserId, 'superlikes');
    }
  }

  Future<void> _removeInteraction(String userId, String interactionType) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId) // Replace with the current user's ID
        .collection(interactionType)
        .doc(userId)
        .delete();
  }
}

class UserCard extends StatelessWidget {
  final DocumentSnapshot user;

  UserCard(this.user);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(150.0), // Adjust the value as needed
                bottomRight:
                    Radius.circular(300.0), // Adjust the value as needed
                bottomLeft: Radius.circular(50.0)),
            child: Image.network(
              user['photoUrl'],
              height: 600,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8, // Adjust the top value to position the text vertically
            right:
                8, // Adjust the right value to position the text horizontally
            child: Text(
              user['name'],
              style: GoogleFonts.leckerliOne(
                  fontSize: 20, color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
