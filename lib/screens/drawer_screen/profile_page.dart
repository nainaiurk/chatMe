// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
@override
  void initState() {
    super.initState();
    inputData();
    getCurrentData();
  }

  var pimage;
  var image;
  //   Future getImage() async{
  //   final ImagePicker _picked = ImagePicker();
  //   final XFile? image = await _picked.pickImage(
  //     source: ImageSource.gallery,
  //   );
  //   setState(() {
  //     pimage = File(image!.path);
  //   });
  // }

  FirebaseStorage storage = FirebaseStorage.instance;
  Future getImage() async{
    ImagePicker _picked = ImagePicker();
    image = await _picked.pickImage(
      source: ImageSource.gallery,
      maxHeight: 500
    );
    // if (kIsWeb){
    //   setState(() {
    //     pimage = NetworkImage(image!.path);
    //   });
    // }
    // else{
    //   // File? croppedFile = await ImageCropper().cropImage(
    //   //   sourcePath: image!.path,
    //   //   aspectRatioPresets: [
    //   //     CropAspectRatioPreset.square,
    //   //     CropAspectRatioPreset.ratio3x2,
    //   //     CropAspectRatioPreset.original,
    //   //     CropAspectRatioPreset.ratio4x3,
    //   //     CropAspectRatioPreset.ratio16x9
    //   //   ],
    //   //   androidUiSettings: AndroidUiSettings(
    //   //       toolbarTitle: 'Cropper',
    //   //       toolbarColor: Colors.deepOrange,
    //   //       toolbarWidgetColor: Colors.white,
    //   //       initAspectRatio: CropAspectRatioPreset.original,
    //   //       lockAspectRatio: false
    //   //     ),
    //   //   // iosUiSettings: IOSUiSettings(
    //   //   //   minimumAspectRatio: 1.0,
    //   //   // )
    //   // );
    //   setState(() {
    //     pimage = FileImage(File(image!.path,));
    //   });
    // }
    var file = File(image!.path);
    if (image != null){
        //Upload to Firebase
        var ref = storage.ref('Users/$currentEmail')
        .child(Timestamp.now().toString());
        var upload = await  ref.putFile(file).whenComplete(() async{
          ref.getDownloadURL().then((value) => addProfile(value.toString()));
        });
    }
      else {
        print('No Image Path Received');
      }
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.lightBlue,
              height: MediaQuery.of(context).size.height * .4,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            }, 
                            icon: Icon(Icons.arrow_back_ios,color: Colors.white,)
                        ),
                        Text(
                          currentUserName,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                            ),
                        ),
                        IconButton(
                          onPressed: () {
                            // addProfile(imageUrl);
                          }, 
                          icon: Icon(Icons.search,color: Colors.white,)
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          foregroundImage: NetworkImage(
                            profilePic.toString(),
                          ),
                          radius: 80,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 20,
                          child:  IconButton(
                            onPressed: (){
                              getImage();
                            }, 
                            icon: Icon(
                              Icons.add_a_photo,
                              size: 35,
                              color: Colors.white,
                            )
                        
                          )
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              //color: Colors.green,
              padding: EdgeInsets.all(30),
              height: MediaQuery.of(context).size.height * .5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Text(
                      'About me',
                      style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(),
                  Text(
                    'Name : '+ currentUserName,
                    style: TextStyle(fontSize: 20)
                  ),
                  Text(
                    'Mobile : '+ currentUserNumber,
                    style: TextStyle(fontSize: 20)
                  ),
                  Text(
                    'Email : ' + currentEmail,
                    style: TextStyle(fontSize: 20)
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  final FirebaseAuth auth = FirebaseAuth.instance;
  void inputData() {
    final User? user = auth.currentUser;
    currentEmail = user!.email.toString();
  }

 FirebaseFirestore firestore = FirebaseFirestore.instance;
  String currentEmail = '';
  String currentUserName = '';
  String currentUserNumber = '';
  String profilePic = '';
  Future getCurrentData() async{
      return await firestore
      .collection('Users')
      .doc(currentEmail)
      .get().then((snapshot) {
        setState(() {
          currentUserName = snapshot.get('Name').toString();
          currentUserNumber = snapshot.get('Mobile').toString();
          profilePic = snapshot.get('dp').toString();
        });
      });
    }
  
  addProfile(String url) async{
  return await firestore
  .collection('Users')
  .doc(currentEmail)
  .update({
      "dp": url
    });
  }
}

