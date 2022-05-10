// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/AppCubits/social_Cubits/cubits.dart';
import 'package:social_app/AppCubits/social_Cubits/states.dart';
import 'package:social_app/components/navigator.dart';
import 'package:social_app/components/widget.dart';
import 'package:social_app/models/post_model.dart';

class SinglePostScreen extends StatefulWidget {
  final String? postID;
  SinglePostScreen({this.postID});

  @override
  State<SinglePostScreen> createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          print(state);
        },
        builder: (context, state) {
          if (state is GetSinglePostSuccessState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  singlePostItem(
                      SocialCubit.get(context).LikedByMe,
                      state.post,
                      context,
                      state.post.likes!,
                      state.post.comments!,
                      widget.postID!)
                ],
              ),
            );
          } else if (SocialCubit.get(context).singlePost != null) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  singlePostItem(
                      SocialCubit.get(context).LikedByMe,
                      SocialCubit.get(context).singlePost!,
                      context,
                      SocialCubit.get(context).singlePost!.likes!,
                      SocialCubit.get(context).singlePost!.comments!,
                      widget.postID!)
                ],
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
