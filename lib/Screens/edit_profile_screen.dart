// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_app/AppCubits/social_Cubits/cubits.dart';
import 'package:social_app/AppCubits/social_Cubits/states.dart';
import 'package:social_app/components/btn.dart';
import 'package:social_app/components/formfield.dart';
import 'package:social_app/components/icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var user = SocialCubit.get(context).model;
        var profileImage = SocialCubit.get(context).profileimage;
        var coverImage = SocialCubit.get(context).coverimage;
        nameController.text = user!.name!;
        bioController.text = user.bio!;
        phoneController.text = user.phone!;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(IconBroken.Arrow___Left_2),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('Edit'),
            titleSpacing: 5.0,
            // ignore: prefer_const_literals_to_create_immutables
            actions: [
              defaultTextBtn(
                  text: 'Update',
                  onpress: () {
                    if (formkey.currentState!.validate()) {
                      SocialCubit.get(context).upDateUser(
                          name: nameController.text,
                          bio: bioController.text,
                          phone: phoneController.text,
                          cover: user.imageCover,
                          profile: user.image);
                    }
                  }),
              SizedBox(
                width: 10.0,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    if (state is SocialUpdateUserLoading)
                      Column(
                        children: [
                          LinearProgressIndicator(),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 190.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Stack(
                                alignment: AlignmentDirectional.topEnd,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Container(
                                    height: 140.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0)),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                            image: coverImage == null
                                                ? NetworkImage(
                                                    '${user.imageCover}')
                                                : FileImage(coverImage)
                                                    as ImageProvider)),
                                  ),
                                  CircleAvatar(
                                    radius: 20.0,
                                    child: IconButton(
                                        onPressed: () async{
                                          await SocialCubit.get(context)
                                              .getCoverImage();
                                              print('gasser');
                                          SocialCubit.get(context)
                                              .uploadCoverImage(
                                                  bio: user.bio,
                                                  name: user.name,
                                                  phone: user.phone,
                                                  profile: user.image);
                                        },
                                        icon: Icon(
                                          IconBroken.Camera,
                                          size: 16,
                                        )),
                                  )
                                ],
                              )),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            // ignore: prefer_const_literals_to_create_immutables?
          
                            children: [
                              CircleAvatar(
                                radius: 63.0,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage: profileImage == null
                                        ? NetworkImage('${user.image}')
                                        : FileImage(profileImage)
                                            as ImageProvider),
                              ),
                              CircleAvatar(
                                radius: 22.0,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 20.0,
                                  child: IconButton(
                                      onPressed: ()async {
                                       await SocialCubit.get(context)
                                            .getProfileImage();
                                        SocialCubit.get(context)
                                            .uploadProfileImage(
                                                bio: user.bio,
                                                name: user.name,
                                                phone: user.phone,
                                                cover: user.imageCover);
                                                
                                      },
                                      icon: Icon(
                                        IconBroken.Camera,
                                        size: 16,
                                      )),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    defaultFormFiled(
                      
                        controller: nameController,
                        type: TextInputType.name,
                        action: TextInputAction.next,
                        validate: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'please enter name';
                          }
                          return null;
                        },
                        lable: 'Name',
                        prefixIcon: IconBroken.User),
                    SizedBox(
                      height: 10.0,
                    ),
                    defaultFormFiled(
                        controller: bioController,
                        type: TextInputType.name,
                        action: TextInputAction.next,
                        validate: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'please enter bio';
                          }
                          return null;
                        },
                        lable: 'Bio',
                        prefixIcon: IconBroken.Info_Circle),
                    SizedBox(
                      height: 10.0,
                    ),
                    defaultFormFiled(
                        controller: phoneController,
                        type: TextInputType.phone,
                        action: TextInputAction.done,
                        validate: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'please enter Phone';
                          }
                          return null;
                        },
                        lable: 'Phone',
                        prefixIcon: IconBroken.Call),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
