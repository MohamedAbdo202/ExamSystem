import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'login.dart';
class OnBoardingModel{
  final String image;
  final String title;
  final String body;
  OnBoardingModel( {
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}
var boardController=PageController();

List<OnBoardingModel> boardingList= [
  OnBoardingModel(
    image: 'assets/images/5588.png',
    title: 'Let`s Make Exam',
    body: 'Create a custom exam with specific features to meet your needs, making the testing process easier.',
  ),
  OnBoardingModel(
    image: 'assets/images/e123.png',
    title: 'Analyse The Result',
    body: 'Now, you can find out more information, analyze the score, and get distributions and numbers for each question solved for the students answer',
  ),
  OnBoardingModel(
    image: 'assets/images/notnot.png',
    title: ' Some Practise Exams',
    body: ' if you are looking for an exam to practice, you can find it in the archive question',
  ),];

bool isLast=false;
class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(


        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.blue.withOpacity(0.5), BlendMode.lighten),


          // repeat: ImageRepeat.repeat,

          image:NetworkImage( 'https://img.freepik.com/free-photo/blue-stationery-white-background_23-2147710373.jpg?w=740&t=st=1678995599~exp=1678996199~hmac=41fb76b7dad3934834ea31a3b5cf074496a8732aac72804ed6c65b8b1e5cc4b8'),
// image: NetworkImage('https://img.freepik.com/free-vector/seamless-office-stationery-pattern-background-vector-illustration_1284-2152.jpg?w=740&t=st=1678997672~exp=1678998272~hmac=80f77766dc49b1dc7fd3c68655d40579558249c231372232e6b36ce884bc8f7b')
          // image: NetworkImage('https://img.freepik.com/free-vector/geometric-science-education-background-vector-gradient-blue-digital-remix_53876-125993.jpg?w=1060&t=st=1678997398~exp=1678997998~hmac=7e38cf38e98e0769c3bca0814f7281e6b1da2f4528e9833d29bc1b6816c71e93'),

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


          appBar: AppBar(elevation: 0,

            backgroundColor: Colors.white,
            actions: [TextButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>gradlogin()));

                },
                child: Text('SKIP', style: TextStyle(color: Colors.blueAccent),)
            )],
          ),
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Expanded (
                  child: PageView.builder(itemBuilder:(context,index)=>buildBoardingItem(boardingList[index]),
                    controller: boardController,
                    onPageChanged:(int index)
                    {
                      if(index==boardingList.length-1)
                      {
                        setState(() {
                          isLast=true;

                        });
                      }
                      else
                      {
                        setState(() {
                          isLast=false;
                        });
                      }
                    } ,
                    physics: BouncingScrollPhysics(),
                    itemCount: boardingList.length,
                  ),
                ),
                SizedBox
                  (
                  height: 40.h,),
                Row(
                  children: [
                    SmoothPageIndicator(
                      controller: boardController,
                      count: boardingList.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: Colors.blueAccent,
                        dotColor: Colors.grey,
                        dotHeight: 10,
                        expansionFactor: 2,
                        dotWidth: 10,
                        spacing: 5,
                      ),
                    ),
                    Spacer(),
                    FloatingActionButton(
                      onPressed: (){
                        if(isLast)
                        {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>gradlogin()));
                        }
                        else
                        {
                          boardController.nextPage(
                              duration: Duration(
                                  milliseconds: 750
                              ),
                              curve:Curves.fastLinearToSlowEaseIn );
                        }
                      },
                      child: Icon(Icons.arrow_forward_ios),
                    )
                  ],)
              ],
            ),
          )
      ),
    );
  }
}
Widget buildBoardingItem(OnBoardingModel model)=>Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(
      child: Image(
        image:AssetImage('${model.image}'),
      ),
    ),
    SizedBox(height: 30.h
      ,),
    Text(
      '${model.title}',
      style: TextStyle(
        fontSize: 24.sp,
      )
      ,),
    SizedBox(
      height: 15.h
      ,),
    Text (
      '${model.body}'
      ,style: TextStyle(
      fontSize: 14.sp,

    ),),
    SizedBox(height: 30.h
      ,),
  ],
);