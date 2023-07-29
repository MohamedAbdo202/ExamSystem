import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../CUBIT/cubit.dart';
import '../CUBIT/states.dart';
import '../Compenent/component.dart';
import '../models/social_user_model.dart';
import 'UserViewData.dart';

class Remove_Screen extends StatefulWidget {
  const Remove_Screen({Key? key}) : super(key: key);

  @override
  State<Remove_Screen> createState() => _Remove_ScreenState();
}

class _Remove_ScreenState extends State<Remove_Screen> {
  @override
    Widget build(BuildContext context) {
      return BlocProvider(
          create: (BuildContext context) => SocialCubit()..getUsers()..StudentData,
          child: BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {}
            ,builder: (context,state) {


            return Scaffold(appBar: AppBar(
              title: Text('Remove Page'),
            ),
                body: ConditionalBuilder(
                  condition:SocialCubit.get(context).StudentData.length>0,

                  builder:(context)=>ListView.separated(

                      itemBuilder: (context,index)=>buildChatItem(SocialCubit.get(context).StudentData[index],context),

                      separatorBuilder: (context,index)=>dividerWidget(),

                      itemCount: SocialCubit.get(context).StudentData.length),
                  fallback:(context)=>Center(child: CircularProgressIndicator()) ,
                ));
          },
          )
      );
    }
  }
  Widget buildChatItem(SocialUserModel model,context)=>InkWell(onTap: (){

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserViewData(
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
        Spacer(),
        IconButton(onPressed: () async {

          await FirebaseFirestore.instance.collection('users').doc(model.uId).delete();
          // Refetch the updated list of users from Firebase and update the StudentData list in the SocialCubit
          SocialCubit.get(context).getUsers();

        }, icon:Icon(Icons.person_remove_sharp))


      ]
        ,),
    ),
  );
