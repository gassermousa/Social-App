import 'package:flutter/material.dart';
import 'package:social_app/AppCubits/social_Cubits/cubits.dart';
import 'package:social_app/AppCubits/social_Cubits/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:social_app/components/divider.dart';

import '../components/widget.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        print('lololol');
        print('userchats + ${SocialCubit.get(context).myUsersChat.length}');
        return ConditionalBuilder(
          condition: (SocialCubit.get(context).myUsersChat.isNotEmpty),
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => buildChatItem(
                  SocialCubit.get(context).myUsersChat[index], context),
              separatorBuilder: (context, index) => myDivider(),
              itemCount: SocialCubit.get(context).myUsersChat.length,
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
