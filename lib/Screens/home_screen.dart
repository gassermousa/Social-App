import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/AppCubits/social_Cubits/cubits.dart';
import 'package:social_app/AppCubits/social_Cubits/states.dart';
import 'package:social_app/Screens/new_post.dart';
import 'package:social_app/Screens/notifications_screen.dart';
import 'package:social_app/components/btn.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/components/colors.dart';
import 'package:social_app/components/icons.dart';
import 'package:social_app/components/navigator.dart';
import 'package:social_app/components/toast.dart';
import 'package:social_app/components/widget.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {
        if (state is SocialPostState) {
          navigateTo(context, NewPost());
        }
      }, builder: (context, state) {
        var cubit = SocialCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            actions: [
              IconButton(
                  onPressed: () {
                    SocialCubit.get(context).changeMode();
                  },
                  icon: Icon(
                    Icons.dark_mode_outlined,
                    color: Theme.of(context).iconTheme.color!.withOpacity(0.7),
                  )),
              Stack(
                alignment: Alignment.centerRight,

                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        navigateTo(context, NotificationsScreen());
                        cubit.readNotification();
                      },
                      icon: Icon(IconBroken.Notification)),
                  if (cubit.unReadNotificationsCount != 0)
                    Positioned(
                      top: 0.0,
                      child: CircleAvatar(
                          radius: 10.0,
                          child: Text(
                            cubit.unReadNotificationsCount.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: Colors.white),
                          )),
                    ),
                ],
              ),
              //buildBadge(icon: IconBroken.Notification, count: 3),
              // IconButton(onPressed: () {}, icon: Icon(IconBroken.Search))
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottomNav(index);
              },
              // ignore: prefer_const_literals_to_create_immutables
              items: [
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Chat), label: 'Chat'),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Paper_Upload), label: 'Post'),
                /*BottomNavigationBarItem(
                    icon: Icon(IconBroken.Location), label: 'Users'),*/
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Setting), label: 'Settings'),
              ]),
        );
      });
    });
  }
}

class verifyEmail extends StatelessWidget {
  const verifyEmail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if(!FirebaseAuth.instance.currentUser!.emailVerified)
    return Container(
      color: Colors.amber.withOpacity(0.6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Icon(Icons.info_outline),
            SizedBox(
              width: 15.0,
            ),
            Expanded(child: Text('please verify your email')),
            SizedBox(
              width: 20.0,
            ),
            defaultTextBtn(
                text: 'Send',
                onpress: () {
                  FirebaseAuth.instance.currentUser!
                      .sendEmailVerification()
                      .then((value) {
                    showToast(
                        message: 'Check Your Email ', color: successedToast);
                  }).catchError((error) {});
                })
          ],
        ),
      ),
    );
  }
}
