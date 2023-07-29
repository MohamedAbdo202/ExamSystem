import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Quiz_timer extends AnimatedWidget{
  Quiz_timer({Key? key, required this.animation}) : super(key: key , listenable: animation);
  Animation<int> animation;

  @override
  Widget build(BuildContext context) {
    Duration clock_timer = Duration(seconds: animation.value);
    // var timer_text = '${clock_timer.inMinutes.remainder(60).toString()} :'
    //     '${(clock_timer.inSeconds.remainder(60)%60).toString().padLeft(2, '0')}';
    var timer_text = '${clock_timer.inHours.toString().padLeft(2, '0')} :'
        '${clock_timer.inMinutes.remainder(60).toString().padLeft(2, '0')} :'
        '${(clock_timer.inSeconds.remainder(60)%60).toString().padLeft(2, '0')}';

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),
          color: Colors.white70),
      child: Column(
        children: [
          Text('${timer_text}',
            style: TextStyle(fontSize: 30.sp,
                color: clock_timer.inMinutes.remainder(60) < 5 ? Colors.red: Colors.blue),),

        ],
      ),
    );

  }

}