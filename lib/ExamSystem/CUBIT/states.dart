import 'package:flutter/cupertino.dart';

abstract class SocialStates{}


class SocialInitialState extends SocialStates{}

class SocialGetUserLoadingState extends SocialStates{}

class SocialGetUserSuccessState extends SocialStates{}

class SocialGetUserErrorState extends SocialStates{
  final String error;
  SocialGetUserErrorState(this.error);
}
class SocialGetAllUserSuccessState extends SocialStates{}

class SocialGetAllUserLoadingState extends SocialStates{}

class SocialGetAllUserErrorState extends SocialStates{
  final String error;
  SocialGetAllUserErrorState(this.error);
}

class SocialGetAllUsersLoadingState extends SocialStates{}

class SocialGetAllUsersSuccessState extends SocialStates{}

class SocialGetAllUsersErrorState extends SocialStates{
  final String error;
  SocialGetAllUsersErrorState(this.error);
}
class SocialProfileimageErrorState extends SocialStates{}

class SocialProifleimageloadingState extends SocialStates{}
class SocialProifleimageSuccessState extends SocialStates{}
class SociallogoutSuccessState extends SocialStates{}
class SociallogoutErrorState extends SocialStates{
  final String error;
  SociallogoutErrorState(this.error);

}
class SocialUpdateErrorState extends SocialStates{}

class SocialUpdateLoadingState extends SocialStates{}
class SocialUpdateUserProfileImageSuccessState extends SocialStates{}

class SocialUpdateUserProfileImageErrorState extends SocialStates{}
class SocialGetAllCoursesSuccessState extends SocialStates{}

class SocialGetAllCoursesLoadingState extends SocialStates{}

class SocialGetAllCoursesErrorState extends SocialStates{
  final String error;
  SocialGetAllCoursesErrorState(this.error);
}
class SocialGetAllQuestionsSuccessState extends SocialStates{}
class SocialGetAllQuestionsErrorState extends SocialStates{
  final String error;
  SocialGetAllQuestionsErrorState(this.error);
}
class SocialGetAllQuestionsLoadingState extends SocialStates{}
