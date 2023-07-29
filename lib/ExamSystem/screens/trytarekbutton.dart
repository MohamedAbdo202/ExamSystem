import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutttter/Graduation%20project/screens/AddExam.dart';
import 'package:flutttter/Shared/components/components.dart';
import 'package:intl/intl.dart';

class ExamsPage1234 extends StatelessWidget {
  final CollectionReference exams =
  FirebaseFirestore.instance.collection('exams');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exams'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: exams.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data =
              document.data()! as Map<String, dynamic>;
              final openTime = data['openTime']?.toDate();
              final closeTime = data['closeTime']?.toDate();
              final formattedOpenTime =
              DateFormat.yMd().add_jm().format(openTime ?? DateTime.now());
              final formattedCloseTime =
              DateFormat.yMd().add_jm().format(closeTime ?? DateTime.now());
              return Stack(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image(
                              image: AssetImage('assets/images/image1.png'),
                              width: 130.w
                              ,
                              height: 120.h,
                            ),
                            SizedBox(width: 15.w
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data['courseName']),
                                Text(data['courseId']),
                                Text(formattedOpenTime),
                                Text(formattedCloseTime),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Handle delete button press here
                            FirebaseFirestore.instance
                                .collection('exams')
                                .doc(data['docId'])
                                .delete();
                          },
                        ),
                        SizedBox(width: 5.w),
                        defaultButton(
                          width: 100.w
                          ,
                          function: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    AddExamPage( docId: data['docId'], )));
                          },
                          text: "Edit",
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
