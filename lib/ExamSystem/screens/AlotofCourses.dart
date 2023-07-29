import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutttter/Graduation%20project/screens/updateCreateCourse.dart';

import '../models/Course_model.dart';

class CoursesPage1234 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('courses').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final courses = snapshot.data!.docs
              .map((doc) =>CourseModel(
            course_id: (doc.data() as Map<String, dynamic>)['course_id'],
            course_name: (doc.data() as Map<String, dynamic>)['course_name'],
            doctor_id: (doc.data() as Map<String, dynamic>)['doctor_id'],
          )) .toList();

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Container(
                margin: EdgeInsets.all(15),
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
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Course Name: ${course.course_name}',
                              style: TextStyle(fontSize: 16.sp , fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Course ID: ${course.course_id}',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            Text(
                              'Doctor ID: ${course.doctor_id}',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Create_Course53(courseId: course.course_id ?? 'Default',doctor: course.doctor_id ?? 'Default'),
                                ),
                              );
                            },

                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              // Delete the course
                              await FirebaseFirestore.instance
                                  .collection('courses')
                                  .doc(course.course_id)
                                  .delete();

                             await FirebaseFirestore.instance
                                  .collection('ArchivedQuestions')
                                  .doc(course.course_name)
                                  .delete();

                              // Delete the course from all students
                              final studentsSnapshot = await FirebaseFirestore.instance
                                  .collection('users')
                                  .where('course', arrayContains: course.course_id)
                                  .get();

                              final batch = FirebaseFirestore.instance.batch();

                              studentsSnapshot.docs.forEach((studentDoc) {
                                final studentRef = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(studentDoc.id);

                                batch.update(studentRef, {
                                  'course': FieldValue.arrayRemove([course.course_id])
                                });
                              });

                              batch.commit();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
