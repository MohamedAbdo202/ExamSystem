  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

  import '../Compenent/constant.dart';
  import '../screens/BottomNavBarAdmin.dart';
  import '../screens/BottomNavigationForStudent.dart';
  class QuizResult1 extends StatefulWidget {
    const QuizResult1({
      Key? key,
      required this.degree,
      required this.docId,
      required this.totalDegree,
      required this.courseId,
    }) : super(key: key);

    final String docId;
    final String courseId;
    final int degree;
    final int totalDegree;

    @override
    _QuizResult1State createState() => _QuizResult1State();
  }

  class _QuizResult1State extends State<QuizResult1> {
    Future<void> addCourseAndGrade(
        String uId, String courseId, int degree, String docId) async {
      try {
        final userRef = FirebaseFirestore.instance.collection('users').doc(uId);
        await userRef.collection('courses').doc(docId).set({'totalDegree': degree});
        await userRef.collection('courses').doc(docId).update({'examid': docId});
        await userRef.collection('courses').doc(docId).update({'showExam': false});


        print('Course and grade added successfully');
        degree = 0;
      } catch (e) {
        print('Error adding course and grade: $e');
      }
    }

    void submitGrade() {
      addCourseAndGrade(uId!, widget.courseId, widget.degree, widget.docId);
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(                automaticallyImplyLeading: false,

          title: Text(
            'Test Results',
            style: TextStyle(
              fontSize: 20.sp,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(height: 50.h),
              SizedBox(height: 20.h,),
              Text(
                'Thank You For Taking The Exam',
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h,),
              SizedBox(height: 24.h,),
              GestureDetector(
                onTap: () {submitGrade();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => suiii()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Go to Home",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h,),
            ],
          ),
        ),
      );
    }
  }
