import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../Shared/components/components.dart';
import '../Compenent/constant.dart';
import '../Quiz_app/input_quesitons.dart';
// هنا الصحححححححححححححححح
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../Compenent/constant.dart';
import '../Quiz_app/input_quesitons.dart';
import 'EditQuestions.dart';
class ExamCard2 extends StatelessWidget {
  final String profId;

  ExamCard2({required String uId}) : profId = uId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('exams')
          .where('profId', isEqualTo: profId).where('openTime', isGreaterThan: DateTime.now())
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final examDocs = snapshot.data!.docs;
        if (examDocs.isEmpty) {
          return Center(child: Text('No exams found for this professor'));
        }
        return Scaffold(
          appBar: AppBar(title: Text('Exams for Professor $profId')
                       ,automaticallyImplyLeading: false,
          ),
          body: ListView.builder(
            itemCount: examDocs.length,
            itemBuilder: (context, index) {
              final examData = examDocs[index].data() as Map<String, dynamic>;
              final openTime = examData['openTime']?.toDate();
              final closeTime = examData['closeTime']?.toDate();
              final formattedOpenTime = DateFormat.yMd().add_jm().format(openTime ?? DateTime.now());
              final formattedCloseTime = DateFormat.yMd().add_jm().format(closeTime ?? DateTime.now());
              return Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              AddQuestion(examData['docId'] ?? '')));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 150.h,
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
                              width: 105.w
                              ,
                              height: 110.h,
                            ),
                            SizedBox(width: 10.w
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),

                                  child: Text(
                                    'Course Name: ${examData['courseName'] ?? ''}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'Start Time: $formattedOpenTime',
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'End Time: $formattedCloseTime',
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ),
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
                    child: defaultButton(
                      width: 100.w
                      ,
                      function: () {
                        // Handle edit button press here
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EditQuestion(uId:examData['docId'] )));
                      },
                      text: "Edit",
                    ),
                  ),
                ],
              );
              ;
            },
          ),
        );
      },
    );
  }
}
