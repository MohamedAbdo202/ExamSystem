import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle, rootBundle;
import 'package:flutttter/Graduation%20project/Quiz_app/quiz_logo.dart';


class pick_json extends StatefulWidget {
  const pick_json({Key? key}) : super(key: key);

  @override
  State<pick_json> createState() => _pick_jsonState();
}
class _pick_jsonState extends State<pick_json> {


  List<List<dynamic>> _data = [];
  String? filepath;
  CollectionReference questions = FirebaseFirestore.instance.collection(
      'questions');
  List<dynamic> JsontoList (String jsonStr){
    return jsonDecode(jsonStr);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black54,
        ),
        title: AppLogo(),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //brightness: Brightness.li,
      ),
      body: Column(
        children: [

          Center(
            child: Container(
              width: 150,
              height: 50,

              child: ElevatedButton(
                child: const Text("Upload json FIle",
                  style: TextStyle(fontSize: 15),),
                onPressed: () {
                  _pickFile();
                  print('done');
                  //   add_multiple_questions(_data);
                },
              ),

            ),
          ),
        ],
      ),

    );
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    print(result.files.first.name);

    late final  filepath = File(result.files.first.path!.toString());
    print(filepath);
    final String  file_content = await filepath.readAsString();
    // final input = File(filepath!).openRead();
    List<dynamic> list_of_questions = JsontoList(file_content);
    print(list_of_questions[0]);
    print(list_of_questions[1]);
    print(list_of_questions[2]);
    //print(jsonobj);
    add_multiple_questions(list_of_questions);
  }
  Future <void> add_multiple_questions(List<dynamic> list_of_questions) async {

    for (int i = 0; i < list_of_questions.length; i++) {
      await questions
      //adding to firebase collection
          .add({
        //Data added in the form of a dictionary into the document.
        'question': list_of_questions[i]['question'],
        'option1': list_of_questions[i]['option1'],
        'option2': list_of_questions[i]['option2'],
        'option3': list_of_questions[i]['option3'],
        'option4': list_of_questions[i]['option4'],
      });

      print("addition is done");

    }
  }
}



