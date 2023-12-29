import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
          buildButtons(),
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

  Widget buildButtons() {
    return Positioned(
      top: 0,
      bottom: 0,
      right: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          IconButton(
            icon: Icon(Icons.thumb_up),
            onPressed: () {
              // Handle like button press
            },
          ),
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        users = snapshot.data!.docs;
        return SwipeCards(
          matchEngine: MatchEngine(swipeItems: _buildSwipeItems(users)),
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

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(15.0),
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(150.0), // Adjust the value as needed
//               bottomRight: Radius.circular(400.0), // Adjust the value as needed
//             ),
//             child: Image.network(
//               user['photoUrl'],
//               height: 600,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               user['name'],
//               style: TextStyle(fontSize: 20),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(150.0), // Adjust the value as needed
                  bottomRight:
                      Radius.circular(400.0), // Adjust the value as needed
                ),
                child: Image.network(
                  user['photoUrl'],
                  height: 600,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  user['name'],
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        // Positioned(
        //   key: ValueKey(user['name']), // Unique key for each card

        //   top: 300,
        //   bottom: 0,
        //   right: 0,
        //   child: IconButton(
        //     icon: Icon(Icons.thumb_up),
        //     onPressed: () {
        //       // Handle like button press
        //     },
        //   ),
        // ),
      ],
    );
  }
}
