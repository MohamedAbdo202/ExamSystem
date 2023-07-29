import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResultShow extends StatelessWidget {
  final String courseId;
  final String docId;
  final String profId;

  ResultShow({
    required this.courseId,
    required this.profId,
    required this.docId,
  });

  @override
  Widget build(BuildContext context) {
    CollectionReference usersRef =
    FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<DocumentSnapshot> matchingDocs = snapshot.data!.docs
              .where((doc) => doc['courses'][courseId] != null)
              .toList();

          return ListView.builder(
            itemCount: matchingDocs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot doc = matchingDocs[index];
              Map<String, dynamic> courseData = doc['courses'][courseId];
              String totalDegree = courseData['totalDegree'] != null
                  ? courseData['totalDegree'].toString()
                  : 'N/A';
              String examId = courseData['examid'] != null
                  ? courseData['examid'].toString()
                  : 'N/A';

              return ListTile(
                title: Text(doc['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Degree: $totalDegree'),
                    Text('Exam ID: $examId'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

