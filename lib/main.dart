import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:halifax_dating/firebase_options.dart';
import 'package:halifax_dating/screens/homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => OnboardingScreen(),
      //   '/signup': (context) => const SignUpScreen(),
      //   '/home': (context) => const HomeScreen(),
      // },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.redAccent, primary: Colors.redAccent),
        useMaterial3: true,
        textTheme: GoogleFonts.leckerliOneTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: HomeScreen(),
      //   home: const SignUpScreen(),
      //home: OnboardingScreen(),
    );
  }
}
