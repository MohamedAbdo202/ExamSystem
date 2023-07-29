
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutttter/Graduation%20project/screens/visualization_page.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CoursesPage5 extends StatelessWidget {
  final String courseId;
  final String docId;

  CoursesPage5({required this.courseId, required this.docId});
  List<int> courseDegrees = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Users Courses'),
      ),
      body:Column(children: [   ElevatedButton(
        onPressed: () {
          // Change all showExam values to true
          FirebaseFirestore.instance.collection('users').get().then((querySnapshot) {
            querySnapshot.docs.forEach((userDoc) {
              userDoc.reference.collection('courses').doc(docId).update({'showExam': true});
            });
          });
        },
        child: Text('Mark All Exams as Shown'),
      ),   SizedBox(height: 10.h),


        ElevatedButton(
          onPressed: () async {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VisualizationPage(courseId: courseId, userDegrees: courseDegrees,docId:docId ),
              ),
            );
          },
          child: Text('View Visualization'),
        ),
        SizedBox(height: 10.h),
        ElevatedButton(
          onPressed: () async {
            List<String> names = [];
            List<int> degrees = [];

            // Retrieve users' names and degrees
            final snapshot = await FirebaseFirestore.instance.collection('users').get();

            for (final userDoc in snapshot.docs) {
              final userRef = FirebaseFirestore.instance.collection('users').doc(userDoc.id);
              final coursesRef = userRef.collection('courses');

              final userCoursesSnapshot = await coursesRef.get();
              final userCoursesDocs = userCoursesSnapshot.docs.where((doc) => doc.id == docId).toList();

              if (userCoursesDocs.isNotEmpty) {
                final userTotalDegree = userCoursesDocs.first['totalDegree'];
                final userName = (await userRef.get())['name'].toString();

                degrees.add(userTotalDegree!); // Assert non-null with '!'
                names.add(userName);
              }
            }

            // Export to Excel
            final excel = Excel.createExcel();
            final sheet = excel['Sheet1'];

            // Add headers to the sheet
            sheet.appendRow(['Name', 'Degree']);

            // Add data rows to the sheet
            for (int i = 0; i < names.length; i++) {
              sheet.appendRow([names[i], degrees[i]!]); // Assert non-null with '!'
            }

            // Get the documents directory
            final appDocumentsDirectory = await getApplicationDocumentsDirectory();

            // Build the file path
            final filePath = '${appDocumentsDirectory.path}/users_data.xlsx';

            // Save the Excel file
            final file = File(filePath);
            await file.writeAsBytes(excel.encode()!);

            // Show a snackbar to indicate the export operation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Data exported to Excel'),
              ),
            );

            // Open the Excel file for download
            await OpenFile.open(filePath);
          },
          child: Text('Export to Excel'),
        ),



        Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return Text('Loading...');
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final user = snapshot.data!.docs[index];
                final userRef = FirebaseFirestore.instance.collection('users').doc(user.id);
                final coursesRef = userRef.collection('courses');

                return StreamBuilder<QuerySnapshot>(
                  stream: coursesRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData) {
                      return Text('Loading...');
                    }

                    final userCoursesDocs = snapshot.data!.docs.where((doc) => doc.id == docId).toList();
                    if (userCoursesDocs.isEmpty) {
                      return SizedBox.shrink();
                    }

                    final userTotalDegree = userCoursesDocs.first['totalDegree'];
                    final userName = userRef.get().then((userDoc) => userDoc['name']);

                    courseDegrees.add(userTotalDegree);

                    return FutureBuilder<dynamic>(
                      future: userName,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            final userName = snapshot.data;
                            return Container(
                              width: double.infinity,
                              height: 100.h,
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10.h,),
                                  Text('ID: ${user.id}'),
                                  SizedBox(height: 10.h
                                    ,),
                                  Text('Name: $userName'),
                                  SizedBox(height: 10.h,),
                                  Text('Course Degree: $userTotalDegree'),
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return SizedBox.shrink();
                          }
                        } else {
                          return Text('Loading...');
                        }
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      )]),
    );
  }
}

