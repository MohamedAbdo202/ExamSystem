// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class CoursesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('All Users Courses'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('users').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }
//
//           if (!snapshot.hasData) {
//             return Text('Loading...');
//           }
//
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               final user = snapshot.data!.docs[index];
//               final userRef = FirebaseFirestore.instance.collection('users').doc(user.id);
//               final coursesRef = userRef.collection('courses');
//
//               return StreamBuilder<QuerySnapshot>(
//                 stream: coursesRef.snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   }
//
//                   if (!snapshot.hasData) {
//                     return Text('Loading...');
//                   }
//
//                   final userCoursesDocs = snapshot.data!.docs;
//                   final userTotalDegree = userCoursesDocs.fold<double>(0, (sum, courseDoc) => sum + courseDoc['totalDegree']);
//
//                   return ListTile(
//                     title: Text(user.id),
//                     subtitle: Text('Total Degree: $userTotalDegree'),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoursesPage extends StatefulWidget {
  final String uId;

  CoursesPage({required this.uId});

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late CollectionReference coursesRef;

  @override
  void initState() {
    super.initState();
    final userRef = FirebaseFirestore.instance.collection('users').doc(widget.uId);
    coursesRef = userRef.collection('courses');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result')
        ,automaticallyImplyLeading: false,

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: coursesRef.where('showExam', isEqualTo: true).snapshots(),
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
              final course = snapshot.data!.docs[index];
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
              )]),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[ ListTile(
                    title: Text('CourseName: ${course['examid']}'),

                    contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: 2),
                    subtitle: Text('Degree: ${course['totalDegree']}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                    // trailing: Text('CourseName: ${course['examid']}'),
                  ),
                ]),


                // child: ListTile(
                //   title: SizedBox(
                //     height: 30,
                //     child: Text(course.id),
                //   ),
                //   contentPadding: EdgeInsets.symmetric(horizontal: 50),
                //   subtitle: SizedBox(
                //     height: 20,
                //     child: Text(
                //       'Degree: ${course['totalDegree']}',
                //       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                //     ),
                //   ),
                //   trailing: SizedBox(
                //     height: 30,
                //     child: Text('CourseName: ${course['examid']}'),
                //   ),
                // ),

              );
            },
          );
        },
      ),

    );
  }}