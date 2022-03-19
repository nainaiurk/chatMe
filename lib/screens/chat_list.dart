// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, use_key_in_widget_constructors, sized_box_for_whitespace


import 'package:chat_me/UserInfo.dart';
import 'package:chat_me/screens/AllUser.dart';
import 'package:chat_me/screens/ChatDetails.dart';
import 'package:chat_me/screens/drawer_screen/profile_page.dart';
import 'package:chat_me/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'drawer_screen/about_us.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}
bool darkMode = false;

class _ChatListState extends State<ChatList> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  UserInformation user = UserInformation();
  FirebaseAuth auth = FirebaseAuth.instance;
  var currentUserName = '';
  var currentEmail = '';
  var currentUserNumber = '';
  @override
  void initState() {
    super.initState();
    inputData();
    getCurrentData();
  }

  @override
  Widget build(BuildContext context) {
    var color1 = Colors.lightBlue;
    var textFieldColor = Colors.grey[300];
    FirebaseFirestore firestore2 = FirebaseFirestore.instance;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('ChatME'),
        titleTextStyle: TextStyle(
          fontSize: 30,fontWeight: 
          FontWeight.bold,
          color: Colors.white
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        elevation: 20,
        child: Column(
          children: [
            DrawerHeader(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                decoration: BoxDecoration(color: color1),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      CircleAvatar(
                        maxRadius: 40,
                      ),
                      SizedBox(height: 10,),
                      Text(
                        currentUserName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                      ),
                      Text(
                        currentEmail == "" ? "":
                        currentEmail,
                        style: TextStyle(
                          color: Colors.black54
                        ),
                      )
                    ],
                  ),
                )),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
              },
              leading: Icon(Icons.person),
              title: Text(
                'My Profile',
              ),
            ),
            Divider(),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutApp()));
              },
              leading: Icon(Icons.info),
              title: Text(
                'About us',
              ),
            ),
            Divider(),
            ListTile(
              onTap: (){
                UserInformation user = UserInformation();
                user.deleteLogInDataToSharedPreference();
                auth.signOut();
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context)=>LogInScreen())
                );
              },
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
            ),
            Divider(),
            // SizedBox(height: 50,),
            // Padding(
            //   padding: const EdgeInsets.only(left: 12),
            //   child: Row(
            //     children: [
            //       Icon(Icons.dark_mode, size: 30, color: Colors.black54),
            //       SizedBox(width: 30,),
            //       Text(
            //         'Dark Mode',
            //         style: TextStyle(fontSize: 15, color: Colors.black54),
            //       ),
            //       SizedBox(
            //         width: 30,
            //       ),
            //       Switch(
            //         value: darkMode,
            //         onChanged: (value) {
            //           setState(() {
            //             darkMode = value;
            //           });
            //         },
            //         activeTrackColor: color1,
            //         activeColor: Colors.yellow,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
      key: scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: textFieldColor,
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          BorderSide(color: Colors.transparent)),
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10,left: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.add_a_photo_outlined),
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width*0.73,
                        child: ListView.builder(
                          itemCount: 20,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,i){
                            return CircleAvatar(
                              radius: 30,
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.65,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: firestore2.collection(currentEmail).orderBy('timestamp',descending: true).snapshots(),
                    builder: (context,snapshot){
                      if(snapshot.hasError){
                        return Text('Something went wrong');
                      }
                      if (!snapshot.hasData){
                        return Center(child: CircularProgressIndicator());
                      }
                      else{
                        final data = snapshot.data!.docs;
                        // var time = DateFormat('MM/dd/yyyy, hh:mm a');
                        // var timeformat = DateTime.now().hour.toString() + ':'+ DateTime.now().minute.toString();
                        // var dateformat = DateTime.now().day.toString() + '/'+ DateTime.now().month.toString()+ '/'+ DateTime.now().year.toString();
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context,index){
                            return ListTile(
                              onTap: (){
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context)=>
                                    ChatDetails(
                                      receiverName: data[index].get("Name"),
                                      receiverEmail: data[index].get("Email"),
                                    )
                                  )
                                );
                              },
                              leading: CircleAvatar(
                                radius: 30,
                                // child: Text(currentUserName[0]),
                              ),
                              title: Text(
                                data[index].get('Name'),
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  //  fontWeight: FontWeight.bold
                                  ),
                              ),
                              minVerticalPadding: 22,
                              
                              subtitle: Text(
                                data[index].get('Email'),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  // fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),
                                ),
                              ),
                              // trailing: Column(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Text(
                              //       data[index].get('time'),
                              //       style: TextStyle(
                              //         color: Colors.grey,
                              //         fontSize: 13
                              //       ),
                              //     ),
                              //     Text(
                              //       data[index].get('date'),
                              //       style: TextStyle(
                              //         color: Colors.grey,
                              //         fontSize: 13
                              //       ),
                              //     )
                              //   ],
                              // ),
                            );
                          }
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            Positioned(
                  bottom: 40,
                  right: 40,
                  child: FloatingActionButton(
                    backgroundColor: color1,
                    child: Icon(
                      Icons.add,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context)=>AllUser())
                      );
                    },
                  ))
          ],
        ),
      ),
    );
  }

  void inputData() {
    final User? user = auth.currentUser;
    currentEmail = user!.email.toString();
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  Future getCurrentData() async{
      return await firestore
      .collection('Users')
      .doc(currentEmail)
      .get().then((snapshot) {
        setState(() {
          currentUserName = snapshot.get('Name').toString();
          currentUserNumber = snapshot.get('Mobile').toString();
        });
      });
    }
  
}
