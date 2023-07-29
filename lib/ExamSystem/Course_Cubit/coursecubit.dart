import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutttter/Graduation%20project/Compenent/constant.dart';

import '../models/Course_model.dart';
import '../models/social_user_model.dart';
import 'coursestates.dart';

class CourseReigsterCubit extends Cubit<CourseStates> {
  CourseReigsterCubit() : super(CourseInitialState());


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static CourseReigsterCubit get(context) => BlocProvider.of(context);

  void updateUserCourses(String proffesereID, List<String> courses) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(proffesereID)
        .update({'course': courses});
  }
  Future<void> addCourse( String courseID, String courseName, String doctorID) async {
    // Add the course to Firebase
    emit(CourseLoadingState());

    await FirebaseFirestore.instance.collection('courses').doc(courseID).set({
      'course_id': courseID,
      'course_name': courseName,
      'doctor_id': doctorID,
    });
    final snapshot = await _firestore.collection('courses').get();
    final courses = snapshot.docs
        .map((doc) => CourseModel(
        course_id: doc.data()['course_id'],
        course_name: doc.data()['course_name'],
        doctor_id: doc.data()['doctor_id']))
        .toList();



// if(
// doctorID == FirebaseFirestore.instance.collection('users').doc(doctorID).get())
// {
//   FirebaseFirestore.instance.collection("users").doc(doctorID).update({
//     "course": "courseID",
//
//   });
//   print('22');
//
//   emit(AddCourseToProfSuccessState());
// }else{
//   print('there is an error');
// }
print('33');
    emit(CreateCourseSuccessState());

    // Emit the updated list of courses
    // emit(CreateCourseSuccessState());

  }



}
