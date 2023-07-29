import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutttter/Graduation%20project/Quiz_app/quiz_logo.dart';
import 'package:flutttter/Graduation%20project/Quiz_app/quiz_play_widget.dart';
import 'package:flutttter/Graduation%20project/Quiz_app/quiz_result.dart';
import 'package:flutttter/Graduation%20project/Quiz_app/End_Result.dart';
import 'package:flutttter/Graduation%20project/Quiz_app/timer.dart';

import '../Compenent/constant.dart';
import '../models/Question_model.dart';
import '../quiz_cubit/quiz_cubit.dart';
import '../quiz_cubit/quiz_states.dart';
import '../screens/BottomNavigationForStudent.dart';
import '../screens/allResultforthesudent.dart';


class Quiz_App_Layout extends StatefulWidget {
  final String docId;
  final String courseId;
  final String endtime;
  final String opentime;
  final String difference; // <-- add this

  const Quiz_App_Layout({Key? key,required this.difference, required this.docId ,required this.courseId,required this.endtime,required this.opentime}):super(key: key);

  @override
  State<Quiz_App_Layout> createState() => _Quiz_App_LayoutState();
}

int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
late AnimationController _controller;
late Duration _limitTime;
int degree = 0;
int total_degree = 0;
class _Quiz_App_LayoutState extends State<Quiz_App_Layout> with SingleTickerProviderStateMixin{
  bool isLoading = true;



  @override
  void dispose() {
    if(_controller.isAnimating || _controller.isCompleted)
      _controller.dispose();
    super.dispose();
  }
  void _onTimerFinished() {
    setState(() {
      degree = _correct;
      total_degree = (_correct + _incorrect + _notAttempted);
    });
    _resetVariables();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResult1(
          degree: degree,
          totalDegree: total_degree,
          courseId: widget.courseId,
          docId: widget.docId,
        ),
      ),
    );
  }
  void _resetVariables() {
    setState(() {
      _correct = 0;
      _incorrect = 0;
      _notAttempted = 0;


    });
  }


  @override
  void initState() {
    super.initState();

    final differenceMatch = RegExp(r'(\d+)h\s*(\d+)m')
        .firstMatch(widget.difference);
    if (differenceMatch != null) {
      final hours = int.parse(differenceMatch.group(1)!);
      final minutes = int.parse(differenceMatch.group(2)!);
      _limitTime = Duration(hours: hours, minutes: minutes);
    } else {
      _limitTime = Duration.zero;
    }


    _controller=AnimationController(vsync: this,
      duration: Duration(milliseconds: _limitTime.inMilliseconds),
    );    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onTimerFinished();
      }
    });
  }
  GlobalKey<ScaffoldState> Scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
        QuizCubit()..get_questions_data555(widget.docId)..questionsData,
        child: BlocConsumer<QuizCubit, Quiz_states>(
            listener: (context, state) {},
            builder: (context, state) {
              return Scaffold(
                key: Scaffoldkey,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => suiii()));
                      _resetVariables();
                    },
                    color: Colors.black54,
                  ),

                  title: AppLogo(),
                  brightness: Brightness.light,
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                ),
                body: ConditionalBuilder(
                    condition: QuizCubit.get(context).questionsData.length > 0,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Quiz_timer(animation: StepTween(
                                begin: _limitTime.inSeconds, end: 0).animate(_controller)),
                            SizedBox(height: 20.h,),
                            ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => QuizPlayTile(
                                  questionModel: QuizCubit.get(context).questionsData[index],
                                  index: index,
                                  updateQuestionIndex: (int questionIndex) {
                                    QuizCubit.get(context).updateQuestionIndex(questionIndex);
                                  },
                                ),
                                separatorBuilder: (context, index) => SizedBox(height: 5.h,),
                                itemCount: QuizCubit.get(context).questionsData.length
                            ),
                            Container(
                                width: double.infinity,
                                color: Colors.blue,
                                height: 50.h,
                                child: MaterialButton(
                                    onPressed: () {
                                      // int degree = _correct;
                                      // int total_degree = (_correct + _incorrect + _notAttempted);
                                      setState(() {
                                        degree = _correct;
                                        total_degree = (_correct + _incorrect + _notAttempted);
                                      });
                                      _resetVariables();
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QuizResult1(
                                              degree: degree,
                                              totalDegree: total_degree,
                                              courseId: widget.courseId,
                                              docId: widget.docId
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                        'Submit',
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                        ))
                                )
                              ],
                            ),
                          ),
                        ),
                    fallback: (context) =>
                        Center(child: CircularProgressIndicator())),


              );
            })
    );
  }

}


  class QuizPlayTile extends StatefulWidget {
    final QuestionModel questionModel;
    final int index;
    final Function updateQuestionIndex;

    QuizPlayTile({
      required this.questionModel,
      required this.index,
      required this.updateQuestionIndex,
    });

    @override
    _QuizPlayTileState createState() => _QuizPlayTileState();

  }

  class QuestionState {
    String? selectedOption;
    bool answeredCorrectly = false;
  }

class _QuizPlayTileState extends State<QuizPlayTile> {
  QuestionState questionState = QuestionState();
  String? previousSelectedOption;

  int counter = 0; // Add a variable to hold the counter value

  // Fetch the counter value from Firestore
  Future<void> getCounterValue() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('exams')
        .doc(widget.questionModel.keke)
        .collection('questions')
        .doc(widget.questionModel.docId)
        .get();

    counter = docSnapshot.data()!['counter'];
  }
  void initState() {
    super.initState();
    getCounterValue(); // Call the function to fetch the counter value
  }
  @override
  Widget build(BuildContext context) {


    return Container(
      padding: EdgeInsets.all( 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.index + 1}. ${widget.questionModel.question}",
            style: TextStyle(
              fontSize: 18.0.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.0.h),
          ...widget.questionModel.options.map((option) {

            int index = widget.questionModel.options.indexOf(option);
            return GestureDetector(
              onTap: () {
                if (previousSelectedOption != option) {
                  setState(() {
                    questionState.selectedOption = option;
                    if (option == widget.questionModel.correctOption && questionState.answeredCorrectly == false) {
                      _correct++;
                      questionState.answeredCorrectly = true;
                      counter++;
                      FirebaseFirestore.instance
                          .collection('exams')
                          .doc(widget.questionModel.keke)
                          .collection('questions').doc(widget.questionModel.docId).update({'counter': counter});
                    } else if (option != widget.questionModel.correctOption && questionState.answeredCorrectly == true) {
                      _correct--;
                      counter--;
                      FirebaseFirestore.instance
                          .collection('exams')
                          .doc(widget.questionModel.keke)
                          .collection('questions').doc(widget.questionModel.docId).update({'counter': counter});
                      questionState.answeredCorrectly = false;
                    }
                    previousSelectedOption = option;
                  });
                  widget.updateQuestionIndex(widget.index); // Pass index as argument
                }
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: questionState.selectedOption == option ? Colors.blue : Colors.grey,
                ),
                child: Row(
                  children: [
                    Text(
                      String.fromCharCode(65 + index),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0.sp,
                      ),
                    ),
                    SizedBox(width: 16.0.w),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(fontSize: 16.0.sp),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

