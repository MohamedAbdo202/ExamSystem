abstract class CourseStates {}

class CourseInitialState extends CourseStates {}

class CourseLoadingState extends CourseStates {}

class CourseSuccessState extends CourseStates {}

class CourseErrorState extends CourseStates
{
  final String error;

  CourseErrorState(this.error);
}


class CreateCourseSuccessState extends CourseStates {}
class AddCourseToProfSuccessState extends CourseStates{}
class CreateCourseErrorState extends CourseStates
{
  final String error;

  CreateCourseErrorState(this.error);

}
// class SocialGetAllCoursesSuccessState extends CourseStates{}
//
// class SocialGetAllCoursesLoadingState extends CourseStates{}
//
// class SocialGetAllCoursesErrorState extends CourseStates{
//   final String error;
//   SocialGetAllCoursesErrorState(this.error);
// }
