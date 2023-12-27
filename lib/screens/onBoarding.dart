import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Assuming you have a list of onboarding data
  List<OnboardingData> onboardingData = [
    OnboardingData(
      image: 'assets/11.jpg',
      title: 'Welcome to Halifax Dating',
      description: 'Find your perfect match with Halifax Dating app.',
    ),
    OnboardingData(
      image: 'assets/22.jpg',
      title: 'Discover New Connections',
      description: 'Connect with people who share your interests and values.',
    ),
    OnboardingData(
      image: 'assets/33.jpg',
      title: 'Start Your Dating Journey',
      description: 'Begin your exciting journey to love and companionship.',
    ),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFD8183), Color(0xFFFB425A)],
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(420.0),
            bottomLeft: Radius.circular(450.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0, right: 100.0),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(55.0),
                      bottomLeft: Radius.circular(55.0),
                    ),
                  ),
                  child: Text('Halifax Dating',
                      style: GoogleFonts.leckerliOne(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFD8183),
                      )),
                ),
              ),
              Container(
                height: 300, // Set your desired height
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(onboardingData[currentIndex].image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(170.0),
                    bottomLeft: Radius.circular(170.0),
                  ),
                  //  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                onboardingData[currentIndex].title,
                style: GoogleFonts.leckerliOne(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                onboardingData[currentIndex].description,
                style: GoogleFonts.leckerliOne(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (currentIndex < onboardingData.length - 1) {
                          currentIndex++;
                        } else {
                          // Navigate to the next screen or perform any action
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'Next',
                      style: GoogleFonts.eagleLake(color: Colors.red),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 170.0),
                child: Container(
                  height: 100,
                  width: 130,
                  // Set your desired height
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/logo.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(70.0),
                      bottomLeft: Radius.circular(70.0),
                    ),
                    //  borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingData {
  final String image;
  final String title;
  final String description;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}
