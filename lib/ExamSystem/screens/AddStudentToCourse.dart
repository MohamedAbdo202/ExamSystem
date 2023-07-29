import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyPage1 extends StatefulWidget {
  @override
  _MyPage1State createState() => _MyPage1State();
}

class _MyPage1State extends State<MyPage1> {
  var _studentIdController = TextEditingController();
  final _courseIdsController = TextEditingController();
  final _firestoreInstance = FirebaseFirestore.instance;
  List<String> professorNames = [];
  List<String> _professorIds = [];
  String? _selectedProfessorId; // Update the field declaration

  void initState() {
    super.initState();
    fetchProfessorIds(); // Call the method to fetch professor IDs from Firestore
  }

  // List to store professor IDs
  Future<void> fetchProfessorIds() async {
    // Fetch professor IDs from Firestore

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'USER')
        .get();

    final List<String> professorIds =
    querySnapshot.docs.map((doc) => doc.id).toList();
    final List<String> names =
    querySnapshot.docs.map((doc) => doc['name'] as String).toList();

    setState(() {
      _professorIds = professorIds;
      professorNames = names;
    });
  }

  void addCoursesToStudent() async {
    final studentId = _studentIdController.text;
    final courseIds = _courseIdsController.text.split(',');

    if (studentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a student')),
      );

      return;
    }

    if (courseIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter course IDs')),
      );
      return;
    }


    if (courseIds.isEmpty || courseIds[0].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter course IDs')),
      );
      return;
    }


    // Get a reference to the student document
    final studentRef = _firestoreInstance.collection('users').doc(studentId);

    // Add each course ID to the "enrolledCourses" array field of the student document
    await studentRef.update({
      'course': FieldValue.arrayUnion(courseIds.map((id) => id.trim()).toList()),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Courses added to student successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Courses to Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                        _studentIdController.text = _selectedProfessorId!;
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
                    hint: Text('Select Student'),
                    decoration: InputDecoration(
                      labelText: 'Select Student',
                      hintText: 'Select Student',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a student';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8.0.h),

                  TextField(
                    controller: _courseIdsController,
                    decoration: InputDecoration(
                      labelText: 'Course IDs (comma separated)',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0.h),
                  ElevatedButton(
                    onPressed: addCoursesToStudent,
                    child: Text('Add Courses to Student'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
