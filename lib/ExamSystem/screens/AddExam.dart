import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddExamPage extends StatefulWidget {
  @override

  final String docId;

  AddExamPage({ required this.docId}) ;
  _AddExamPageState createState() => _AddExamPageState();
}

class _AddExamPageState extends State<AddExamPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime _openTime = DateTime.now();
  DateTime _closeTime = DateTime.now();
  String _courseName = '';
  String _courseId = '';

  // Function to add Exam to Firestore
  Future<void> addExamToFirestore353() async {
    // Get the Firestore instance
    final firestoreInstance = FirebaseFirestore.instance;

    // Add the Exam data to Firestore
    await firestoreInstance.collection('exams').doc(widget.docId).update({
      'openTime': _openTime,
      'closeTime': _closeTime,
      'courseName': _courseName,
      'courseId': _courseId,
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Edit Exam'),
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
// Reset the open and close time to current time
                        _openTime = DateTime.now();
                        _closeTime = DateTime.now();
                        setState(() {});                      }
                    },
                    child: Text('Add Exam'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}