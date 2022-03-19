// ignore_for_file: prefer_const_constructors

import 'package:chat_me/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
  // if(Firebase.apps.isEmpty){
   await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBYl4RJ-945ZMegKmRhEFyN-jVVMnOhVY0",
      authDomain: "chatme-2b321.firebaseapp.com",
      projectId: "chatme-2b321",
      storageBucket: "chatme-2b321.appspot.com",
      messagingSenderId: "816634581505",
      appId: "1:816634581505:web:396a66a63a8acb78c62600",
      measurementId: "G-5BZHP0FHSV"
      )
    ).whenComplete(() => runApp(MyApp()));
  }
    // .whenComplete(() =>   runApp(MyApp()));
    // runApp(MyApp());
  // }
  else {
    await Firebase.initializeApp();
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        appBarTheme: AppBarTheme(
          color: Colors.lightBlue,
          titleTextStyle: TextStyle(color: Colors.white)
        )
      ),
      home: WelcomeScreen(),
    );
  }
}