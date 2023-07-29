import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../CUBIT/cubit.dart';
import '../CUBIT/states.dart';
import '../models/social_user_model.dart';

class AdminViewData extends StatelessWidget {
  SocialUserModel userModel;
  AdminViewData({required this.userModel});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
        create: (BuildContext context) => SocialCubit().. getUserData(),
        child: BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {}
            ,builder: (context,state) {


          return Scaffold(
              appBar: AppBar(

                automaticallyImplyLeading: true,

                elevation: 0,

                backgroundColor: Colors.blueAccent,

                title: const Text('View Data',style: TextStyle(color: Colors.white),),
              ),


              body: ConditionalBuilder(
                condition: userModel!=null,
                builder: (context) =>  SingleChildScrollView(
                  child: Column(
                      children: [
                        Padding(padding:const  EdgeInsets.only(top: 20),
                          child: Stack(alignment: AlignmentDirectional.center,
                              children: [ CircleAvatar(

                                radius: 92,
                                backgroundColor: Colors.blueAccent,
                                child:  CircleAvatar(
                                  radius: 87,
                                  backgroundImage:NetworkImage('${userModel.image}'),


                                ),
                              ),
                              ]
                          ),
                        )
                        , Column(
                            children:  <Widget>[
                               SizedBox(height: 8.h,),

                              ListTile(
                                title: const Text(
                                  'Email',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Padding(padding: const EdgeInsets.only(
                                    top: 5),
                                  child: Text('${userModel.email}',
                                    style:  TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold),),
                                ),),
                              Container(
                                width: double.infinity,
                                height: 1,
                                color: Colors.grey,
                              )  ,
                              SizedBox(height: 8.h,),
                              ListTile(
                                title:  Text(
                                  'Courses',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Padding(padding: const EdgeInsets.only(
                                    top: 5),
                                  child: Text(
                                    userModel.course == null || userModel.course!.isEmpty
                                        ? 'No Courses'
                                        : '${userModel.course}',
                                    style:  TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),),
                              Container(
                                width: double.infinity,
                                height: 1.h,
                                color: Colors.grey,
                              )  ,
                              GestureDetector(
                                onLongPress: () {
                                  Clipboard.setData(ClipboardData(text: userModel.uId ?? ''));
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied uID to clipboard')));
                                },
                                child: ListTile(
                                  title:  Text(
                                    'uID',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      '${userModel.uId}',
                                      style:  TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 1.h,
                                color: Colors.grey,
                              ),

                              ListTile(
                                title:  Text(
                                  'Name',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Padding(padding: const EdgeInsets.only(
                                    top: 5),
                                  child: Text(
                                    '${userModel.name}',
                                    style:  TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold),),
                                ),),
                              Container(
                                width: double.infinity,
                                height: 1.h
                                ,
                                color: Colors.grey,
                              )  ,
                              SizedBox(height: 8.h,),

                              ListTile(
                                title:  Text(
                                  'Phone',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Padding(padding: const EdgeInsets.only(
                                    top: 5),
                                  child: Text(
                                    '${userModel.phone}',
                                    style:  TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold),),
                                ),),
                              Container(
                                width: double.infinity,
                                height: 1.h,
                                color: Colors.grey,
                              )  ,
                              SizedBox(height: 8.h
                                ,),
                              // const ListTile(
                              //   title: Text(
                              //     'Level',
                              //     style: TextStyle(
                              //       color: Colors.black,
                              //       fontSize: 17,
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                              //   subtitle: Padding(padding: EdgeInsets.all(10),
                              //     child: Text(
                              //       '4',
                              //       style: TextStyle(
                              //           fontSize: 15,
                              //           fontWeight: FontWeight.bold),),
                              //   ),),
                              // const Divider(color: Colors.black45,)
                            ])

                        ,  SizedBox(height: 137.h,),

                        // defaultButton(function: () {
                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => const editprofile()));
                        // }, text: 'Edit Profile', radius: 15)
                        // ,





                      ]
                  ),
                ),
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),  ))
          ;
        }));

  }
}