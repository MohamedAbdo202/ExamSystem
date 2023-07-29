
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutttter/Graduation%20project/screens/student%20show.dart';
import '../../Shared/components/components.dart';
import '../Compenent/constant.dart';
import '../SocialLayout.dart';
import '../USER_SCREEN.dart';
import '../logincubit/logincubit.dart';
import '../logincubit/loginstate.dart';
import '../network/local/cache_helper.dart';
import '../themanager.dart';
import 'BottomNavBarAdmin.dart';
import 'BottomNavigationForStudent.dart';
import 'myprofile.dart';

class gradlogin extends StatefulWidget {
  const gradlogin({Key? key}) : super(key: key);

  @override
  State<gradlogin> createState() => _gradloginState();
}

class _gradloginState extends State<gradlogin>
{
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isPassword = true;



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => SocialLoginCubit(),
        child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
      if (state is SocialLoginErrorState) {
        showToast(
          text: state.error,
          state: ToastState.Error,
        );
      }
      if(state is SocialLoginSuccessState){

        CacheHelper.saveData(
          key: 'uId',
          value: state.uId,
        ).then((value)
        {
          uId=state.uId;
            FirebaseFirestore.instance.collection("users").doc( SocialLoginCubit.get(context).x).get().then((value) {

            String role = (value['role']);

            if(role=="ADMIN")
            {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => myprofile()));

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => thissssss()),
              );

            }else if(role=="USER")
            {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SocialLayout2()));
            //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExamCard3(uId: state.uId,)));
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => suiii()));



            }else{

              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>themanager()));

            }
            });

          ;



        });
      }},
    builder: (context, state) {


      return Container(

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),



          image: DecorationImage(
             fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.lighten),


            // repeat: ImageRepeat.repeat,

            image: AssetImage('assets/images/loginn.jpg'),

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
          backgroundColor: Colors.transparent,

    //       appBar: AppBar(
    //     automaticallyImplyLeading: false,
    //
    //     elevation: 0,
    //
    // ),
    body: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Center(
    child: SingleChildScrollView(
    child: Form(
    key: formKey,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:
    [
    Text(
    'Login',
    style: TextStyle(
    fontSize: 40.0.sp,
    fontWeight: FontWeight.bold,
        color: Colors.black
    ),
    ),
    SizedBox(
    height: 40.0.h,
    ),
    defaultFormField(
    controller: emailController,
    label: 'Email',
    prefix: Icons.email,
    type: TextInputType.emailAddress,
    validator: ( value)
    {
    if(value== null || value.isEmpty)
    {
    return 'email must not be empty';
    }

    return null;
    },
    ),
    SizedBox(
    height: 15.0.h,
    ),
    defaultFormField(

    controller: passwordController,
    label: 'Password',
    prefix: Icons.lock,
    suffix: isPassword ? Icons.visibility : Icons.visibility_off,
    isPassword: isPassword,
    suffixPressed: ()
    {
    setState(()
    {
    isPassword = !isPassword;
    });
    },
    type: TextInputType.visiblePassword,
    validator: ( value)
    {
    if(value== null || value.isEmpty)
    {
    return 'password must not be empty';
    }

    return null;
    },
    ),
    SizedBox(
    height: 20.0.h,
    ),
        ConditionalBuilder(
          condition: state is! SocialLoginLoadingState,
          builder: (context) => defaultButton(
            background:Colors.lightBlueAccent,
            function: ()
            {
              if (formKey.currentState!.validate()) {
                SocialLoginCubit.get(context).userLogin(
                  email: emailController.text,
                  password: passwordController.text,
                );
              }
            },
            text: 'login',
            isUpperCase: true,

          ),
          fallback: (context) =>
              Center(child: CircularProgressIndicator()),
        ),
        SizedBox(
          height: 15.0.h,
        ),
    // Row(
    // mainAxisAlignment: MainAxisAlignment.center,
    // children: [
    //
    // TextButton(
    // onPressed: () {},
    // child: Text(
    // 'Forget Password>>?!',
    // ),
    //
    // //   FirebaseFirestore.instance.collection("users").doc( SocialLoginCubit.get(context).x).get().then((value) {
    // //   print('hi');
    // //
    // //   String role = (value['role']);
    // //   print('hi');
    // //
    // //   if(role=="ADMIN")
    // //   {
    // //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => SocialLayout()));
    // //
    // //   }else if(role=="USER")
    // //   {
    // //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => SocialLayout2()));
    // //
    // //   }
    // //   });
    // //
    // // };
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //         ),
    // ],
    // ),
      ],
      ),
      ),
      ),
      ),
      ),
      ));
      },
          ),
      );
    }
  }