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


class Quiz_App_Layout2 extends StatefulWidget {
  final String docId;
  final String courseId;
  const Quiz_App_Layout2({Key? key, required this.docId ,required this.courseId}):super(key: key);

  @override
  State<Quiz_App_Layout2> createState() => _Quiz_App_Layout2State();
}

int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
late AnimationController _controller;

class _Quiz_App_Layout2State extends State<Quiz_App_Layout2> with SingleTickerProviderStateMixin{
  bool isLoading = true;




  @override
  void dispose() {
    if(_controller.isAnimating || _controller.isCompleted)
      _controller.dispose();
    super.dispose();
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
    _controller=AnimationController(vsync: this,
        duration: Duration(seconds: Limit_time));
    _controller.forward();

  }
  GlobalKey<ScaffoldState> Scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
        QuizCubit()..get_questions_data2(widget.docId)..second_questionsData,
        child: BlocConsumer<QuizCubit, Quiz_states>(
            listener: (context, state) {},
            builder: (context, state) {
              return Scaffold(
                key: Scaffoldkey,
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
                body: ConditionalBuilder(
                    condition: QuizCubit.get(context).second_questionsData.length > 0,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Quiz_timer(animation: StepTween(
                                begin: Limit_time, end: 0).animate(_controller)),
                            SizedBox(height: 20.h,),
                            ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) =>QuizPlayTile(
                                  questionModel: QuizCubit.get(context).second_questionsData[index],
                                  index: index,
                                  updateQuestionIndex: (int questionIndex) {
                                    QuizCubit.get(context).updateQuestionIndex(questionIndex);
                                  },
                                ),
                                separatorBuilder: (context, index) => SizedBox(height: 5.h,),
                                itemCount: QuizCubit.get(context).second_questionsData.length
                            ),
                            Container(
                                width: double.infinity,
                                color: Colors.blue,
                                height: 50.h,
                                child: MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => suiii()));


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
  QuizPlayTile({required this.questionModel,
    required this.index,      required this.updateQuestionIndex,
  });


  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}
class QuestionState {
  String? selectedOption;
  bool answeredCorrectly = false;
}
class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";
  // String option_Selected = "";
  QuestionState questionState = QuestionState();
  String? previousSelectedOption;


  @override
  Widget build(BuildContext context) {

    return  Container(
      padding: EdgeInsets.all(8),
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
                    if (option == widget.questionModel.correctOption) {
                      questionState.answeredCorrectly = true;

                    } else {
                      questionState.answeredCorrectly = false;
                      if (questionState.selectedOption == widget.questionModel.correctOption) {
                        _correct--;

                      }
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
                  color: questionState.selectedOption == option ?
                  (questionState.answeredCorrectly ? Colors.green : Colors.blue) :
                  Colors.grey,
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
