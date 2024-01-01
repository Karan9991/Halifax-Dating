import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_cards/swipe_cards.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dating App'),
      ),
      body: Stack(
        children: [
          CardSwiper(),
          //buildButtons(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Matches'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat), label: 'Conversations'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class CardSwiper extends StatefulWidget {
  @override
  _CardSwiperState createState() => _CardSwiperState();
}

class _CardSwiperState extends State<CardSwiper> {
  List<DocumentSnapshot> users = [];
  int currentIndex = 0;
  late MatchEngine _matchEngine;

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
        _buildButton(
            icon: Icons.message,
            onPressed: () {
              // Handle message button press
            },
            top: 380,
            right: 5,
            color: Colors.orange),
        _buildButton(
            icon: Icons.favorite,
            onPressed: () {
              _matchEngine.currentItem?.like();
              // Handle favorite button press
            },
            top: 450,
            right: 35,
            color: Colors.green),
        _buildButton(
            icon: Icons.star,
            onPressed: () {
              _matchEngine.currentItem?.superLike();
              // Handle star button press
            },
            top: 510,
            right: 85,
            color: Colors.blue),
        _buildButton(
            icon: Icons.close,
            onPressed: () {
              // Handle close button press
              _matchEngine.currentItem?.nope();
            },
            top: 550,
            right: 150,
            color: Colors.red),
        _buildButton(
            icon: Icons.replay,
            onPressed: () {
              // Handle close button press
              _matchEngine.rewindMatch();
            },
            top: 580,
            right: 217,
            color: Colors.yellow),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onPressed,
    required double top,
    required double right,
    required Color color,
  }) {
    return Positioned(
      top: top,
      right: right,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 30,
            color: color, // Customize the button color
          ),
        ),
      ),
    );
  }

  List<SwipeItem> _buildSwipeItems(List<DocumentSnapshot> users) {
    return users
        .map((user) => SwipeItem(
              content: UserCard(user),
              likeAction: () {
                // Handle like action
                print('Liked user at index $currentIndex');
              },
              nopeAction: () {
                // Handle nope action
                print('Disliked user at index $currentIndex');
              },
              superlikeAction: () {
                // Handle super like action
                print('Superliked user at index $currentIndex');
              },
            ))
        .toList();
  }
}

class UserCard extends StatelessWidget {
  final DocumentSnapshot user;

  UserCard(this.user);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
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
                  fontSize: 20, color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
