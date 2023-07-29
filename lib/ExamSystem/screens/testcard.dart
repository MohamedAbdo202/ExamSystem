import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamCard extends StatelessWidget {
  final String examId;


  ExamCard({required this.examId});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('exams').doc(examId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final examData = snapshot.data!.data() as Map<String, dynamic>;
        return Scaffold(appBar:AppBar() ,
          body: InkWell(onTap: (){},

            child: Container(width: double.infinity,
              height: 185.h,
              margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
        BoxShadow(
        color: Colors.blue.withOpacity(.8),
        blurRadius:10,
        offset: Offset(0, 3),
        ),
        ],
        ),
              child: Row(mainAxisAlignment:MainAxisAlignment.center,
                children:[ Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        examData['courseName'] ?? '',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Date: ${examData['date'] ?? ''}',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Course ID: ${examData['courseId'] ?? ''}',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Professor ID: ${examData['profId'] ?? ''}',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
