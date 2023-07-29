import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutttter/Graduation%20project/screens/studentsdataresult.dart';
import 'package:flutttter/Graduation%20project/screens/submitresultforProfessore.dart';
import 'package:intl/intl.dart';

import '../Compenent/constant.dart';
import '../Quiz_app/input_quesitons.dart';
// هنا الصحححححححححححححححح
class ExamCard5 extends StatelessWidget {
  final String profId;


  ExamCard5({required String uId}) : profId = uId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('exams').where('profId', isEqualTo: profId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());

        }
        final examDocs = snapshot.data!.docs;
        if (examDocs.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),



              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.lighten),

                // repeat: ImageRepeat.repeat,

                image: AssetImage('assets/images/back.png'),

              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, 10,
                  ),
                )],
            ),
            child: Scaffold(
              //     automaticallyImplyLeading: false,

            backgroundColor: Colors.transparent,
                appBar: AppBar(title: Text('Result'),
                      automaticallyImplyLeading: false,
                ),

                body: Padding(
                  padding: EdgeInsets.all
                    (50),
                    child: Column(children:[ Text('No exams found for this professor')]))),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text('Result'),

            automaticallyImplyLeading: false,
          ),

          backgroundColor: Colors.transparent,

          body: ListView.builder(
            itemCount: examDocs.length,
            itemBuilder: (context, index) {
              final examData = examDocs[index].data() as Map<String, dynamic>;

              final examData2 = examDocs[index].data() as Map<String, dynamic>;

              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoursesPage5(courseId: examData['courseId'] ?? '' ,docId: examData['docId']??'',)));

                  // TODO: Implement onTap callback
                },
                child: Container(
                  width: double.infinity,
                  height: 145.h
                  ,
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.8),
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
                        Image(image: AssetImage('assets/images/image2.png'),width: 105.w,height: 130.h,),
                        SizedBox(width: 15.w),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                'Course Name: ${examData['courseName'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                'Date: ${DateFormat('MMM dd, yyyy').format(examData['closeTime'].toDate())}',
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                'Course ID: ${examData['courseId'] ?? ''}',
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}