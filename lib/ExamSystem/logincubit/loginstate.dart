abstract class SocialLoginStates{}
class SocialLoginInitialState extends SocialLoginStates{}
class SocialLoginLoadingState extends SocialLoginStates{}
class SocialLoginSuccessState extends SocialLoginStates
{
  final String uId;
  // final String role;
  SocialLoginSuccessState(this.uId);


}
class SocialLoginErrorState extends SocialLoginStates{
  final String error;
  SocialLoginErrorState(this.error);
}

class SocialLoginPasswordVisibility extends SocialLoginStates{}
