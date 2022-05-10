
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/AppCubits/register/cubit/states.dart';
import 'package:social_app/models/user_model.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterState> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  })  {
    print('userRegitser');
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email.trim(), password: password)
        .then((value) {
      creatreUser(
          name: name,
          email: email,
          password: password,
          phone: phone,
          id: value.user!.uid);

 
    }).catchError((error) {
      print('error');
      print(error.toString());
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void creatreUser(
      {required String name,
      required String email,
      required String password,
      required String phone,
      required String id}) {
    UserModel model = UserModel(
      email: email,
      id: id,
      name: name,
      phone: phone,
      isEmailVerfied: false,
      image: 'https://cdn-icons-png.flaticon.com/512/1160/1160922.png?w=740',
      bio: 'write your bio .....',
      imageCover:
          'https://cdn-icons-png.flaticon.com/512/1160/1160922.png?w=740',
    );
    FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .set((model.toMap()))
        .then((value) {
      emit(SocialCreateUserSuccessState(id));
    }).catchError((error) {
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changpassworedIcon() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SocialRegisterSuffixOconChange());
  }

  
}
