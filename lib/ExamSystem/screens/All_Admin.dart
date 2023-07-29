import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../CUBIT/cubit.dart';
import '../CUBIT/states.dart';
import '../Compenent/component.dart';
import '../models/social_user_model.dart';
import 'AdminViewData.dart';

class All_Admin extends StatefulWidget {
  const All_Admin({Key? key}) : super(key: key);

  @override
  State<All_Admin> createState() => _All_AdminState();
}

class _All_AdminState extends State<All_Admin> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => SocialCubit().. getUsers()..AdminData,
        child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {}
    ,builder: (context,state) {

    var ProfileAdmin=  SocialCubit.get(context).AdminData;

       return Scaffold(appBar: AppBar(
         title: Text('All Professors'),
       ),
           body: ConditionalBuilder(
      condition:SocialCubit.get(context).AdminData.length>0,

      builder:(context)=>ListView.separated(

          itemBuilder: (context,index)=>buildChatItem(SocialCubit.get(context).AdminData[index],context),

          separatorBuilder: (context,index)=>dividerWidget(),

          itemCount: SocialCubit.get(context).AdminData.length),

      fallback:(context)=>Center(child: CircularProgressIndicator()) ,
    )
       );
    },
    )
    );
  }
    }
Widget buildChatItem(SocialUserModel model,context)=>InkWell(
  onTap: (){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminViewData(
        userModel:model,

    )));

  },
  child:   Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Row(children: [

    CircleAvatar(

      radius: 22,

      backgroundImage: NetworkImage('${model.image}'),

    ),

    SizedBox(

      width: 8.w,

    ),

    Text(

      '${model.name}',

      style: TextStyle(

          height: 1.4.h

              ,fontSize: 17.sp

      ),

    ),





    ]

    ,),
  
  ),
);
