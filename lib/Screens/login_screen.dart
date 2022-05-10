import 'package:flutter/material.dart';
import 'package:social_app/AppCubits/login_Cubit/cubit.dart';
import 'package:social_app/AppCubits/login_Cubit/states.dart';
import 'package:social_app/AppCubits/social_Cubits/cubits.dart';
import 'package:social_app/Screens/home_screen.dart';
import 'package:social_app/Screens/register_screen.dart';
import 'package:social_app/cach_helper/cach_helper.dart';
import 'package:social_app/components/btn.dart';
import 'package:social_app/components/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:social_app/components/constant.dart';
import 'package:social_app/components/formfield.dart';
import 'package:social_app/components/navigator.dart';
import 'package:social_app/components/toast.dart';


class LoginScreen extends StatelessWidget {
  
var formkey = GlobalKey<FormState>();
var emailcontroller = TextEditingController();
var paswordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLoginCUbit(),
      child: BlocConsumer<SocialLoginCUbit,SocialLoginState>(
        listener: (context, state) {
          if(state is SocialLoginErrorState){
            showToast(message: state.error, color: wrongToast);
          }
          if(state is SocialLoginSuccessState){
            print('LOGIN');
            CacheHelper.savedata(key:'UID',
             value:state.uid).then((value)async {
               uId=state.uid;
              SocialCubit.get(context).getUserDta();
               navigateToAndFinish(context, Home());
             });
             
          }
        },
        builder: (context, state) => 
         Scaffold(
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
                              'LOGIN',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(color: Colors.black),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              'Login Now To Browse Our Hot Offers',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            defaultFormFiled(
                                controller: emailcontroller,
                                action: TextInputAction.next,
                                type: TextInputType.emailAddress,
                                validate: (String? value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'please enter email address';
                                  }
                                  return null;
                                },
                                lable: 'Email Address',
                                prefixIcon: Icons.email_outlined),
                            SizedBox(
                              height: 15.0,
                            ),
                            defaultFormFiled(
                                controller: paswordcontroller,
                                type: TextInputType.visiblePassword,
                                suffix: SocialLoginCUbit.get(context).isPassword
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
                                scureText: SocialLoginCUbit.get(context).isPassword,
                                suffixPressed: () {
                                  SocialLoginCUbit.get(context).changpassworedIcon();
                                },
                                prefixIcon: Icons.lock_outline),
                            SizedBox(
                              height: 30.0,
                            ),
                            ConditionalBuilder(
                                condition: state is! SocialLoginLoadingState,
                                builder: (context) => Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: defaultColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      child: MaterialButton(
                                          child: Text(
                                            'Login'.toUpperCase(),
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                          
                                            if (formkey.currentState!.validate()) {
                                              SocialLoginCUbit.get(context).userLogin(
                                                  email: emailcontroller.text,
                                                  password: paswordcontroller.text);
                                                  
                                            }
                                          }),
                                    )
                               
                                ,
                                fallback: (context) =>
                                    Center(child: CircularProgressIndicator())),
                         
                            SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Dont have an account ?'),
                                defaultTextBtn(text: 'register', onpress:() {
                                  
                                  navigateTo(context, SocialRegisterScreen());
                                }),
                               
                              ],
                            )
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