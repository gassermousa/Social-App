import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/AppCubits/login_Cubit/states.dart';

class SocialLoginCUbit extends Cubit<SocialLoginState> {
  SocialLoginCUbit() : super(SocialLoginInitialState());

  static SocialLoginCUbit get(context) => BlocProvider.of(context);


  void userLogin({required String email,required String password}) {
    emit(SocialLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password)
        .then((value) {
      print(value.user!.email);
      
      emit(SocialLoginSuccessState(value.user!.uid));
      
    }).catchError((error) {
      emit(SocialLoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changpassworedIcon() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SocialLoginSuffixOconChange());
  }
}
