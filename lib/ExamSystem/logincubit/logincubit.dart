import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/social_user_model.dart';
import 'loginstate.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates>{
  SocialLoginCubit() : super(SocialLoginInitialState());
  static SocialLoginCubit get(context)=>BlocProvider.of(context);

  String? x;
  String? y;
 //

 // void getUserData(){
 //   emit(SocialLoginLoadingState());
 //   FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
 //     print(value.data());
 //     emit(SocialLoginSuccessState(uId!));
 //   }).catchError((error){
 //     emit(SocialLoginErrorState(error));
 //   });
 //   // FirebaseFirestore.instance.collection('users').doc(role).get().then((value) {
 //   //   print(value.data());
 //   //
 //   //   emit(SocialLoginSuccessState(uId!, role!));
 //   // }).catchError((error){
 //   //   emit(SocialLoginErrorState(error));+
 //   // });
 // }
 //
 //
 //
 //  IconData suffix=Icons.visibility_outlined;
 //  bool isPassword=true;
 //  void changePasswordVisibility()
 //  {
 //    isPassword=!isPassword;
 //    suffix=isPassword ? Icons.visibility_outlined:Icons.visibility_off;
 //    emit(SocialLoginPasswordVisibility());
 //  }
  void userLogin({
    required String email,
    required String password
  }){
    emit(SocialLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
        .then((value)
    {
       x=value.user!.uid ;



      emit(SocialLoginSuccessState(value.user!.uid));

    }
    ).catchError((error)
    {
      emit(SocialLoginErrorState(error.toString()));

    });
  }


  IconData suffix=Icons.visibility_outlined;
  bool isPassword=true;
  void changePasswordVisibility()
  {
    isPassword=!isPassword;
    suffix=isPassword ? Icons.visibility_outlined:Icons.visibility_off;
    emit(SocialLoginPasswordVisibility());
  }
}

