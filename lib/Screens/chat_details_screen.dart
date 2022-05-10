// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:social_app/AppCubits/social_Cubits/cubits.dart';
import 'package:social_app/AppCubits/social_Cubits/states.dart';
import 'package:social_app/components/colors.dart';
import 'package:social_app/components/icons.dart';
import 'package:social_app/components/widget.dart';
import 'package:social_app/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel? user;
  ChatDetailsScreen({this.user});

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMessages(user!.id);
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0.0,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(user!.image!),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(user!.name!),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          var meassge = SocialCubit.get(context).messags[index];
                          if (SocialCubit.get(context).model!.id ==
                              meassge.senderId) {
                            return buildSenderMessages(meassge, context);
                          }
                          return buildRecieverMessages(meassge, context);
                        },
                        separatorBuilder: (context, index) => SizedBox(
                              height: 15.0,
                            ),
                        itemCount: SocialCubit.get(context).messags.length),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
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
                          controller: messageController,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintText: 'type your message here...',
                            suffixIcon: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () async {
                                      await SocialCubit.get(context)
                                          .getMessageImage();
                                    },
                                    icon: Icon(
                                      IconBroken.Camera,
                                      color: Theme.of(context).iconTheme.color,
                                    )),
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      if (SocialCubit.get(context)
                                              .messageImage ==
                                          null) {
                                        SocialCubit.get(context).sendMessage(
                                            receiverId: user!.id,
                                            datetime: DateTime.now().toString(),
                                            text: messageController.text);
                                      } else {
                                        SocialCubit.get(context)
                                            .uploadMessageImage(
                                                dateTime:
                                                    DateTime.now().toString(),
                                                text: messageController.text,
                                                receiverId: user!.id);
                                      }
                                      SocialCubit.get(context)
                                          .removeMessageImage();
                                      messageController.clear();
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
                  if (SocialCubit.get(context).messageImage != null)
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
                                    image: FileImage(SocialCubit.get(context)
                                        .messageImage!))),
                          ),
                          CircleAvatar(
                            radius: 20.0,
                            child: IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).removeMessageImage();
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
            ),
          );
        },
      );
    });
  }
}
