import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Shared/components/components.dart';
import 'inputEditQuestion.dart';

class EditQuestion extends StatelessWidget {
  final String profId;

  EditQuestion({required String uId}) : profId = uId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Question'),
        ),
        body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('exams')
          .doc(profId) // replace with the document ID of the exam
          .collection('questions') // the subcollection of questions
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final questionDocs = snapshot.data!.docs;
        if (questionDocs.isEmpty) {
          return Center(child: Text('No questions found for this exam'));
        }
        return ListView.builder(
          itemCount: questionDocs.length,
          itemBuilder: (context, index) {
            final questionData = questionDocs[index].data() as Map<String, dynamic>;
            final questionText = questionData['question'];
            final option1 = questionData['option1'];
            final option2 = questionData['option2'];
            final option3 = questionData['option3'];
            final option4 = questionData['option4'];


            return Stack(
              children:[ InkWell(
                onTap: (){
                  String questionId = questionDocs[index].id;

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AddQuestion123(
                              quizId: profId,
                              questionId: questionId,
                            ),
                    ));

                },
                child: Padding(padding: EdgeInsets.symmetric(horizontal: 30 ),
                  child: Container(
                    width: 340.w
                    ,
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
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(height: 10.h),
                            Text(
                              'Question: $questionText',
                              style: TextStyle(fontSize: 16.sp),
                              overflow: TextOverflow.ellipsis, // show '...' when the text overflows
                              maxLines: 2, // show up to 2 lines of text
                            ),

                            SizedBox(height: 10.h
                            ),
                            Text(
                              'Option 1: $option1',
                              style: TextStyle(fontSize: 14.sp),
                              overflow: TextOverflow.ellipsis, // show '...' when the text overflows

                            ),
                            Text(
                              'Option 2: $option2',
                              style: TextStyle(fontSize: 14.sp),
                              overflow: TextOverflow.ellipsis, // show '...' when the text overflows

                            ),
                            Text(
                              'Option 3: $option3',
                              style: TextStyle(fontSize: 14.sp),
                              overflow: TextOverflow.ellipsis, // show '...' when the text overflows

                            ),
                            Text(
                              'Option 4: $option4',
                              style: TextStyle(fontSize: 14.sp),
                              overflow: TextOverflow.ellipsis, // show '...' when the text overflows

                            ),
                            // Add more widgets to display the rest of the question data
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
                Positioned(
                  bottom: 5,
                  right: 45,
                  child: IconButton(onPressed: (){
                    String questionId = questionDocs[index].id;

                    FirebaseFirestore.instance
                        .collection('exams')
                        .doc(profId)
                        .collection('questions')
                        .doc(questionId)
                        .delete();
                  }, icon: Icon(Icons.delete_forever,size: 40,))
                ),

            ]);
          },
        );
        ;
      },
    ));

  }
}
