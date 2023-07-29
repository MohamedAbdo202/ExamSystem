import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Quiz_app/Input_for_theArchived.dart';
import '../Quiz_app/input_quesitons.dart';
import 'Add_Quetsions.dart';

class Homeproff extends StatelessWidget {
  final String profId;


  Homeproff({required String uId}) : profId = uId;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('ArchivedQuestions').where('profId', isEqualTo: profId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());

        }
        final examDocs = snapshot.data!.docs;
        if (examDocs.isEmpty) {
          return Scaffold(body:Center(child: Text('Add Questions To Students'),
          )
          , floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddArchived(uId:profId ,)));


// do something when the button is pressed
              },
              child: Icon(Icons.add),
            ),);
        }
        return Scaffold(
          appBar: AppBar(title: Text('Archived for Professor $profId')


                ,automaticallyImplyLeading: false,

                elevation: 0,


          ),
          body: ListView.builder(
            itemCount: examDocs.length,
            itemBuilder: (context, index) {
              final examData = examDocs[index].data() as Map<String, dynamic>;
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddQuestion2( examData['courseName'] ?? '')));

                  // TODO: Implement onTap callback
                },
                child: Container(
                  width: double.infinity,
                  height: 145.h,
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
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image(image: AssetImage('assets/images/image1.png'),width: 105.w
                          ,height: 110.h,),


                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment:MainAxisAlignment.center ,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 4),

                              child: Text(
                                'Course Name: ${examData['courseName'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 20),
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
          floatingActionButton: FloatingActionButton(
onPressed: () {
Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddArchived(uId:profId ,)));


// do something when the button is pressed
},
child: Icon(Icons.add),
),
        );
      },
    );
  }
}

// floatingActionButton: FloatingActionButton(
// onPressed: () {
// Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddArchived(uId:widget.profId ,)));
//
//
// // do something when the button is pressed
// },
// child: Icon(Icons.add),
// ),
