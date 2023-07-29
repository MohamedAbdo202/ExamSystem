
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutttter/Graduation%20project/Quiz_app/quiz_logo.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../models/Question_model.dart';
class AddQuestion extends StatefulWidget {
  final String quizId;
  AddQuestion(this.quizId);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {



  File? _selectedFile;
  List<QuestionModel>? _questions;
  Future<void> _getFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }


  Future<void> _sendFile() async {
    if (_selectedFile == null) {
      return;
    }

    final url = Uri.parse('http://192.168.54.166:4000/extract_qa');
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', _selectedFile!.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      print(response);
      final jsonResponse = jsonDecode(await response.stream.bytesToString());

      if (jsonResponse != null) {
        final questionsMap = jsonResponse['Questions'];
        final answer1Map = jsonResponse['Answer_1'];
        final answer2Map = jsonResponse['Answer_2'];
        final answer3Map = jsonResponse['Answer_3'];
        final answer4Map = jsonResponse['Answer_4'];

        final questions = questionsMap.values.toList().cast<String>();
        final answer1 = answer1Map.values.toList().cast<String>();
        final answer2 = answer2Map.values.toList().cast<String>();
        final answer3 = answer3Map.values.toList().cast<String>();
        final answer4 = answer4Map.values.toList().cast<String>();

        final questionModels = List.generate(
          questions.length,
              (index) => QuestionModel(
            question: questions[index],
            option1: answer1[index],
            option2: answer2[index],
            option3: answer3[index],
            option4: answer4[index],
            correctOption: answer1[index],
            answered: false,
          ),
        );

        setState(() {
          _questions = questionModels;
        });


        // Send questions to Firebase
        for (final q in questionModels) {
          await FirebaseFirestore.instance.collection('exams')
              .doc(widget.quizId)
              .collection('questions').add({
            'question': q.question,
            'option1': q.option1,
            'option2': q.option2,
            'option3': q.option3,
            'option4': q.option4,
            'counter':counter,

          });
        }
      }

    }
  }



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
        await questions?.add({
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
        title: Text('Add Questions',style: TextStyle(color:Colors.black)),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(


                  validator: (val) => val!.isEmpty ? "Question Shouldn`t be empety " : null,
                  decoration: InputDecoration(hintText: "Question"
                  ,      border:OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),

                  ),
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
                  InputDecoration(hintText: "Option1 (Correct Answer)",
                    border:OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),),
                  onChanged: (val) {
                    setState(() {
                      option1 = val;
                    });
                  },
                  controller: option1Controller,
                ),
                SizedBox(
                  height: 5.h,
                ),
                TextFormField(
                  validator: (val) => val!.isEmpty ? "Option2 must not be empty " : null,
                  decoration: InputDecoration(hintText: "Option2",
                    border:OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),),
                  onChanged: (val) {
                    setState(() {
                      option2 = val;
                    });
                  },
                ),
                SizedBox(
                  height: 5.h,
                ),
                TextFormField(
                  validator: (val) => val!.isEmpty ? "Option3 must not be empty" : null,
                  decoration: InputDecoration(hintText: "Option3",
                    border:OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),),
                  onChanged: (val) {
                    setState(() {
                      option3 = val;
                    });
                  },
                ),
                SizedBox(
                  height: 5.h,
                ),
                TextFormField(
                  validator: (val) => val!.isEmpty ? "Option4 must not be empty" : null,
                  decoration: InputDecoration(hintText: "Option4",
                    border:OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),),
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
                          MaterialPageRoute(builder: (context) => AddQuestion(widget.quizId))
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 180.w,
                    height: 45.h,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.blue,
                    child: Text(
                      "Add Question",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ), SizedBox(width: 30.w),
                SizedBox(height: 5.h,),
                GestureDetector(
                  onTap: () async {
                   await _getFile();
                    await _sendFile() ;                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: 180.w,
                    height: 45.h,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: Text(
                      "Upload  File",
                      style: TextStyle(
                        fontSize: 15.sp,
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
      ),
    );
  }

}
