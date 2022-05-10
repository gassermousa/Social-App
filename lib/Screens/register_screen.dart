import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_app/AppCubits/register/cubit/cubit.dart';
import 'package:social_app/AppCubits/register/cubit/states.dart';
import 'package:social_app/Screens/home_screen.dart';
import 'package:social_app/cach_helper/cach_helper.dart';
import 'package:social_app/components/btn.dart';
import 'package:social_app/components/colors.dart';
import 'package:social_app/components/formfield.dart';
import 'package:social_app/components/navigator.dart';

class SocialRegisterScreen extends StatelessWidget {
  var formkey = GlobalKey<FormState>();
  var namecontroller = TextEditingController();
  var emailcontroller = TextEditingController();
  var paswordcontroller = TextEditingController();
  var phonecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterState>(
        listener: (context, state) {
          if (state is SocialCreateUserSuccessState) {
            CacheHelper.savedata(key:'UID',
             value:state.uid).then((value) => (){
               navigateToAndFinish(context, Home());
             });
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'REGISTER',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(color: Colors.black),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Register Now To Browse Our Hot Offers',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      defaultFormFiled(
                          controller: namecontroller,
                          action: TextInputAction.next,
                          type: TextInputType.name,
                          validate: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'please enter your name';
                            }
                            return null;
                          },
                          lable: 'Name',
                          prefixIcon: Icons.person),
                      SizedBox(
                        height: 15.0,
                      ),
                      defaultFormFiled(
                          controller: emailcontroller,
                          action: TextInputAction.next,
                          type: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'please enter your email address';
                            }
                            return null;
                          },
                          lable: 'Email',
                          prefixIcon: Icons.email_outlined),
                      SizedBox(
                        height: 15.0,
                      ),
                      defaultFormFiled(
                          controller: paswordcontroller,
                          type: TextInputType.visiblePassword,
                          suffix: SocialRegisterCubit.get(context).isPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          validate: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'please enter Password';
                            }
                            return null;
                          },
                          lable: 'Password',
                          action: TextInputAction.done,
                          scureText:
                              SocialRegisterCubit.get(context).isPassword,
                          suffixPressed: () {
                            SocialRegisterCubit.get(context)
                                .changpassworedIcon();
                          },
                          prefixIcon: Icons.lock_outline),
                      SizedBox(
                        height: 15.0,
                      ),
                      defaultFormFiled(
                          controller: phonecontroller,
                          action: TextInputAction.done,
                          type: TextInputType.phone,
                          validate: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'please enter your phone';
                            }
                            return null;
                          },
                          lable: 'phone',
                          prefixIcon: Icons.phone),
                      SizedBox(
                        height: 30.0,
                      ),
                      ConditionalBuilder(
                          condition: state is! SocialRegisterLoadingState,
                          builder: (context) => defaultButton(
                              text: 'register',
                              isUpperCase: true,
                              radius: 5.0,
                              onpress: () {
                                if (formkey.currentState!.validate()) {
                                  SocialRegisterCubit.get(context).userRegister(
                                      name: namecontroller.text,
                                      email: emailcontroller.text,
                                      phone: phonecontroller.text,
                                      password: paswordcontroller.text);
                                    print('object');
                                }
                              }),
                          /*Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: defaultColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                child: MaterialButton(
                                    child: Text(
                                      'register'.toUpperCase(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      if (formkey.currentState!.validate()) {
                                        SocialRegisterCubit.get(context)
                                            .userRegister(
                                                name: namecontroller.text,
                                                email: emailcontroller.text,
                                                phone: phonecontroller.text,
                                                password:
                                                    paswordcontroller.text);
                                      }
                                    }),
                              ),*/
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator())),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
