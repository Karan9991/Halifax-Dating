import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:halifax_dating/utils/constants.dart';
import 'package:swipe_cards/swipe_cards.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 30, // Set your desired height
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/z.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(1.0),
                bottomLeft: Radius.circular(1.0),
              ),
              //  borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10.0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
        ),

        backgroundColor: Colors.transparent,
        elevation: 0, // Remove the default shadow
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.pinkAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppConstants.APP_TITLE,
              style: GoogleFonts.leckerliOne(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  // Handle notification icon press
                },
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
   
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 253, 129, 205),
                // Color.fromARGB(255, 255, 199, 199)
                Color.fromRGBO(252, 229, 255, 1)
              ],
            ),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(165.0),
                bottomLeft: Radius.circular(80.0),
                bottomRight: Radius.circular(280.0)),
          ),
          child: Stack(
            children: [
              CardSwiper(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.redAccent,
        buttonBackgroundColor: Colors.white,
        color: Color.fromRGBO(252, 229, 255, 1),
        height: 65,
        items: const <Widget>[
          Icon(
            Icons.explore,
            size: 35,
            color: Colors.redAccent,
          ),
          Icon(
            Icons.favorite,
            size: 35,
            color: Colors.redAccent,
          ),
          Icon(
            Icons.chat,
            size: 35,
            color: Colors.redAccent,
          ),
          Icon(
            Icons.person,
            size: 35,
            color: Colors.redAccent,
          )
        ],
        onTap: (index) {
          // _pageController.animateToPage(index,
          //     duration: const Duration(milliseconds: 300),
          //     curve: Curves.easeOut);
        },
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
