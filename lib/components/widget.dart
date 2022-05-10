// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:social_app/AppCubits/social_Cubits/cubits.dart';
import 'package:social_app/AppCubits/social_Cubits/states.dart';
import 'package:social_app/Screens/chat_details_screen.dart';
import 'package:social_app/Screens/comments_screen.dart';
import 'package:social_app/Screens/image_view_screen.dart';
import 'package:social_app/Screens/likes_post_screen.dart';
import 'package:social_app/Screens/single_post_screen.dart';
import 'package:social_app/components/colors.dart';
import 'package:social_app/components/icons.dart';
import 'package:social_app/components/navigator.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/likes_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/notification_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'divider.dart';
import 'package:timeago/timeago.dart' as timeage;
import 'package:get_time_ago/get_time_ago.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget postItem(
  List<String> myLikedByMe,
  PostModel postModel,
  context,
  index,
  String postID,
) =>
    Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 10.0,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Row(
                  // ignore: prefer_const_literals_to_create_immutables

                  children: [
                    InkWell(
                      onTap: () {
                        navigateTo(
                            context,
                            ImageViewScreen(
                              image: postModel.userImage,
                            ));
                      },
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(postModel.userImage!),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                postModel.username!,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(height: 1.4),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Icon(
                                Icons.check_circle,
                                color: defaultColor,
                                size: 16.0,
                              )
                            ],
                          ),
                          Text(
                            timeage.format(DateTime.parse(postModel.postDate!),
                                locale: 'en_short')
                            //GetTimeAgo.parse(DateTime.parse( postModel.postDate!))
                            // postModel.postDate!
                            ,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: myDivider(),
                ),
                Text(
                  postModel.postText!,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(height: 1.3),
                ),
                /*  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 6.0),
                          child: SizedBox(
                            height: 25.0,
                            child: MaterialButton(
                              onPressed: () {},
                              child: Text(
                                '#software',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: defaultColor),
                              ),
                              padding: EdgeInsets.zero,
                              minWidth: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),*/
                if (postModel.postImage != '')
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: InkWell(
                      onTap: () {
                        navigateTo(
                            context,
                            ImageViewScreen(
                              image: postModel.postImage,
                            ));
                      },
                      child: Container(
                        height: 305.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            image: DecorationImage(
                                image: NetworkImage(postModel.postImage!),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            navigateTo(context, LikesScreen(postID));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Icon(
                                  IconBroken.Heart,
                                  size: 16.0,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 5.0),
                                /* Text(
                                      likes[postID] != 0 ? likes[postID].toString():'0' ,
                                      style: Theme.of(context).textTheme.caption,
                                    ),
                             BlocConsumer<SocialCubit, SocialStates>(
                                listener: (context, state) {
                                  if (state is SocialGetPostsSuccessStates) {
                                  
                                  }
                                },
                                builder: (context, state) {
                                  if (likes.isEmpty){
        
                                    return Text(
                                      likes[postID].toString(),
                                      style: Theme.of(context).textTheme.caption,
                                    );
                                  }
                                    else{
                                      return Text(
                                        '0 ',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      );
                                    }
                                },
                             ),*/
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Posts')
                                        .doc(SocialCubit.get(context)
                                            .postsId[index])
                                        .collection('Likes')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        );
                                      } else {
                                        return Text(
                                          '0 ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        );
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Icon(
                                  IconBroken.Chat,
                                  size: 16.0,
                                  color: Colors.amber,
                                ),
                                SizedBox(width: 5.0),
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Posts')
                                        .doc(SocialCubit.get(context)
                                            .postsId[index])
                                        .collection('Comments')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return InkWell(
                                          onTap: () {
                                            navigateTo(
                                                context,
                                                CommenstScreen(postID,
                                                    postModel.usertokenn!));
                                          },
                                          child: Text(
                                            snapshot.data!.docs.length
                                                    .toString() +
                                                ' comments',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        );
                                      } else {
                                        return Text(
                                          '0 ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        );
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: myDivider(),
                ),
                Row(
                  // ignore: prefer_const_literals_to_create_immutables

                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          navigateTo(context,
                              CommenstScreen(postID, postModel.usertokenn!));
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18.0,
                              backgroundImage: NetworkImage(
                                  SocialCubit.get(context).model!.image!),
                            ),
                            SizedBox(width: 20.0),
                            Text(
                              'Write a coment',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(height: 1.4),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (myLikedByMe.contains(postID))
                      InkWell(
                        onTap: () {
                          SocialCubit.get(context).disLikePost(postID);
                          /* if (SocialCubit.get(context)
                          .myLikedByMe[index]
                          .contains(SocialCubit.get(context).postsId[index])) {
                      } else {
                        SocialCubit.get(context)
                            .likePosts(SocialCubit.get(context).postsId[index]);
                      }*/

                          print(
                              SocialCubit.get(context).likes[index].toString());
                        },
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Icon(
                              IconBroken.Heart,
                              size: 16.0,
                              color: null,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              'UnLike',
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      ),
                    if (!myLikedByMe.contains(postID))
                      InkWell(
                        onTap: () {
                          print('ana ' + SocialCubit.get(context).model!.id!);
                          SocialCubit.get(context).likePosts(postID);
                          if (SocialCubit.get(context).model!.id !=
                              postModel.userId) {
                            SocialCubit.get(context).sendFCMNotification(
                                token: postModel.usertokenn,
                                senderName:
                                    SocialCubit.get(context).model!.name,
                                messageText:
                                    '${SocialCubit.get(context).model!.name}' +
                                        ' Liked on a post you shared');
                            SocialCubit.get(context).sendInAppNotification(
                                content: ' Liked on a post you shared',
                                contentId: postID,
                                receiverId: postModel.userId,
                                receiverName: postModel.username);
                          }
                          /* if (SocialCubit.get(context)
                          .myLikedByMe[index]
                          .contains(SocialCubit.get(context).postsId[index])) {
                        SocialCubit.get(context)
                            .disLikePost(SocialCubit.get(context).postsId[index]);
                      } else {
                      }*/
                        },
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Icon(
                              IconBroken.Heart,
                              size: 16.0,
                              color: Colors.red,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              'Like',
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );

Widget buildChatItem(UserModel userModel, context) => InkWell(
      onTap: () {
        navigateTo(
            context,
            ChatDetailsScreen(
              user: userModel,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(userModel.image!),
            ),
            SizedBox(width: 20.0),
            Text(
              userModel.name!,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );

Widget buildSenderMessages(MessageModel messageModel, context) => Align(
      alignment: AlignmentDirectional.centerEnd,
      child: messageModel.image != null
          ? InkWell(
              onTap: () {
                navigateTo(
                    context,
                    ImageViewScreen(
                      image: messageModel.image,
                    ));
              },
              child: Container(
                height: 200.0,
                width: 100.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        image: NetworkImage(messageModel.image!),
                        fit: BoxFit.cover)),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              decoration: BoxDecoration(
                  color: defaultColor.withOpacity(0.2),
                  borderRadius: BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(10.0),
                    topEnd: Radius.circular(10.0),
                    topStart: Radius.circular(10.0),
                  )),
              child: Text(
                messageModel.text!,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 14.0),
              )),
    );
Widget buildRecieverMessages(MessageModel messageModel, context) => Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(10.0),
                topEnd: Radius.circular(10.0),
                topStart: Radius.circular(10.0),
              )),
          child: Text(
            messageModel.text!,
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0),
          )),
    );
Widget buildWhoLikesItem(LikesModel likesModel, context) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          InkWell(
            onTap: () {
              navigateTo(
                  context,
                  ImageViewScreen(
                    image: likesModel.profilePicture,
                  ));
            },
            child: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(likesModel.profilePicture!),
            ),
          ),
          SizedBox(width: 20.0),
          Text(
            likesModel.name!,
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16.0),
          ),
          Spacer(),
          Icon(
            IconBroken.Heart,
            size: 20.0,
            color: Colors.red,
          ),
        ],
      ),
    );
Widget buildComment(CommentModel commentModel, context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(commentModel.profileImage!),
          ),
          SizedBox(
            width: 5.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 300.0),
                decoration: BoxDecoration(
                    color: SocialCubit.get(context).isDark
                        ? Colors.grey[600]
                        : Color.fromARGB(220, 238, 238, 238),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        commentModel.commenterName!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 17.0),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        commentModel.text!,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              if (commentModel.commentImage != '')
                InkWell(
                  onTap: () {
                    navigateTo(
                        context,
                        ImageViewScreen(
                          image: commentModel.commentImage,
                        ));
                  },
                  child: Container(
                    height: 200.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                            image: NetworkImage(commentModel.commentImage!),
                            fit: BoxFit.cover)),
                  ),
                ),
            ],
          )
        ],
      ),
    );

Widget buildNotificationItem(NotificationModel notificationModel, context) =>
    InkWell(
      onTap: () {
        SocialCubit.get(context).getSinglePost(notificationModel.contentId);
        navigateTo(
            context,
            SinglePostScreen(
              postID: notificationModel.contentId,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage:
                  NetworkImage(notificationModel.senderProfilePicture!),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(children: [
                      TextSpan(
                          text: notificationModel.senderName,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .color)),
                      TextSpan(
                        text: notificationModel.content,
                        style: TextStyle(
                            fontSize: 15,
                            color:
                                Theme.of(context).textTheme.bodyText2!.color),
                      )
                    ]),
                  ),
                  Text(
                      timeage.format(
                        DateTime.parse(notificationModel.dateTime!),
                      ),
                      style: TextStyle(fontSize: 15, color: Colors.grey[500]))
                ],
              ),
            ),
          ],
        ),
      ),
    );

Widget singlePostItem(
  List<String> myLikedByMe,
  PostModel postModel,
  context,
  int likes,
  int commnents,
  String postID,
) =>
    Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 10.0,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Row(
                  // ignore: prefer_const_literals_to_create_immutables

                  children: [
                    InkWell(
                      onTap: () {
                        navigateTo(
                            context,
                            ImageViewScreen(
                              image: postModel.userImage,
                            ));
                      },
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(postModel.userImage!),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                postModel.username!,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(height: 1.4),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Icon(
                                Icons.check_circle,
                                color: defaultColor,
                                size: 16.0,
                              )
                            ],
                          ),
                          Text(
                            timeage.format(DateTime.parse(postModel.postDate!),
                                locale: 'en_short')
                            //GetTimeAgo.parse(DateTime.parse( postModel.postDate!))
                            // postModel.postDate!
                            ,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.more_horiz,
                          size: 16.0,
                          color: Colors.grey,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: myDivider(),
                ),
                Text(
                  postModel.postText!,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(height: 1.3),
                ),
                /*  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 6.0),
                          child: SizedBox(
                            height: 25.0,
                            child: MaterialButton(
                              onPressed: () {},
                              child: Text(
                                '#software',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: defaultColor),
                              ),
                              padding: EdgeInsets.zero,
                              minWidth: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),*/
                if (postModel.postImage != '')
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: InkWell(
                      onTap: () {
                        navigateTo(
                            context,
                            ImageViewScreen(
                              image: postModel.postImage,
                            ));
                      },
                      child: Container(
                        height: 155.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            image: DecorationImage(
                                image: NetworkImage(postModel.postImage!),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            navigateTo(context, LikesScreen(postID));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Icon(
                                  IconBroken.Heart,
                                  size: 16.0,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  likes.toString(),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                /* Text(
                                      likes[postID] != 0 ? likes[postID].toString():'0' ,
                                      style: Theme.of(context).textTheme.caption,
                                    ),
                             BlocConsumer<SocialCubit, SocialStates>(
                                listener: (context, state) {
                                  if (state is SocialGetPostsSuccessStates) {
                                  
                                  }
                                },
                                builder: (context, state) {
                                  if (likes.isEmpty){
        
                                    return Text(
                                      likes[postID].toString(),
                                      style: Theme.of(context).textTheme.caption,
                                    );
                                  }
                                    else{
                                      return Text(
                                        '0 ',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      );
                                    }
                                },
                             ),*/
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Icon(
                                  IconBroken.Chat,
                                  size: 16.0,
                                  color: Colors.amber,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  commnents.toString(),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: myDivider(),
                ),
                Row(
                  // ignore: prefer_const_literals_to_create_immutables

                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          navigateTo(context,
                              CommenstScreen(postID, postModel.usertokenn!));
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18.0,
                              backgroundImage: NetworkImage(
                                  SocialCubit.get(context).model!.image!),
                            ),
                            SizedBox(width: 20.0),
                            Text(
                              'Write a coment',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(height: 1.4),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (myLikedByMe.contains(postID))
                      InkWell(
                        onTap: () {
                          SocialCubit.get(context).disLikePost(postID);
                          /* if (SocialCubit.get(context)
                          .myLikedByMe[index]
                          .contains(SocialCubit.get(context).postsId[index])) {
                      } else {
                        SocialCubit.get(context)
                            .likePosts(SocialCubit.get(context).postsId[index]);
                      }*/
                        },
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Icon(
                              IconBroken.Heart,
                              size: 16.0,
                              color: null,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              'UnLike',
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      ),
                    if (!myLikedByMe.contains(postID))
                      InkWell(
                        onTap: () {
                          SocialCubit.get(context).likePosts(postID);
                          /* if (SocialCubit.get(context)
                          .myLikedByMe[index]
                          .contains(SocialCubit.get(context).postsId[index])) {
                        SocialCubit.get(context)
                            .disLikePost(SocialCubit.get(context).postsId[index]);
                      } else {
                      }*/
                        },
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Icon(
                              IconBroken.Heart,
                              size: 16.0,
                              color: Colors.red,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              'Like',
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
