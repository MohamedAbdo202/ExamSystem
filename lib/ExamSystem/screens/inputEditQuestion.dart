import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutttter/Graduation%20project/Quiz_app/quiz_logo.dart';
import 'package:flutttter/Graduation%20project/Quiz_app/quizapp_layout.dart';

import 'EditQuestions.dart';

class AddQuestion123 extends StatefulWidget {
  final String quizId;
  final String questionId;

  AddQuestion123({
    required this.quizId,
    required this.questionId,
  });

  @override
  _AddQuestion123State createState() => _AddQuestion123State();
}

class _AddQuestion123State extends State<AddQuestion123> {
  CollectionReference? questions;

  final _formKey = GlobalKey<FormState>();
  var questioncontroller = TextEditingController();
  var option1Controller = TextEditingController();
  var option2Controller = TextEditingController();
  var option3Controller = TextEditingController();
  var option4Controller = TextEditingController();
  bool isLoading = false;
  int counter=0;
  String question = "",
      option1 = "",
      option2 = "",
      option3 = "",
      option4 = "";

  @override
  void initState() {
    super.initState();
    // Initialize questions collection reference in initState
    questions = FirebaseFirestore.instance
        .collection('exams')
        .doc(widget.quizId)
        .collection('questions');
  }

  Future<void> addQuestion() async {
    setState(() {
      isLoading = true;
    });

    // Validate the form and retrieve the form data
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Add the new question to Firestore
      try {
        await questions?.doc(widget.questionId).update({
          'question': question,
          'option1': option1,
          'option2': option2,
          'option3': option3,
          'option4': option4,
          'counter':counter,
        });
        print('New question added to Firestore');
      } catch (e) {
        print('Error adding new question to Firestore: $e');
      }

      // Clear the form fields
      questioncontroller.clear();
      option1Controller.clear();
      option2Controller.clear();
      option3Controller.clear();
      option4Controller.clear();
    }

    setState(() {
      isLoading = false;
    });
  }






  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black54,
        ),
        title: AppLogo(),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
          : Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TextFormField(
                validator: (val) => val!.isEmpty ? "question must not be empty " : null,
                decoration: InputDecoration(hintText: "question"),
                onChanged: (val) {
                  setState(() {
                    question = val;
                  });
                },
              ),
              SizedBox(
                height: 5.h,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Option1 must not be empty " : null,
                decoration:
                InputDecoration(hintText: "Option1 (Correct Answer)"),
                onChanged: (val) {
                  setState(() {
                    option1 = val;
                  });
                },
                controller: option1Controller,
              ),
              SizedBox(
                height: 8.h,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Option2 must not be empty " : null,
                decoration: InputDecoration(hintText: "Option2"),
                onChanged: (val) {
                  setState(() {
                    option2 = val;
                  });
                },
              ),
              SizedBox(
                height: 8.h,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Option3 must not be empty" : null,
                decoration: InputDecoration(hintText: "Option3"),
                onChanged: (val) {
                  setState(() {
                    option3 = val;
                  });
                },
              ),
              SizedBox(
                height: 8.h,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Option4 must not be empty" : null,
                decoration: InputDecoration(hintText: "Option4"),
                onChanged: (val) {
                  setState(() {
                    option4 = val;
                  });
                },
              ),

              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()){
                    await addQuestion();
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  AddQuestion123(
                          quizId: widget.quizId,
                          questionId: widget.questionId,
                        ),)
                    );
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 200.w,
                  height: 50.h,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.blue,
                  child: Text(
                    "Add Question",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  EditQuestion(uId: widget.quizId,

                      ),)
                  );

                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: 200.w,
                  height: 50.h,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: Text(
                    "EndEdit",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
