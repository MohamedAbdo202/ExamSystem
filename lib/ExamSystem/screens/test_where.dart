import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class QuestionPage22 extends StatefulWidget {
  @override
  _QuestionPage22State createState() => _QuestionPage22State();
}

class _QuestionPage22State extends State<QuestionPage22> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();

  Future<String> _sendQuestion(String questionText) async {
    final apiUrl = 'http://10.0.2.2:3000/rephrase';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'contents': [questionText]}),
    );
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      final rephrasedQuestion = responseJson['contents'][0];
      return rephrasedQuestion;
    } else {
      throw Exception('Failed to rephrase question.');
    }
  }



  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _questionController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16.0.h),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final questionText = _questionController.text;
                    final rephrasedQuestion = await _sendQuestion(questionText);
                    _showSnackbar('Rephrased question: $rephrasedQuestion');
                  } catch (e) {
                    _showSnackbar('Failed to rephrase question: $e');
                  }
                }
              },
              child: Text('Send Question'),
            ),
          ],
        ),
      ),
    );
  }
}
