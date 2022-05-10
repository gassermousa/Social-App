// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:social_app/AppCubits/social_Cubits/cubits.dart';
import 'package:social_app/AppCubits/social_Cubits/states.dart';
import 'package:social_app/components/constant.dart';

import 'package:social_app/components/icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/components/widget.dart';
import 'package:social_app/models/post_model.dart';

class CommenstScreen extends StatelessWidget {
  final String postID;
  final String userToken;
  CommenstScreen(this.postID, this.userToken);

  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getComments(postUid: postID);
      SocialCubit.get(context).getSinglePost(postID);
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          PostModel? post = SocialCubit.get(context).singlePost;
          return Scaffold(
            appBar: AppBar(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SocialCubit.get(context).comments.isNotEmpty
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.separated(
                              itemBuilder: (context, index) => buildComment(
                                  SocialCubit.get(context).comments[index],
                                  context),
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 7.0,
                                  ),
                              itemCount:
                                  SocialCubit.get(context).comments.length),
                        ),
                      )
                    : Center(
                        child: Center(
                            child: Text(
                        'No Comments yet',
                        style: Theme.of(context).textTheme.bodyText1,
                      ))),
                if (SocialCubit.get(context).comments.isEmpty)
                  Expanded(child: SizedBox()),
                SizedBox(
                  height: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          width: 1.0,
                          color: Colors.grey[300]!,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        controller: commentController,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: 'type your comment here...',
                          suffixIcon: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    await SocialCubit.get(context)
                                        .getCommentImage();
                                  },
                                  icon: Icon(
                                    IconBroken.Camera,
                                    color: Theme.of(context).iconTheme.color,
                                  )),
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    if (SocialCubit.get(context).model!.token !=
                                        userToken) {
                                      SocialCubit.get(context).sendFCMNotification(
                                          token: userToken,
                                          senderName: SocialCubit.get(context)
                                              .model!
                                              .name,
                                          messageText:
                                              '${SocialCubit.get(context).model!.name}' +
                                                  ' commented on a post you shared');
                                      SocialCubit.get(context)
                                          .sendInAppNotification(
                                              content:
                                                  ' commented on a post you shared',
                                              contentId: postID,
                                              receiverId: post!.userId,
                                              receiverName: post.username);
                                    }

                                    if (SocialCubit.get(context).commentImage ==
                                        null) {
                                      SocialCubit.get(context).sendComment(
                                          dateTime: DateTime.now().toString(),
                                          text: commentController.text,
                                          postid: postID);
                                    } else {
                                      SocialCubit.get(context)
                                          .uploadcommentImage(
                                              dateTime:
                                                  DateTime.now().toString(),
                                              text: commentController.text,
                                              postid: postID);
                                    }
                                    SocialCubit.get(context)
                                        .removeCommentImage();
                                    commentController.clear();
                                  },
                                  icon: Icon(IconBroken.Send,
                                      color:
                                          Theme.of(context).iconTheme.color)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (SocialCubit.get(context).commentImage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Container(
                          height: 150.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                      SocialCubit.get(context).commentImage!))),
                        ),
                        CircleAvatar(
                          radius: 20.0,
                          child: IconButton(
                              onPressed: () {
                                SocialCubit.get(context).removeCommentImage();
                              },
                              icon: Icon(
                                IconBroken.Close_Square,
                                size: 16,
                              )),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      );
    });
  }
}
