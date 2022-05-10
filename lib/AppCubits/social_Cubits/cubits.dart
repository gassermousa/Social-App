import 'package:flutter/material.dart';
import 'package:social_app/AppCubits/social_Cubits/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Network/dio_helper.dart';
import 'package:social_app/Screens/chats.dart';
import 'package:social_app/Screens/login_screen.dart';
import 'package:social_app/Screens/new_post.dart';
import 'package:social_app/Screens/news_feed.dart';
import 'package:social_app/Screens/settings.dart';
import 'package:social_app/Screens/users.dart';
import 'package:social_app/cach_helper/cach_helper.dart';
import 'package:social_app/components/constant.dart';
import 'package:social_app/components/navigator.dart';
import 'package:social_app/components/toast.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/likes_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/notification_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialStates());
  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? model;

  Future getUserDta() async {
    print('USER  ID ${uId}');
    emit(SocialGetUserLoadingStates());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uId)
        .get()
        .then((value) async {
      model = UserModel.fromJson(value.data()!);
      setUserToken();
      getUnReadNotificationsCount();
      emit(SocialGetUserSuccessStates());
    }).catchError((error) {
      print(error);
      emit(SocialGetUserErrorStates(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    NewsFeedScreen(),
    ChatScreen(),
    NewPost(),
    // UsersScreen(),
    SettingsScreen()
  ];

  List<String> titles = ['News Feed', 'Chat', 'Post' /*, 'Users'*/, 'Settings'];

  void changeBottomNav(int index) {
    if (index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      emit(SocialPostState());
    } else {
      currentIndex = index;
      emit(ChangeBottomNavBarState());
    }
  }

  bool isDark = true;
  void changeMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(SocialChangeMode());
    } else {
      isDark = !isDark;
      CacheHelper.savedata(key: 'isDark', value: isDark).then((value) {
        emit(SocialChangeMode());
      });
    }
  }

  File? profileimage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileimage = File(pickedFile.path);

      emit(SocialProfileImagePickedSuccess());
    } else {
      emit(SocialProfileImagePickedErorr());
    }
  }

  File? coverimage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverimage = File(pickedFile.path);

      emit(SocialCoverImagePickedSuccess());
    } else {
      emit(SocialCoverImagePickedErorr());
    }
  }

  String profileImageUrl = '';
  void uploadProfileImage({
    String? name,
    String? phone,
    String? bio,
    String? cover,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Uri.file(profileimage!.path).pathSegments.last)
        .putFile(profileimage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profileImageUrl = value;

        upDateUser(
            bio: bio, phone: phone, cover: cover, name: name, profile: value);
        emit(SocialUploadProfileImageSuccess());
      }).catchError((error) {
        emit(SocialUploadProfileImageErorr());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErorr());
    });
  }

  String coverImageUrl = '';
  void uploadCoverImage({
    String? name,
    String? phone,
    String? bio,
    String? profile,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Uri.file(coverimage!.path).pathSegments.last)
        .putFile(coverimage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        coverImageUrl = value;
        upDateUser(
            bio: bio, cover: value, name: name, profile: profile, phone: phone);

        emit(SocialUploadCoverImageSuccess());
      }).catchError((error) {
        emit(SocialUploadCoverImageErorr());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErorr());
    });
  }

  void upDateUser(
      {String? name,
      String? phone,
      String? bio,
      String? profile,
      String? cover}) {
    emit(SocialUpdateUserLoading());

    UserModel userModel = UserModel(
      name: name,
      phone: phone,
      isEmailVerfied: false,
      email: model!.email,
      imageCover: cover ?? model!.imageCover,
      image: profile ?? model!.image,
      id: model!.id,
      bio: bio,
    );
    FirebaseFirestore.instance
        .collection('Users')
        .doc(model!.id)
        .update(userModel.toMap())
        .then((value) {
      getUserDta();
    }).catchError((error) {
      emit(SocialUpdateUserErorr());
    });
  }

  File? postImage;
  String? postImageURL = '';

  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);

      emit(SocialPostImagePickedSuccess());
    } else {
      emit(SocialPostImagePickedErorr());
    }
  }

  void upLoadPostImage({String? postText, String? postDate}) {
    emit(SocialCreatePostLoading());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        postImageURL = value;
        createPost(postImage: value, postText: postText, postDate: postDate);
        emit(SocialCreatePostSuccsess());
      }).catchError((error) {
        emit(SocialCreatePostError());
      });
    }).catchError((error) {
      emit(SocialCreatePostError());
    });
  }

  void removePostImage() {
    postImage = null;
    commentImage = null;
    emit(SocialPostImageRemovedState());
  }

  void removeCommentImage() {
    commentImage = null;
    emit(SocialCommentImageRemovedState());
  }

  void createPost({String? postText, String? postDate, String? postImage}) {
    posts = [];
    postsId = [];
    likes = [];
    myLikedByMe = [];
    emit(SocialCreatePostLoading());
    PostModel postModel = PostModel(
        username: model!.name,
        userId: model!.id,
        userImage: model!.image,
        postDate: postDate,
        postImage: postImage ?? '',
        postText: postText,
        likes: 0,
        comments: 0,
        usertokenn: model!.token);
    FirebaseFirestore.instance
        .collection('Posts')
        .add(postModel.toMap())
        .then((value) {
      emit(SocialCreatePostSuccsess());
    }).catchError((error) {
      emit(SocialCreatePostError());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<String> myLikedByMe = [];

  int? length = 0;
  void getPosts() {
    posts = [];
    postsId = [];
    likes = [];
    myLikedByMe = [];
    emit(SocialGetPostsLoadingStates());
    FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('postDate')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        element.reference.collection('Likes').get().then((value) {
          likes.add(value.docs.length);
          emit(SocialGetLikespostSuccessState());
          postsId.add(element.id);
          FirebaseFirestore.instance
              .collection('Posts')
              .doc(element.id)
              .update({'likes': value.docs.length});

          posts.add(PostModel.fromJson(element.data()));
          value.docs.forEach((e) {
            if (e.id == model!.id) {
              myLikedByMe.add(element.id);
            }
          });
          emit(SocialGetPostsSuccessStates());
        });
      });
      event.docs.forEach((element) {
        element.reference.collection('Comments').get().then((value) {
          FirebaseFirestore.instance
              .collection('Posts')
              .doc(element.id)
              .update({'comments': value.docs.length});
        });
      });

      emit(SocialGetPostsSuccessStates());
    });
    emit(SocialGetPostsSuccessStates());
    /*  FirebaseFirestore.instance.collection('Posts').get().then((value) {
      value.docs.forEach(
        (element) {
          element.reference.collection('Likes').get().then((value) {
            likes.add(value.docs.length);
            postsId.add(element.id);
            posts.add(PostModel.fromJson(element.data()));
            print('222222');
          }).catchError((onError) {});
        },
      );
      print('value.docs.length');
      length = value.docs.length;
      print(value.docs.length);

      emit(SocialGetPostsSuccessStates());
    }).catchError((error) {
      emit(SocialGetPostsErrorStates(error.toString()));
      print(error);
    });*/
  }

  void likePosts(String postId) {
    LikesModel likesModel = LikesModel(
      uId: model!.id,
      name: model!.name,
      profilePicture: model!.image,
      //dateTime: FieldValue.serverTimestamp()
    );
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Likes')
        .doc(model!.id)
        .set(likesModel.toMap())
        .then((value) {
      myLikedByMe.add(postId);

      emit(SocialLikePostsSuccessStates());
    }).catchError((error) {
      emit(SocialLikePostsErrorStates(error.toString()));
    });
  }

  List<LikesModel> peopleReacted = [];

  void getLikes(String? postId) {
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Likes')
        .snapshots()
        .listen((value) {
      peopleReacted = [];
      value.docs.forEach((element) {
        peopleReacted.add(LikesModel.fromJson(element.data()));
      });
      print(peopleReacted.first.name);

      emit(GetLikesSuccessState());
    });
    /*peopleReacted = [];
    print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Likes')
        .get()
        .then((value) {
      value.docs.forEach((element)async {
       await FirebaseFirestore.instance.collection('Users').get().then((myValue) {
          myValue.docs.forEach((myElement) {
            if(element.id == myElement.id)
            peopleReacted.add(UserModel.fromJson(myElement.data()));
        print(myElement.id);
          });
        });
        print(peopleReacted.length);
        print(peopleReacted.first.name);
        print(element.id);
        print('peopleReacted00000000000000');
      });
      emit(GetLikesSuccessState());
    });*/
  }

  void disLikePost(String postId) {
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Likes')
        .doc(model!.id)
        .delete()
        .then((value) {
      myLikedByMe.remove(postId);
      emit(DisLikeSuccessState());
    }).catchError((error) {
      emit(DisLikeErrorState());
      print(error.toString());
    });
  }

  void sendComment({
    required String? dateTime,
    required String? text,
    required String? postid,
    String? commentImage,
  }) {
    CommentModel comment = CommentModel(
        dateTime: dateTime,
        senderId: model!.id,
        text: text,
        profileImage: model!.image,
        commenterName: model!.name,
        commentImage: commentImage ?? '');

    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postid)
        .collection('Comments')
        .add(comment.toMap())
        .then((value) {
      emit(SendCommentSuccessState());
    }).catchError((error) {
      emit(SendCommentErrorState());
      print(error.toString());
    });
  }

  File? commentImage;
  Future<void> getCommentImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      commentImage = File(pickedFile.path);

      emit(SocialCommentImagePickedSuccess());
    } else {
      emit(SocialCommentImagePickedErorr());
    }
  }

  String commentImageUrl = '';
  void uploadcommentImage({
    required String? dateTime,
    required String? text,
    required String? postid,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('myComments/${Uri.file(commentImage!.path).pathSegments.last}')
        .putFile(commentImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        commentImageUrl = value;
        print(commentImageUrl);
        sendComment(
            dateTime: dateTime,
            text: text,
            postid: postid,
            commentImage: value);

        emit(SocialUploadCommentImageSuccess());
      }).catchError((error) {
        emit(SocialUploadCommentImageErorr());
      });
    }).catchError((error) {
      emit(SocialUploadCommentImageErorr());
    });
  }

  List<CommentModel> comments = [];
  void getComments({
    required String? postUid,
  }) {
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postUid)
        .collection('Comments')
        .orderBy('dateTime', descending: false)
        .snapshots()
        .listen((event) {
      comments = [];
      event.docs.forEach((element) {
        comments.add(CommentModel.fromJson(element.data()));
      });
      emit(GetCommentsSuccessState());
    });
  }

  void removeMessageImage() {
    messageImage = null;
    emit(SocialMessageImageRemovedState());
  }

  List<UserModel> userschats = [];
  List<UserModel> myUsersChat = [];
  void getAllUsers() async {
    print(model!.id);
    userschats = [];
    emit(SocialGetAllUserLoadingStates());
    await FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((value) async {
      value.docs.forEach(
        (element) async {
          if (element.id != model!.id) {
            userschats.add(UserModel.fromJson(element.data()));
          } else {
            element.reference.collection('chats').get().then((myvalue) async {
              print(myvalue.docs.toString() + 'hahahahahahah');
              print(element.id + 'myelement');
              myvalue.docs.forEach((myelement) async {
                myUsersChat.add(UserModel.fromJson(myelement.data()));
              });
            });
          }
        },
      );
      emit(SocialGetAllUserSuccessStates());
    }).catchError((error) {
      emit(SocialGetAllUserErrorStates(error.toString()));
      print(error);
    });
  }

  void sendMessage(
      {required String? receiverId,
      required String? datetime,
      required String? text,
      String? image}) {
    MessageModel messageModel = MessageModel(
        text: text,
        dateTime: datetime,
        receiverId: receiverId,
        senderId: model!.id,
        image: image);
    FirebaseFirestore.instance
        .collection('Users')
        .doc(model!.id)
        .collection('chats')
        .doc(receiverId)
        .collection('Messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverId)
        .collection('chats')
        .doc(model!.id)
        .collection('Messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messags = [];
  void getMessages(
    String? receiverId,
  ) {
    messags = [];
    FirebaseFirestore.instance
        .collection('Users')
        .doc(model!.id)
        .collection('chats')
        .doc(receiverId)
        .collection('Messages')
        .orderBy('dateTime', descending: false)
        .snapshots()
        .listen((event) {
      messags = [];
      event.docs.forEach((element) {
        messags.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessagesSuccessState());
    });
  }

  File? messageImage;
  Future<void> getMessageImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      messageImage = File(pickedFile.path);

      emit(SociaMessageImagePickedSuccess());
    } else {
      emit(SocialMessageImagePickedErorr());
    }
  }

  String messageImageUrl = '';
  void uploadMessageImage({
    required String? dateTime,
    required String? text,
    required String? receiverId,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'myMessagesImages/${Uri.file(messageImage!.path).pathSegments.last}')
        .putFile(messageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        messageImageUrl = value;
        print(messageImageUrl);
        sendMessage(
            datetime: dateTime,
            receiverId: receiverId,
            text: text,
            image: value);

        emit(SocialUploadMessageImageSuccess());
      }).catchError((error) {
        emit(SocialUploadMessageImageErorr());
      });
    }).catchError((error) {
      emit(SocialUploadMessageImageErorr());
    });
  }

  List<PostModel> myposts = [];
  List<String> mypostsId = [];
  List<int> mylikes = [];
  List<String> LikedByMe = [];
  List<String> myPostImage = [];
  void getPostsUser() {
    myposts = [];
    mypostsId = [];
    mylikes = [];
    LikedByMe = [];
    myPostImage = [];
    emit(SocialGetPostsLoadingStates());
    FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('postDate')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        element.reference.collection('Likes').get().then((value) {
          mylikes.add(value.docs.length);
          emit(SocialGetLikespostSuccessState());
          FirebaseFirestore.instance
              .collection('Posts')
              .doc(element.id)
              .update({'likes': value.docs.length});
          if (element.data()['userId'] == model!.id) {
            if (element.data()['postImage'] != '') {
              myPostImage.add(element.data()['postImage']);
            }
            mypostsId.add(element.id);
            myposts.add(PostModel.fromJson(element.data()));
          }
          value.docs.forEach((e) {
            if (e.id == model!.id) {
              LikedByMe.add(element.id);
            }
          });
          emit(SocialGetPostsSuccessStates());
        });
      });
      event.docs.forEach((element) {
        element.reference.collection('Comments').get().then((value) {
          FirebaseFirestore.instance
              .collection('Posts')
              .doc(element.id)
              .update({'comments': value.docs.length});
        });
      });
      emit(SocialGetPostsSuccessStates());
    });
    emit(SocialGetPostsSuccessStates());
  }

  void sendFCMNotification({
    required String? token,
    required String? senderName,
    String? messageText,
    String? messageImage,
  }) {
    DioHelper.postData(data: {
      "to": "$token",
      "notification": {
        "title": "$senderName",
        "body":
            "${messageText != null ? messageText : messageImage != null ? 'Photo' : 'ERROR 404'}",
        "sound": "default"
      },
      "android": {
        "Priority": "HIGH",
      },
      "data": {
        "type": "order",
        "id": "87",
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    });
    emit(SendMessageSuccessState());
  }

  void sendInAppNotification({
    String? contentKey,
    String? contentId,
    String? content,
    String? receiverName,
    String? receiverId,
  }) {
    emit(SendInAppNotificationLoadingState());
    NotificationModel notificationModel = NotificationModel(
      contentKey: contentKey,
      contentId: contentId,
      content: content,
      senderName: model!.name,
      receiverName: receiverName,
      senderId: model!.id,
      receiverId: receiverId,
      senderProfilePicture: model!.image,
      read: false,
      dateTime: DateTime.now().toString(),
    );

    FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverId)
        .collection('notifications')
        .add(notificationModel.toMap())
        .then((value) {
      emit(SendInAppNotificationSuccessState());
    }).catchError((error) {
      emit(SendInAppNotificationErrorState());
    });
  }

  Future setNotificationId() async {
    await FirebaseFirestore.instance.collection('Users').get().then((value) {
      value.docs.forEach((element) async {
        var notifications =
            await element.reference.collection('notifications').get();
        notifications.docs.forEach((notificationsElement) async {
          await notificationsElement.reference
              .update({'notificationId': notificationsElement.id});
        });
      });
      emit(SetNotificationIdSuccessState());
    });
  }

  List<NotificationModel> notifications = [];
  void getInAppNotification() async {
    emit(GetInAppNotificationLoadingState());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(model!.id)
        .collection('notifications')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      notifications = [];
      event.docs.forEach((element) async {
        notifications.add(NotificationModel.fromJson(element.data()));
      });
      emit(GetInAppNotificationSuccessState());
    });
  }

  int unReadNotificationsCount = 0;
  Future<int> getUnReadNotificationsCount() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(model!.id)
        .collection('notifications')
        .snapshots()
        .listen((event) {
      unReadNotificationsCount = 0;
      for (int i = 0; i < event.docs.length; i++) {
        if (event.docs[i]['read'] == false) unReadNotificationsCount++;
      }
      emit(ReadNotificationSuccessState());
      print("UnRead: " + '$unReadNotificationsCount');
    });

    return unReadNotificationsCount;
  }

  /*Future readNotification(String? notificationId) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(model!.id)
        .collection('notifications')
        .doc(notificationId)
        .update({'read': true}).then((value) {
      emit(ReadNotificationSuccessState());
    });
  }*/
  Future readNotification() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(model!.id)
        .collection('notifications')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.update({'read': true});
        // element.data()['read'] = true;
      });
      emit(ReadNotificationSuccessState());
    });
  }

  void setUserToken() async {
    emit(SetUSerTokenLoadingState());
    String? token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance.collection('Users').doc(model!.id).update(
        {'token': token}).then((value) => emit(SetUSerTokenSuccessState()));
  }

  PostModel? singlePost;
  void getSinglePost(String? postId) {
    emit(GetPostLoadingState());
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .get()
        .then((value) {
      singlePost = PostModel.fromJson(value.data()!);

      emit(GetSinglePostSuccessState(singlePost!));
    }).catchError((error) {
      emit(GetPostErrorState());
    });
  }

  void signOut(context) {
    emit(SignOutLoadingState());
    FirebaseAuth.instance.signOut().then((value) async {
      CacheHelper.removeData(key: 'UID');
      await FirebaseMessaging.instance.deleteToken();
      await FirebaseFirestore.instance.collection('Users').get().then((value) {
        value.docs.forEach((element) async {
          if (element.id == model!.id)
            element.reference.update({'token': null});
        });
      });
      navigateToAndFinish(context, LoginScreen());
      emit(SignOutSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SignOutErrorState());
    });
  }
}
