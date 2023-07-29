import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutttter/Graduation%20project/Compenent/constant.dart';
import 'package:flutttter/Graduation%20project/screens/result_toprof.dart';

import 'HomePageToProffesore.dart';
import 'ShowExamToProffesore.dart';
import 'myprofile.dart';

class thissssss extends StatefulWidget {
  const thissssss({Key? key}) : super(key: key);

  @override
  State<thissssss> createState() => _thissssssState();
}

class _thissssssState extends State<thissssss> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Homeproff(uId: uId!),
    ExamCard2(uId: uId!,),
    ExamCard5(uId: uId!,),
    myprofile(),
  ];

  String? _token;

  void initState() {
    super.initState();
    // Get the FCM token when the widget is initialized
    FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        _token = token;
      });
      if (token != null) {
        // Update the token in Firestore
        FirebaseFirestore.instance.collection('users').doc(uId).update({
          'token': token,
        });
      }
    });
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // Prevent the user from going back to the LoginPage
      // Instead, close the app
      SystemNavigator.pop();
      return false;
    },

      child:Scaffold(

      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(fixedColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // ensures all labels are shown

        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.home,color:Colors.blue),
              label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.timelapse_outlined,color:Colors.blue),
            label: 'Exams',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail,color:Colors.blue),
            label: 'Results',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color:Colors.blue),
            label: 'Profile',
          )
        ],
      ),
    )

    );
  }
}




