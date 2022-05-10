import 'package:flutter/material.dart';
import 'package:social_app/AppCubits/social_Cubits/cubits.dart';
import 'package:social_app/AppCubits/social_Cubits/states.dart';
import 'package:social_app/components/colors.dart';
import 'package:social_app/components/divider.dart';
import 'package:social_app/models/likes_model.dart';
import 'package:social_app/models/user_model.dart';
import '../components/widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class LikesScreen extends StatelessWidget {
  String? postId;

  LikesScreen(this.postId);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getLikes(postId);

      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          List<LikesModel> peopleReacted =
              SocialCubit.get(context).peopleReacted;
          print('peopleReacted');
          print('lool');
          print(peopleReacted.length);
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildWhoLikesItem(peopleReacted[index], context),
                  separatorBuilder: (context, index) => myDivider(),
                  itemCount: peopleReacted.length,
                ))
            /*ConditionalBuilder(
            condition: (peopleReacted.isNotEmpty),
            builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    buildWhoLikesItem(peopleReacted[index], context,peopleReacted[index].name),
                separatorBuilder: (context, index) => myDivider(),
                itemCount: peopleReacted.length,
              ),
            ),
            fallback: (context) => Center(child: CircularProgressIndicator()),
          );*/
            ,
          );
        },
      );
    });
  }
}
