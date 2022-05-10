abstract class SocialRegisterState {}

class SocialRegisterInitialState extends SocialRegisterState {}

class SocialRegisterLoadingState extends SocialRegisterState {}

class SocialRegisterSuccessState extends SocialRegisterState {}

class SocialRegisterErrorState extends SocialRegisterState {
  final error;
  SocialRegisterErrorState(this.error);
}

class SocialCreateUserSuccessState extends SocialRegisterState {
  final String uid;
  SocialCreateUserSuccessState(this.uid);
}

class SocialCreateUserErrorState extends SocialRegisterState {
  final error;
  SocialCreateUserErrorState(this.error);
}

class SocialRegisterSuffixOconChange extends SocialRegisterState {}



