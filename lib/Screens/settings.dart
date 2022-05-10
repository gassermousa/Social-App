import 'package:flutter/material.dart';
import 'package:social_app/AppCubits/social_Cubits/cubits.dart';
import 'package:social_app/AppCubits/social_Cubits/states.dart';
import 'package:social_app/Screens/edit_profile_screen.dart';
import 'package:social_app/Screens/image_view_screen.dart';
import 'package:social_app/Screens/new_post.dart';
import 'package:social_app/components/btn.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/components/icons.dart';
import 'package:social_app/components/navigator.dart';
import 'package:social_app/components/widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getPostsUser();
      return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var user = SocialCubit.get(context).model;
            var cubit = SocialCubit.get(context);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    SizedBox(
                      height: 190.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: InkWell(
                              onTap: () {
                                navigateTo(
                                    context,
                                    ImageViewScreen(
                                      image: user!.imageCover,
                                    ));
                              },
                              child: Container(
                                height: 140.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0)),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          NetworkImage('${user!.imageCover}'),
                                    )),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              navigateTo(
                                  context,
                                  ImageViewScreen(
                                    image: user.image,
                                  ));
                            },
                            child: CircleAvatar(
                              radius: 63.0,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: NetworkImage('${user.image}'),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Text(
                      user.name!,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      user.bio!,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    cubit.myposts.length.toString(),
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    'Posts',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    cubit.myPostImage.length.toString(),
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    'Photo',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /* Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    '100',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    'Followers',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                          ),*/
                          /* Expanded(
                            child: InkWell(
                              onTap: () {},
                              /*child: Column(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    '100',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    'Following',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),*/
                            ),
                          ),*/
                        ],
                      ),
                    ),
                    // ignore: prefer_const_literals_to_create_immutables
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              navigateTo(context, NewPost());
                            },
                            child: Text('Add Post'),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            navigateTo(context, EditProfileScreen());
                          },
                          child: Icon(
                            IconBroken.Edit,
                            size: 16.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          SocialCubit.get(context).signOut(context);
                        },
                        child: Text('Log Out'),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => postItem(
                        SocialCubit.get(context).LikedByMe,
                        SocialCubit.get(context).myposts[index],
                        context,
                        index,
                        SocialCubit.get(context).mypostsId[index],
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 8.0,
                      ),
                      itemCount: SocialCubit.get(context).myposts.length,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }
}
