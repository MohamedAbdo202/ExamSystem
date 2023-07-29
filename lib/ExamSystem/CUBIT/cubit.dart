
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutttter/Graduation%20project/CUBIT/states.dart';
import 'package:image_picker/image_picker.dart';

import '../Compenent/constant.dart';
import '../models/Course_model.dart';
import '../models/social_user_model.dart';
import '../network/local/cache_helper.dart';
import '../screens/login.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class SocialCubit extends Cubit<SocialStates>
{
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context)=>BlocProvider.of(context);

  SocialUserModel ?userModel;
  // late File? profileimage;
  // var picker =ImagePicker();


  CourseModel ?courModel;

  void   getUserData(){
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
          
      userModel=SocialUserModel.fromJson(value.data()!);
      print(userModel!.name);
      emit(SocialGetUserSuccessState());
    })
        .catchError((error){
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  File? userImageFile;
  final userImagePicker = ImagePicker();
  Future<void> getProfileImage() async{
    emit(SocialProifleimageloadingState());
    final pickedImage = await userImagePicker.getImage(source: ImageSource.gallery);
    if(pickedImage != null)
    {
      userImageFile = File(pickedImage.path);
      emit(SocialProifleimageSuccessState());
    }
    else
    {
      emit(SocialProfileimageErrorState());
    }
  }

  Future<void> loginOut(context)async {
    // await FirebaseFirestore.instance.clearPersistence();
    await   FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: 'uId').then((value) {
        if(value!) {
          print('logout done ');
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const gradlogin()));
        }

     });

      emit(SociallogoutSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(SociallogoutErrorState(error));
    });

  }

  void updateUser({
    required String name,
    required String phone,
    String ?image,

  }){
    SocialUserModel modelMap=SocialUserModel(
      name: name,
      phone: phone,
      image: image?? userModel!.image,
      email:   userModel!.email,
      uId:    userModel!.uId,
      role:  userModel!.role,
      level: userModel!.level,
      course:userModel!.course,


    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(modelMap.toMap())
        .then((value) {
      getUserData();
    })
        .catchError((error){
      emit(SocialUpdateErrorState());
    });

  }

  void  uploadProfileImage({
    required String name,
    required String phone,
  })  {
    emit(SocialUpdateLoadingState());

   firebase_storage.FirebaseStorage.instance.ref()
        .child('users/${Uri
        .file(userImageFile!.path)
        .pathSegments
        .last}')
        .putFile(userImageFile!).then((value)
     {
      value.ref.getDownloadURL().then((value)
      {
        updateUser(name: name, phone: phone,
          image: value,);

        emit(SocialUpdateUserProfileImageSuccessState());
      }).catchError((error) {
        emit(SocialUpdateUserProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUpdateUserProfileImageErrorState());
    });
  }
  List<SocialUserModel> StudentData = [];
  List<SocialUserModel> AdminData = [];
  void getUsers()
   {
     StudentData.clear();
     AdminData.clear();
     emit(SocialGetAllUsersLoadingState());
     FirebaseFirestore.instance.collection('users').get().then((value)
    {
      value.docs.forEach((element)
      {
        element.reference
            .get()
            .then((value)
         {
         if (value['role']== 'ADMIN'){
           
          AdminData.add(SocialUserModel.fromJson(element.data()));
          emit(SocialGetAllUserSuccessState ());


         } else if (value['role']== 'USER'){

           StudentData.add(SocialUserModel.fromJson(element.data()));
           emit(SocialGetAllUserSuccessState ());

         }
        })
            .catchError((error){});
      });

      emit(SocialGetAllUserSuccessState ());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetAllUserErrorState(error.toString()));
    });
}

//   List<Question> questions1 = [];
//
// Future<void> getQuestion() async {
//   questions1.clear();
//   emit(SocialGetAllQuestionsLoadingState());
//
//
//    await FirebaseFirestore.instance.collection('question').doc().get().then(( value) {
//     Map<String, dynamic> data = value as Map<String, dynamic>;
//     data.forEach((key, value) {
//       Question question = Question(
//         question: value['question'],
//         options: Map<String, String>.from(value['options']),
//         answer: value['answer'],
//       );
//       questions1.add(question);
//
//     });
//     emit(SocialGetAllQuestionsSuccessState ());
//
//   }).catchError((error){
//     emit(SocialGetAllQuestionsErrorState(error));



  // List<Question> questions = [];
  //
  // Future<List<Question>> getQuestions() async {
  //
  //   QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('questions').get();
  //
  //   snapshot.docs.forEach((document) {
  //     Question question = Question(
  //       question: document.data()['question'],
  //       options: List<String>.from(document.data()['options']),
  //       answer: document.data()['answer'],
  //     );
  //
  //     questions.add(question);
  //   });

    // return questions;


  List<CourseModel> CourseData = [];
  void getCourses()
  {
    CourseData.clear();

    emit(SocialGetAllCoursesLoadingState());
    FirebaseFirestore.instance.collection('courses').get().then((value)
    {
      value.docs.forEach((element)
      {
        element.reference
            .get()
            .then((value)
        {


          CourseData.add(CourseModel.fromJson(element.data()));
          emit(SocialGetAllCoursesSuccessState ());





        })
            .catchError((error){});
      });

      emit(SocialGetAllCoursesSuccessState ());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetAllCoursesErrorState(error.toString()));
    });




  }
  Future<void> addCoursesToStudent(String studentId, List<String> courseIds) async {
    final firestoreInstance = FirebaseFirestore.instance;

    // Get a reference to the student document
    final studentRef = firestoreInstance.collection('users').doc(studentId);

    // Loop through each course ID and add it to the "enrolledCourses" subcollection
    for (final courseId in courseIds) {
      // Get a reference to the course document
      final courseRef = firestoreInstance.collection('courses').doc(courseId);

      // Create a new document in the "enrolledCourses" subcollection for the current student document
      await studentRef.collection('course').doc(courseId).set({
        'name': (await courseRef.get(GetOptions())).get('name'),
        'instructor': (await courseRef.get(GetOptions())).get('instructor'),
      });

    }
  }
  // void deleteUser({required String personID}){
  //   FirebaseFirestore.instance.collection('users').doc(personID).delete().then((value){
  //     emit(DeletePersonSuccessfullyState());
  //   }).catchError((error)=>emit(DeletePersonErrorState()));
  // }
}
