import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:halifax_dating/model/onBoarding_data.dart';
import 'package:halifax_dating/utils/constants.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Assuming you have a list of onboarding data
  List<OnboardingData> onboardingData = [
    OnboardingData(
      image: AppConstants.ONBOARDING_IMAGE1,
      title: AppConstants.ONBOARDING_TITLE1,
      description: AppConstants.ONBOARDING_DESCRIPTION1,
    ),
    OnboardingData(
      image: AppConstants.ONBOARDING_IMAGE2,
      title: AppConstants.ONBOARDING_TITLE2,
      description: AppConstants.ONBOARDING_DESCRIPTION2,
    ),
    OnboardingData(
      image: AppConstants.ONBOARDING_IMAGE3,
      title: AppConstants.ONBOARDING_TITLE3,
      description: AppConstants.ONBOARDING_DESCRIPTION3,
    ),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 260.0, top: 50.0),
              child: Container(
                height: 90,
                width: 120,
                // Set your desired height
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage(AppConstants.LOGO2),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(70.0),
                    bottomLeft: Radius.circular(70.0),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0, right: 100.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(55.0),
                          bottomLeft: Radius.circular(55.0),
                        ),
                      ),
                      child: Text(AppConstants.APP_TITLE,
                          style: GoogleFonts.leckerliOne(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFD8183),
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
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(170.0),
                        bottomLeft: Radius.circular(170.0),
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
                  const SizedBox(height: 20),
                  Text(
                    onboardingData[currentIndex].title,
                    style: GoogleFonts.leckerliOne(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    onboardingData[currentIndex].description,
                    style: GoogleFonts.leckerliOne(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (currentIndex < onboardingData.length - 1) {
                              currentIndex++;
                            } else {
                              // Navigate to the next screen or perform any action
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => const SignUpScreen()));

                              Navigator.pushNamed(context, '/signup');
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
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
                    padding: const EdgeInsets.only(right: 170.0),
                    child: Container(
                      height: 100,
                      width: 130,
                      // Set your desired height
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage(AppConstants.LOGO),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(70.0),
                          bottomLeft: Radius.circular(70.0),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
