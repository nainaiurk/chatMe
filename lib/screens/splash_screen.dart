// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:async';
import 'package:chat_me/UserInfo.dart';
import 'package:chat_me/screens/chat_list.dart';
import 'package:chat_me/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({ Key? key }) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  User? loggedInUser;
  bool data = false ;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    getData();
  }
  
  getData() async{
    UserInformation info = UserInformation();
    await info.getEmail().then((value) {
      setState(() {
        data = true;
      });
    });
  }
  
  _WelcomeScreenState(){
    Timer(Duration(milliseconds: 3000), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );
            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds:2000),
          pageBuilder: (_, __, ___) => data == false ? LogInScreen(): ChatList()
        )
      );
    });
    Timer(Duration(milliseconds: 1000), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlue,
        child: Center(
          child: AnimatedOpacity(
            opacity: _isVisible ? 1 : 0, 
            duration: Duration(milliseconds: 2000),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset('smiley.png',height: 200,)
                ),
                Hero(
                  tag: 'title',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'ChatME',
                      style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold,color: Colors.white
                    ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}