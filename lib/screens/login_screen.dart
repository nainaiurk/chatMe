// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, prefer_final_fields, unused_field, deprecated_member_use

import 'package:chat_me/UserInfo.dart';
import 'package:chat_me/screens/chat_list.dart';
import 'package:chat_me/screens/signUp_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../authentication/authentication.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen>{
  
  var color1 = Colors.lightBlue;
  var formKey = GlobalKey<FormState>();
  bool isChecked = false;
  bool visibility = true;
  var emailController = TextEditingController();
  var passController = TextEditingController();
  UserInformation user = UserInformation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: color1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 10,),
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset('assets/smiley.png',height: 100,)
                ),
                Hero(
                  tag: 'title',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'ChatME',
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Colors.white
                    ),
                    ),
                  ),
                ),
              ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Card(
                  elevation: 100,
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            'Log In',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Email',
                            ),
                            controller: emailController,
                            validator: (value) {
                              if (value!.length > 5 &&
                                  RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(value)) {
                                return null;
                              } else {
                                return 'Enter a valid Email';
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: visibility,
                            controller: passController,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    visibility = !visibility;
                                  });
                                },
                                icon: Icon(visibility == true
                                    ? Icons.visibility
                                    : Icons.visibility_off)
                                )
                              ),
                            validator: (value) {
                              if (value!.length < 8) {
                                return 'Invalid password';
                              } else {
                                return null;
                              }
                            },
                          ),
                          // SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    },
                                  ),
                                  Text('Remember me'),
                                ],
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: Text('Forgot password?'))
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Authenication.signIn(
                                        email: emailController.text,
                                        password: passController.text)
                                    .then((result) {
                                  if (result == null) {
                                    if(isChecked){
                                      user.saveUserEmailDataToSharedPreference(emailController.text);
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatList()
                                      )
                                    );
                                  } 
                                  else {
                                    Fluttertoast.showToast(
                                        msg: result, timeInSecForIosWeb: 3);
                                  }
                                });
                              }
                            },
                            color: color1,
                            height: 40,
                            minWidth: 100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: Text('Log In'),
                          ),
                          SizedBox(height: 30,),
                          Row(
                            children: [
                              Text('Dont\' have an account?'),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                                  },
                                  child: Text('Create acccount'))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
