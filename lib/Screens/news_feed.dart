import 'package:flutter/material.dart';
import 'package:social_app/AppCubits/social_Cubits/cubits.dart';
import 'package:social_app/AppCubits/social_Cubits/states.dart';

import 'package:social_app/components/widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: ConditionalBuilder(
            condition: (SocialCubit.get(context).posts.isNotEmpty &&
                SocialCubit.get(context).model != null),
            builder: (context) => RefreshIndicator(
              onRefresh: () async {
                SocialCubit.get(context).getPosts();
              },
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Card(
                        margin: EdgeInsets.all(8.0),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 10.0,
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Image(
                              image: NetworkImage(
                                  'https://img.freepik.com/free-photo/impressed-young-man-points-away-shows-direction-somewhere-gasps-from-wonderment_273609-27041.jpg?t=st=1648381565~exp=1648382165~hmac=55b8e8732c9b71e923d72094a7c44ecfae1fea58264e03ecd35621b389a03d74&w=900'),
                              fit: BoxFit.cover,
                              height: 200.0,
                              width: double.infinity,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text('Communicate With Your Friends',
                                  style: Theme.of(context).textTheme.subtitle1),
                            )
                          ],
                        )),
                    ListView.separated(
                      reverse: true,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => postItem(
                        SocialCubit.get(context).myLikedByMe,
                        SocialCubit.get(context).posts[index],
                        context,
                        index,
                        SocialCubit.get(context).postsId[index],
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 8.0,
                      ),
                      itemCount: SocialCubit.get(context).posts.length,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
            ),
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
