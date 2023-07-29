

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import '../themanager.dart';

class AddExamPage1 extends StatefulWidget {
  @override
  _AddExamPage1State createState() => _AddExamPage1State();
}

class _AddExamPage1State extends State<AddExamPage1> {
  final _formKey = GlobalKey<FormState>();
  DateTime _openTime = DateTime.now();
   DateTime _closeTime = DateTime.now();
   String _courseName = '';
  String _courseId = '';
  String _profId = '';
  String _docId ='';
  List<String> professorNames = [];
  List<String> _professorIds = [];
  void initState() {
    super.initState();
    fetchProfessorIds(); // Call the method to fetch professor IDs from Firestore
  }
  // List to store professor IDs
  Future<void> fetchProfessorIds() async {
    // Fetch professor IDs from Firestore

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'ADMIN')
        .get();

    final List<String> professorIds = querySnapshot.docs.map((doc) => doc.id).toList();
    final List<String> names = querySnapshot.docs.map((doc) => doc['name'] as String).toList();

    setState(() {
      _professorIds = professorIds;
      professorNames = names;

    });
  }



  // Function to add Exam to Firestore
  Future<void> addExamToFirestore() async {
    // Get the Firestore instance
    final firestoreInstance = FirebaseFirestore.instance;

    // Add the Exam data to Firestore
    await firestoreInstance.collection('exams').doc(_docId).set({
      'openTime': _openTime,
       'closeTime': _closeTime,
      'courseName': _courseName,
      'courseId': _courseId,
      'profId': _profId,
      'docId':_docId
    });
  }
  Future<void> addExamToFirestore353() async {
    // Get the Firestore instance
    final firestoreInstance = FirebaseFirestore.instance;

    // Add the Exam data to Firestore
    await firestoreInstance.collection('exams').doc(_docId).set({
      'openTime': _openTime,
      'closeTime': _closeTime,
      'courseName': _courseName,
      'courseId': _courseId,
      'profId': _profId,
      'docId':_docId
    });

    // Get enrolled students for the course
    final courseSnapshot = await firestoreInstance.collection('users').where('role', isEqualTo: 'USER').where('course', arrayContains: _courseId).get();
    final List<dynamic> enrolledStudents = courseSnapshot.docs.map((doc) => doc.data()).toList();

    // Send notifications to enrolled students
    final List<String> tokens = enrolledStudents.map((student) => student['token'] as String).toList();
    final message = {
      'notification': {
        'title': 'New Exam ',
        'body': 'A new exam for $_courseName is now available.'
      },
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'title': 'New Exam',
        '': 'A new exam for $_courseName is now available.'      }
    };

    final response = await sendFcmMessage(tokens, message);
    print('heyaaew');
    print('FCM Response: $response');
    print('done');

  }
  // Function to send FCM message as data message
  Future<http.Response> sendFcmMessage(List<String> tokens, Map<String, dynamic> message) async {
    // Get the Firebase Cloud Messaging server key
    final String serverKey = 'AAAAPrJMi4k:APA91bGKtEtvA8b2Lau09plnzN7fgMhBvZiyamMyHqbUoHAWlhVKK0c0yHQiZSpukzI2ee66kf4H9EOybskjYxZ5KQZV6RmT7VP5sGEj_YnJA7xA-TgJ-fLHFshrg9gBnZ1UvmN9NOiw';

    // Set the FCM message headers and payload
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };
    final payload = {
      'registration_ids': tokens,
      'data': message['data'],
    };

    // Send the FCM message using HTTP POST request
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headers,
      body: jsonEncode(payload),
    );
    print(response);

    return response;
  }

  String? _selectedProfessorId; // Update the field declaration


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Exam'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _openTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (picked != null) {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_openTime),
                      );
                      if (pickedTime != null) {
                        _openTime = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        setState(() {});
                      }
                    }
                  },
                  child: Text('Pick Exam Open Time'),
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _closeTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (picked != null) {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_closeTime),
                      );
                      if (pickedTime != null) {
                        _closeTime = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        setState(() {});
                      }
                    }
                  },
                  child: Text('Pick Exam Close Time'),
                ),
                SizedBox(height: 16.h),
                SizedBox(height: 16.h),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter Exam Name',
                    hintText: 'EnterName',
                    border:OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter docId';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _docId = value;
                  },
                ),
                SizedBox(height: 16.h
                ),

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
                    fetchProfessorIds(); // Fetch professor IDs when course ID is changed

                  },
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      // Other form fields...
                      DropdownButtonFormField<String>(
                        value: _selectedProfessorId,
                        onChanged: (value) {
                          setState(() {
                            _selectedProfessorId = value;
                            _profId = _selectedProfessorId!;

                          });
                        },
                        items: _professorIds.map((id) {
                          final index = _professorIds.indexOf(id);
                          final name = professorNames[index];
                          return DropdownMenuItem<String>(
                            value: id,
                            child: Text(name),
                          );
                        }).toList(),
                        hint: Text('Select Professor'),
                        decoration: InputDecoration(
                          labelText: 'Select Professor',
                          hintText: 'Select Professor',
                          border:OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a professor';
                          }
                          return null;
                        },
                      ),


                      SizedBox(height: 32.h),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Save the Exam data to Firestore
                        addExamToFirestore353();
                        // Show a snackbar to indicate success
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Exam added successfully!'),
                        ));
                        // Clear the form fields
                        _formKey.currentState!.reset();
                        _profId = _selectedProfessorId!;

// Reset the open and close time to current time
                        _openTime = DateTime.now();
                        _closeTime = DateTime.now();
                        setState(() {});
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                themanager()  ));
                      }
                    },
                    child: Text('Add Exam'),
                  ),
                ),
              ],
            ),
          ),
        ]))),
      ),
    );
  }
}