import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:halifax_dating/screens/discoverScreen.dart';
import 'package:halifax_dating/screens/profile.dart';
import 'package:halifax_dating/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 30, // Set your desired height
            decoration: BoxDecoration(
              image:const DecorationImage(
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
          decoration:const BoxDecoration(
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
              //style: Theme.of(context).textTheme.headlineMedium,
              style: GoogleFonts.leckerliOne(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon:const Icon(Icons.notifications),
                onPressed: () {
                  // Handle notification icon press
                },
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                  DiscoverScreen(),
                ],
              ),
            ),
          ),
          Center(
            child: Text('First Page'),
          ),
          Center(
            child: Text('Second Page'),
          ),
          Profile()
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        buttonBackgroundColor: Colors.white,
        color: Color.fromRGBO(252, 229, 255, 1),
        height: 65,
        items: <Widget>[
          Icon(
            Icons.explore,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
          Icon(
            Icons.favorite,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
          Icon(
            Icons.chat,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
          Icon(
            Icons.person,
            size: 35,
            color: Theme.of(context).primaryColor,
          )
        ],
        onTap: (index) {
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        },
      ),
    );
  }
}
