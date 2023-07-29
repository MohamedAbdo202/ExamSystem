
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Shared/components/components.dart';
import '../CUBIT/cubit.dart';
import '../CUBIT/states.dart';
import '../Compenent/constant.dart';
import 'Edit_profile.dart';

class myprofile extends StatefulWidget {
  const myprofile({Key? key}) : super(key: key);

  @override
  State<myprofile> createState() => _myprofileState();
}

class _myprofileState extends State<myprofile> {
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
        create: (BuildContext context) => SocialCubit().. getUserData(),
        child: BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {}
            ,builder: (context,state) {

          var profile=  SocialCubit.get(context).userModel;

          return Scaffold(
              appBar: AppBar(

                automaticallyImplyLeading: false,

                elevation: 0,

                backgroundColor: Colors.white,

                title: const Text('My Profile',style: TextStyle(color: Colors.blueAccent),),
              ),


              body: ConditionalBuilder(
                condition: profile!=null,
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
                                  backgroundImage:NetworkImage('${profile?.image}'),


                                ),
                              ),
                              ]
                          ),
                        )
                        , Column(
                            children:  <Widget>[
                               SizedBox(height: 8.h,),

                              ListTile(
                                title:  Text(
                                  'Email',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Padding(padding: const EdgeInsets.only(
                                    top: 5),
                                  child: Text('${profile?.email}',
                                    style:  TextStyle(
                                        fontSize: 15.sp
                                        ,
                                        fontWeight: FontWeight.bold),),
                                ),),
                              Container(
                                width: double.infinity,
                                height: 1.h,
                                color: Colors.grey,
                              )  ,
                              SizedBox(height: 8.h,),
                              GestureDetector(
                                onLongPress: () {
                                  Clipboard.setData(ClipboardData(text: profile?.uId ?? ''));
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
                                      '${profile?.uId}',
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
                                    profile?.course == null || profile!.course!.isEmpty
                                        ? 'No Courses'
                                        : '${profile.course}',
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
                              SizedBox(height: 8.h
                                ,),
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
                                    '${profile?.name}',
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold),),
                                ),),
                              Container(
                                width: double.infinity,
                                height: 1.h,
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
                                    '${profile?.phone}',
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
                              SizedBox(height: 8.h,),                              // const ListTile(

                            ])


                        // defaultButton(function: () {
                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => const editprofile()));
                        // }, text: 'Edit Profile', radius: 15)
                        // ,

                        , SizedBox(height: 20.h,),
                        Row(


                            children: [SizedBox(width: 5.w,),
                              Container(width: 150.w,
                                height: 40.h,
                                child:
                                defaultButton(function: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const editprofile()));
                                }, text: 'Edit Profile',radius: 15),),
                              SizedBox(width: 110.w,),
                              InkWell(
                                  onTap: () {
                                    print(uId);
                                    SocialCubit.get(context).loginOut(context);

                                  },
                                  child:
                                  Row(

                                      children: const [
                                        Icon(
                                          Icons.login_outlined, size: 25,),
                                        SizedBox(width: 5),


                                        Text("Sign Out"),

                                      ])


                              ),
                            ]),


                      ]
                  ),
                ),
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),  ))
          ;
        }));

  }
}