// ignore_for_file: prefer_const_constructors

import 'package:chat_me/screens/chat_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllUser extends StatefulWidget {
  const AllUser({Key? key}) : super(key: key);

  @override
  _AllUserState createState() => _AllUserState();
}

class _AllUserState extends State<AllUser> {
  String currentEmail='';
  String currentUserName = '';
  String currentUserNumber = '';
  String receiverName = '';
  String receiverDp = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inputData();
    getCurrentData();
  }
  @override
  Widget build(BuildContext context) {
    var color1 = Colors.lightBlue;
    var color2 = Colors.white;
    FirebaseFirestore firestore3 = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Users',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: color2,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore3.collection('Users').where('Email',isNotEqualTo: currentEmail).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } 
            else {
              final data = snapshot.data!.docs;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: (){
                      addSender(data[index].get('Email'));
                    },
                    minVerticalPadding: 20,
                    leading: CircleAvatar(
                      radius: 20,
                      foregroundImage: NetworkImage(data[index].get('dp')),
                    ),
                    title: Text(
                      data[index].get('Name'),
                      style: TextStyle(
                          fontSize: 15,
                          color: color1,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      data[index].get('Email'),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        // fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),
                      ),
                    ),
                  );
                }
              );
            }
          },
        ),
      ),
    );
  }
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void inputData() {
    final User? user = auth.currentUser;
    currentEmail = user!.email.toString();
  }
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

// var timeformat = DateTime.now().hour.toString() + ':'+ DateTime.now().minute.toString();
// var dateformat = DateTime.now().day.toString() + '/'+ DateTime.now().month.toString()+ '/'+ DateTime.now().year.toString();
  addSender(String receiverEmail) async{
    await firestore
    .collection('Users')
    .doc(receiverEmail)
    .get().then((snapshot) {
      setState(() {
        receiverName = snapshot.get('Name').toString();
        receiverDp = snapshot.get('dp').toString();
      });
    });
    await firestore
    .collection(currentEmail)
    .doc(receiverEmail).set({
      'Name': receiverName,
      'Email':receiverEmail,
      'dp': receiverDp,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
