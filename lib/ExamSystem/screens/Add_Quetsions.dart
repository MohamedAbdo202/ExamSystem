import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Compenent/constant.dart';

class AddArchived extends StatefulWidget {
  final String profId;

  AddArchived({required String uId}) : profId = uId;

  @override
  State<AddArchived> createState() => _AddArchivedState();
}



class _AddArchivedState extends State<AddArchived> {
  @override
  final _formKey = GlobalKey<FormState>();
  String _courseName = '';
  String _courseId = '';
  String? _profId = uId;


  // Future<void> addExamToFirestore() async {
  //   final firestoreInstance = FirebaseFirestore.instance;
  //   final docSnapshot = await firestoreInstance
  //       .collection('users')
  //       .doc(_profId)
  //       .get();
  //
  //   print('docSnapshot.data(): ${docSnapshot.data()}');
  //   print('_profId: $_profId');
  //   print('_courseId: $_courseId');
  //
  //   if (docSnapshot.exists &&
  //       docSnapshot.data() != null &&
  //       docSnapshot.data()!['course'] != null &&
  //       docSnapshot.data()!['course'].contains(_courseId)) {
  //     await firestoreInstance
  //         .collection('ArchivedQuestions')
  //         .doc(_documentId)
  //         .set({
  //       'courseName': _courseName,
  //       'courseId': _courseId,
  //       'profId': _profId,
  //       'documentId': _documentId,
  //     });
  //   } else {
  //     print('Course ID not found in user courses');
  //     Fluttertoast.showToast(
  //       msg: 'Course ID not found',
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );      // Show a message to the user here that the course ID was not found in their courses
  //   }
  // }
  Future<void> addExamToFirestore() async {
    final firestoreInstance = FirebaseFirestore.instance;
    final docSnapshot = await firestoreInstance
        .collection('users')
        .doc(_profId)
        .get();

    if (docSnapshot.exists &&
        docSnapshot.data() != null &&
        docSnapshot.data()!['course'] != null &&
        docSnapshot.data()!['course'].contains(_courseId)) {

      final courseDocSnapshot = await firestoreInstance
          .collection('ArchivedQuestions')
          .where('courseId', isEqualTo: _courseId)
          .get();

      if (courseDocSnapshot.docs.isEmpty) {
        await firestoreInstance
            .collection('ArchivedQuestions')
            .doc(_courseName)
            .set({
          'courseName': _courseName,
          'courseId': _courseId,
          'profId': _profId,
        });
        Fluttertoast.showToast(
          msg: 'Exam added successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0.sp,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Exam with same courseId already exists',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0.sp,
        );
      }
    } else {
      print('Course ID not found in user courses');
      Fluttertoast.showToast(
        msg: 'Course ID not found',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0.sp,
      );      // Show a message to the user here that the course ID was not found in their courses
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Questions to students'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[


                SizedBox(height: 16.h),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Course Name',
                    hintText: 'Enter course name',
                    border:OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter course name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _courseName = value;
                  },
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Course ID',
                    hintText: 'Enter course ID',
                    border:OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter course ID';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _courseId = value;
                  },
                ),
                SizedBox(height: 2.h),

                SizedBox(height: 32.h),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Save the Exam data to Firestore
                        addExamToFirestore();
                        // Show a snackbar to indicate success
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //   content: Text('Exam added successfully!'),
                        // ));
                        // Clear the form fields
                        _formKey.currentState!.reset();
                      }
                    },
                    child: Text('Add Archived Practise'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
