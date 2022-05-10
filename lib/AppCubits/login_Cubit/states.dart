

import 'package:social_app/models/user_model.dart';

abstract class SocialLoginState{}

class SocialLoginInitialState extends SocialLoginState{}
class SocialLoginLoadingState extends SocialLoginState{}

class SocialLoginSuccessState extends SocialLoginState{
  final String uid;
  SocialLoginSuccessState(this.uid);
}
class SocialLoginErrorState extends SocialLoginState{
  // ignore: prefer_typing_uninitialized_variables
  final error;
  SocialLoginErrorState(this.error);
}

class SocialLoginSuffixOconChange extends SocialLoginState{}



