// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:social_app/AppCubits/social_Cubits/cubits.dart';
import 'package:social_app/AppCubits/social_Cubits/states.dart';
import 'package:social_app/Screens/news_feed.dart';
import 'package:social_app/components/btn.dart';
import 'package:social_app/components/icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/components/navigator.dart';

class NewPost extends StatelessWidget {
  var textcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialCreatePostSuccsess) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(IconBroken.Arrow___Left_2),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('Add Post'),
            titleSpacing: 5.0,
            // ignore: prefer_const_literals_to_create_immutables
            actions: [
              defaultTextBtn(
                  text: 'Post',
                  onpress: () {
                    if (cubit.postImage == null) {
                      SocialCubit.get(context).posts = [];
                      cubit.createPost(
                          postText: textcontroller.text,
                          postDate: DateTime.now().toString());
                    } else {
                      SocialCubit.get(context).posts = [];
                      cubit.upLoadPostImage(
                          postText: textcontroller.text,
                          postDate: DateTime.now().toString());
                    }
                  }),
              SizedBox(
                width: 10.0,
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is SocialCreatePostLoading) LinearProgressIndicator(),
                if (state is SocialCreatePostLoading)
                  SizedBox(
                    height: 10.0,
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage:
                          NetworkImage(SocialCubit.get(context).model!.image!),
                    ),
                    SizedBox(width: 20.0),
                    Text(
                      SocialCubit.get(context).model!.name!,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(height: 1.4, fontSize: 14.0),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  textInputAction: TextInputAction.newline,
                  controller: textcontroller,
                  decoration: InputDecoration(
                      hintText: 'What is on your mind ...',
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                ),
                if (cubit.postImage != null)
                  Expanded(
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(cubit.postImage!))),
                        ),
                        CircleAvatar(
                          radius: 20.0,
                          child: IconButton(
                              onPressed: () {
                                cubit.removePostImage();
                              },
                              icon: Icon(
                                IconBroken.Close_Square,
                                size: 16,
                              )),
                        ),
                      ],
                    ),
                  ),
                if (cubit.postImage == null) Expanded(child: SizedBox()),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () async {
                            await cubit.getPostImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(IconBroken.Image),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text('Add Photo')
                            ],
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
