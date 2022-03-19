// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
class StoryPage extends StatefulWidget {
  const StoryPage({ Key? key }) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final storyController = StoryController();
  @override
  Widget build(BuildContext context) {
    final controller = StoryController();

    // final List<StoryItem> storyItems = [
    //   StoryItem.text(
    //     title: "Everything Is Relative \n - Einstein",
    //     backgroundColor: Colors.red
    //   ),
    //    StoryItem.pageImage(
    //       url:
    //           "https://images.unsplash.com/photo-1541233349642-6e425fe6190e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",
    //       controller: StoryController()),
    //   StoryItem.pageImage(
    //       url:
    //           "https://techcrunch.com/wp-content/uploads/2015/08/safe_image.gif",
    //       caption: 'hello',
    //       shown: true,
    //       controller: storyController,
    //       imageFit: BoxFit.contain),

    // ];
    return Scaffold(
      body: Center(
        child: 
         StreamBuilder(
          stream: firestore.collection('Stories').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError){
              return Text('Something went wrong');
            }
            if (!snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            }
            else{
              var poster = '';
              var data = snapshot.data!.docs;
              int length = data.length;
              var storyItems =List.generate(length,(index) {
                  poster = data[index].get('poster');
                  if(data[index].get('type')=='text'){
                    return StoryItem.text(
                      title: data[index].get('text'), 
                      backgroundColor: Colors.lightBlue,
                    );
                  }
                  else{
                    return StoryItem.pageImage(
                      url: data[index].get('url').toString(),
                      caption: data[index].get('caption'),
                      controller: controller
                    );
                  }
                }
              );
              return  Container(
                child: Stack(
                  children: [
                    StoryView(
                      storyItems: storyItems,
                      controller: StoryController(),
                      progressPosition: ProgressPosition.top,
                      inline: false,
                      repeat: false,
                      onComplete: (){Navigator.pop(context);}
                    ),
                    Positioned(
                      top: 90,
                      left: 20,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(width: 20,),
                          Text(
                            poster,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 90,
                      right: 20,
                      child: IconButton(
                        onPressed: (){Navigator.pop(context);}, 
                        icon: Icon(Icons.cancel_outlined,
                        color: Colors.white,
                        )
                      )
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Future getCurrentData() async{
  //     return await firestore
  //     .collection('Users')
  //     .doc(currentEmail)
  //     .get().then((snapshot) {
  //       setState(() {
  //         currentUserName = snapshot.get('Name').toString();
  //         currentUserNumber = snapshot.get('Mobile').toString();
  //       });
  //     });
  //   }
}