
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutttter/Graduation%20project/CubitReg/statereg.dart';

import '../models/social_user_model.dart';


class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,

  }) {
    print('hello');

    emit(SocialRegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value) {
      emit(SocialRegisterLoadingState());

      userCreate(
        uId: value.user!.uid,
        email: email,
        phone: phone,
        name: name,
        role: role,
        );


      }).catchError((error){
         emit(SocialRegisterErrorState(error.toString()));



     });

    }


  void userCreate({
    required String? name,
    required String? email,
    required String? phone,
    required String? uId,
    required String? role,


  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      role: role,
      image: 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=740&t=st=1683900163~exp=1683900763~hmac=d2b9e9f2b45aba6a94eaa04abaa2e965b945c017a649a2fbb8f2d1b57bfafc13',

    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value)
    {
      emit(SocialCreateUserSuccessState());
    })
        .catchError((error) {
      print(error.toString());
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }



//////
  void uploadJsonFileAdmin() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      final PlatformFile file = result.files.first;
      final String filePath = file.path!;

      final File textFile = File(filePath);
      final String fileContent = await textFile.readAsString();
      final jsonData = json.decode(fileContent);

      if (jsonData is List) {
        // Handle a list of JSON objects
        for (final userData in jsonData) {
          final name = userData['name'];
          final email = userData['email'];
          final password = userData['password'];
          final phone = userData['phone'];
          final role = userData['role'];

          await userRegister4(
            name: name,
            email: email,
            password: password,
            phone: phone,
            role: role,
          );
        }
      } else if (jsonData is Map) {
        // Handle a single JSON object
        final name = jsonData['name'];
        final email = jsonData['email'];
        final password = jsonData['password'];
        final phone = jsonData['phone'];
        final role = jsonData['role'];

        await userRegister4(
          name: name,
          email: email,
          password: password,
          phone: phone,
          role: role,
        );
      }
    }
  }

  Future<void> userRegister4({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  }) async {
    print('hello');

    emit(SocialRegisterLoadingState());

    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(SocialRegisterLoadingState());

      await userCreate4(
        uId: userCredential.user!.uid,
        email: email,
        phone: phone,
        name: name,
        role: role,
      );
    } catch (error) {
      emit(SocialRegisterErrorState(error.toString()));
    }
  }

  Future<void> userCreate4({
    required String? name,
    required String? email,
    required String? phone,
    required String? uId,
    required String? role,
  }) async {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      role: role,
      level: 'N/A',
      image:
      'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=740&t=st=1683900163~exp=1683900763~hmac=d2b9e9f2b45aba6a94eaa04abaa2e965b945c017a649a2fbb8f2d1b57bfafc13',
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(model.toMap());

      emit(SocialCreateUserSuccessState());
    } catch (error) {
      print(error.toString());
      emit(SocialCreateUserErrorState(error.toString()));
    }
  }




  void uploadJsonFileuser() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      final PlatformFile file = result.files.first;
      final String filePath = file.path!;

      final File textFile = File(filePath);
      final String fileContent = await textFile.readAsString();
      final jsonData = json.decode(fileContent);

      if (jsonData is List) {
        // Handle a list of JSON objects
        for (final userData in jsonData) {
          final name = userData['name'];
          final email = userData['email'];
          final password = userData['password'];
          final phone = userData['phone'];
          final role = userData['role'];
          final level = userData['level'];

          await userRegister3(
            name: name,
            email: email,
            password: password,
            phone: phone,
            role: role,
            level: level,
          );
        }
      } else if (jsonData is Map) {
        // Handle a single JSON object
        final name = jsonData['name'];
        final email = jsonData['email'];
        final password = jsonData['password'];
        final phone = jsonData['phone'];
        final role = jsonData['role'];
        final level = jsonData['level'];

        await userRegister3(
          name: name,
          email: email,
          password: password,
          phone: phone,
          role: role,
          level: level,
        );
      }
    }
  }

  Future<void> userRegister3({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
    required String level,
  }) async {
    print('hello');

    emit(SocialRegisterLoadingState());

    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(SocialRegisterLoadingState());

      await userCreate3(
        uId: userCredential.user!.uid,
        email: email,
        phone: phone,
        name: name,
        role: role,
        level: level,
      );
    } catch (error) {
      emit(SocialRegisterErrorState(error.toString()));
    }
  }

  Future<void> userCreate3({
    required String? name,
    required String? email,
    required String? phone,
    required String? uId,
    required String? role,
    required String? level,
  }) async {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      role: role,
      level: level,
      image:
      'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=740&t=st=1683900163~exp=1683900763~hmac=d2b9e9f2b45aba6a94eaa04abaa2e965b945c017a649a2fbb8f2d1b57bfafc13',
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(model.toMap());

      emit(SocialCreateUserSuccessState());
    } catch (error) {
      print(error.toString());
      emit(SocialCreateUserErrorState(error.toString()));
    }
  }


/////////////////


  void userRegister1({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
    required String level

  }) {
    print('hello');

    emit(SocialRegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      emit(SocialRegisterLoadingState());

      userCreate1(
        uId: value.user!.uid,
        email: email,
        phone: phone,
        name: name,
        role: role,
        level: level,
      );


    }).catchError((error){
      emit(SocialRegisterErrorState(error.toString()));



    });

  }


  void userCreate1({
    required String? name,
    required String? email,
    required String? phone,
    required String? uId,
    required String? role,
    required String? level,

  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      role: role,
      level: level,
      image: 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=740&t=st=1683900163~exp=1683900763~hmac=d2b9e9f2b45aba6a94eaa04abaa2e965b945c017a649a2fbb8f2d1b57bfafc13',


    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value)
    {
      emit(SocialCreateUserSuccessState());
    })
        .catchError((error) {
      print(error.toString());
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }

   IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  //
  void changePasswordVisibility() {
   isPassword = !isPassword;
   suffix =
   isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(SocialRegisterChangePasswordVisibilityState());
  }
  var items = [
    'Item 1',
    'Item 2',
  ];
  String dropdownvalue= 'item1';
  void changeTypeValue() {
    dropdownvalue!='item1';
    if(dropdownvalue!='item1') {
      dropdownvalue=items[1];
    }
    emit(SocialRegisterChangeTypeVisibilityState());
  }}


