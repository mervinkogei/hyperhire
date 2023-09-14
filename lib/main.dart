import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firstsplashscreenview/firstsplashscreenview.dart';
import 'package:flutter/material.dart';
import 'package:hyperhire/Screens/home.dart';
import 'package:hyperhire/Screens/login.dart';
import 'package:hyperhire/Screens/register.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  runApp(const MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade300),
        useMaterial3: true,
      ),
      home: SplashScreen(
        backgroundColor: Colors.purple,
        duration: const Duration(seconds: 3),
        nextPage:  LoginScreen(),
        iconBackgroundColor: Colors.white,
        circleHeight: 60,
        child: Icon(
          Icons.holiday_village,
          size: 50,
        ),
        text: const Text(
          "HyperHire-Card",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
    ),
     initialRoute: '/',
      routes: {
        '/home':(context) => HomeScreen(),
        '/register':(context) => const RegisterScreen(),
        '/login':(context) =>  LoginScreen()
      },
    );
  }
}

