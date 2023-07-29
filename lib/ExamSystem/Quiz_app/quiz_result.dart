import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class quiz_result extends StatelessWidget {

  const quiz_result({Key? key,
    required this.degree,
    required this.total_degree,
  }) : super(key: key);
  final int degree ;
  final int total_degree;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test results',
            style: TextStyle(fontSize: 20.sp,)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Text('student name : omar ramadan ',
              style: TextStyle(fontSize: 25.sp,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h,),

            Text('student id: 12345678',
              style: TextStyle(fontSize: 25.sp,
                  fontWeight: FontWeight.bold),),

            SizedBox(height: 20.h,),

            Text('your result is ${degree} / ${total_degree}',
              style: TextStyle(fontSize: 25.sp,
                  fontWeight: FontWeight.bold),),
            SizedBox(height: 24.h,),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Text("Go to home", style: TextStyle(color: Colors.white, fontSize: 19.sp),),
              ),
            )

          ],),
      ),
    );
  }
}