import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../Compenent/constant.dart';
import '../Quiz_app/input_quesitons.dart';
import '../Quiz_app/quizapp_layout.dart';

class ExamCard3 extends StatelessWidget {
  final String uId;

  ExamCard3({required this.uId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: FirebaseFirestore.instance.collection('users').doc(uId).get().then((doc) => List.from(doc['course'] ?? [])),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final courses = snapshot.data!;
        if (courses.isEmpty) {
          return Center(child: Text('Please Enroll in a Course To Get Exam.'));
        }
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('exams').where('courseId', whereIn: courses).where('closeTime', isGreaterThan: DateTime.now())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final examDocs = snapshot.data!.docs;
            if (examDocs.isEmpty) {
              return Center(child: Text('No exams found for these courses'));
            }

            return Scaffold(
              appBar: AppBar(title: Text('Exams for selected courses')                ,automaticallyImplyLeading: false,
              ),
              body: ListView.builder(
                itemCount: examDocs.length,
                itemBuilder: (context, index) {
                  final examData = examDocs[index].data() as Map<String, dynamic>;
                  final openTime = examData['openTime']?.toDate();
                  final closeTime = examData['closeTime']?.toDate();
                  final formattedOpenTime = DateFormat.yMd().add_jm().format(openTime ?? DateTime.now());
                  final formattedCloseTime = DateFormat.yMd().add_jm().format(closeTime ?? DateTime.now());
                  final now = DateTime.now();

                  // Calculate the difference between open time and close time
                  final difference = closeTime?.difference(now);
                  final formattedDifference = difference != null ? '${difference.inHours} hours ${difference.inMinutes.remainder(60)} minutes'.replaceAll(' hours', 'h').replaceAll(' minutes', 'm') : '';

                  // Exam is currently open
                  return InkWell(
            onTap: () async {
            final userRef = FirebaseFirestore.instance.collection('users').doc(uId);
            final coursesRef = userRef.collection('courses');

            // Check if the course exists for the user
            final courseSnapshot = await coursesRef.doc(examData['docId']).get();

            if (courseSnapshot.exists) {
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
            content: Text('you have take the exam thank you'),
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 4000),
            ),
            );
            return;
            }


                      if (openTime != null && now.isBefore(openTime)) {
                        // Exam has not started yet
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Exam has not started yet'),
                          backgroundColor: Colors.red,
                          duration: Duration(milliseconds: 4),
                        ));
                      } else if (closeTime != null && now.isAfter(closeTime)) {
                        // Exam has already ended
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Exam has already ended'),
                          backgroundColor: Colors.red,
                          duration: Duration(milliseconds: 4),
                        ));
                      } else {
                        // Exam is currently open
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Navigating to exam'),
                          backgroundColor: Colors.green,
                          duration: Duration(milliseconds: 4),
                        ));
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Quiz_App_Layout(
                            difference: formattedDifference,
                            docId: examData['docId'] ?? '',
                            courseId: examData['courseId'] ?? '',
                            opentime: formattedOpenTime,
                            endtime: formattedCloseTime,
                          ),
                        ));
                      }
                    },


                  child: Container(
    width: double.infinity,
    height: 135.h,
    margin: EdgeInsets.all(16),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    color: Colors.white,
    boxShadow: [
    BoxShadow(
    color: Colors.blue.withOpacity(.8),
    blurRadius: 10,
    offset: Offset(0, 3),
    ),
    ],
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Padding(
    padding: const EdgeInsets.only(top: 2),
    child: Text(
    'Course Name: ${examData['courseName'] ?? ''}',
    style: TextStyle(
    fontSize: 12.sp,
    // fontWeight: FontWeight.bold,
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10),
    child: Text(
    'Start Time: $formattedOpenTime',
    style: TextStyle(fontSize: 12.sp),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10),
    child: Text(
    'End Time: $formattedCloseTime',
    style: TextStyle(fontSize: 12.sp),
    ),
    ),
    ],
    ),

    ],
    ),
    ),
    );
    }

             )
        ,
    );
    },
    );
    }
    );  }
      }