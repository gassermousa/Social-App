import 'package:flutter/material.dart';
import 'package:social_app/AppCubits/social_Cubits/cubits.dart';
import 'package:social_app/AppCubits/social_Cubits/states.dart';
import 'package:social_app/components/colors.dart';
import 'package:social_app/components/divider.dart';
import '../components/widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getInAppNotification();
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          print(SocialCubit.get(context).notifications.length);
          return Scaffold(
            appBar: AppBar(),
            body: ConditionalBuilder(
              condition: (SocialCubit.get(context).notifications.isNotEmpty),
              builder: (context) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => buildNotificationItem(
                      SocialCubit.get(context).notifications[index], context),
                  separatorBuilder: (context, index) => myDivider(),
                  itemCount: SocialCubit.get(context).notifications.length,
                ),
              ),
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
          );
        },
      );
    });
  }
}
