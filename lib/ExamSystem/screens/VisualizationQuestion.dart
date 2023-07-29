import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Question {
  final String label;
  final int counter;
  final int labelLength;

  Question(this.label, this.counter,{this.labelLength = 35});

  String get truncatedLabel =>
      label.length > labelLength ? '${label.substring(0, labelLength)}...' : label;
}

class ExamScreen99 extends StatefulWidget {
  final String docId;
  final String courseId;

  ExamScreen99({required this.courseId,required this.docId});

  @override
  _ExamScreen99State createState() => _ExamScreen99State();
}

class _ExamScreen99State extends State<ExamScreen99> {
  late Future<List<Question>> _questionsFuture;

  @override
  void initState() {
    super.initState();
    _questionsFuture = _getQuestions();
  }

  Future<List<Question>> _getQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('exams')
        .doc(widget.docId)
        .collection('questions')
        .get();

    List<Question> questions = [];

    snapshot.docs.forEach((doc) {
      String? question = doc.get('question');
      int? count = doc.get('counter');
      if (question != null && count != null) {
        questions.add(Question(question, count));
      }
    });

    return questions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Results'),
      ),
      body: FutureBuilder<List<Question>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data'),
            );
          }

          List<Question> questions = snapshot.data!;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: SfCartesianChart(
              title: ChartTitle(text: 'Number of students who answered each question correctly'),
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(),
              series: <BarSeries<Question, String>>[
                BarSeries<Question, String>(
                  dataSource: questions,
                  xValueMapper: (Question question, _) => question.truncatedLabel,
                  yValueMapper: (Question question, _) => question.counter,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    textStyle: TextStyle(fontSize: 10.sp),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
