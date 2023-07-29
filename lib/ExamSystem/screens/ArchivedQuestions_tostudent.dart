import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Quiz_app/QuizAppLayoutArchived.dart';
import '../Quiz_app/quizapp_layout.dart';

class ShowArchived extends StatelessWidget {
  final String uId;

  ShowArchived({required this.uId});
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
          return Center(child: Text('Please enroll in a course.'));
        }
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('ArchivedQuestions').where('courseId', whereIn: courses).snapshots(),
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
              appBar: AppBar(title: Text('Practise for selected courses')                ,automaticallyImplyLeading: false,
              ),
              body: ListView.builder(
                itemCount: examDocs.length,
                itemBuilder: (context, index) {
                  final examData = examDocs[index].data() as Map<String, dynamic>;
                  return InkWell(
                    onTap: () {
                      final questionsCollection = FirebaseFirestore
                          .instance
                          .collection('ArchivedQuestions')
                          .doc(examData['courseName'])
                          .collection('questions');

                      questionsCollection.get().then((querySnapshot) {
                        if (querySnapshot.docs.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'No questions found for this exam.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>

                                  Quiz_App_Layout2(
                                    docId: examData['courseName'] ?? '',
                                    courseId: examData['courseId'] ?? '',
                                  ),
                            ),
                          );
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 155,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2,horizontal:2),
                                child: Text(
                                  'Course Name: ${examData['courseName'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                                child: Text(
                                  'Course ID: ${examData['courseId'] ?? ''}',
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );  }
}
