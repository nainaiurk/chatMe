// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AddStory extends StatefulWidget {
  const AddStory({ Key? key }) : super(key: key);

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your story'),
      ),
      body: Center(
        child: Container(
          color: Colors.lightBlue,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: (){}, 
                    icon: Icon(
                      Icons.add_a_photo,color: Colors.white,
                      size: 50,
                    )
                  ),
                  IconButton(
                    onPressed: (){}, 
                    icon: Icon(
                      Icons.edit,color: Colors.white,
                      size: 50,
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}