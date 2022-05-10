import 'package:flutter/material.dart';
import 'package:social_app/AppCubits/social_Cubits/cubits.dart';
import 'package:social_app/AppCubits/social_Cubits/states.dart';
import 'package:social_app/Network/dio_helper.dart';
import 'package:social_app/Screens/home_screen.dart';
import 'package:social_app/cach_helper/cach_helper.dart';
import 'package:social_app/components/colors.dart';
import 'package:social_app/components/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/components/toast.dart';

import 'Screens/login_screen.dart';
import 'Theme/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  showToast(message: 'onBackgroundMessage', color: successedToast);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DioHelper.init();
  token = await FirebaseMessaging.instance.getToken();

  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await CacheHelper.init();
  Widget? widget;
  uId = CacheHelper.getdata(key: 'UID') != null
      ? CacheHelper.getdata(key: 'UID')
      : null;
  isDark = CacheHelper.getdata(key: 'isDark');

  if (uId != null) {
    widget = Home();
  } else {
    widget = LoginScreen();
  }
  runApp(MyApp(widget, isDark));
}

class MyApp extends StatelessWidget {
  bool? isDark;
  Widget? startWidget;
  MyApp(this.startWidget, this.isDark);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()
        ..getUserDta()
        ..getPosts()
        ..changeMode(fromShared: isDark),
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: LightTheme,
          darkTheme: darkTheme,
          themeMode: SocialCubit.get(context).isDark
              ? ThemeMode.dark
              : ThemeMode.light,
          home: startWidget,
        ),
      ),
    );
  }
}
/*import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String serverToken =
    'AAAAn_TIyyQ:APA91bFfj4S4VEA7ZU3zegTqeNwEODrGePKF7Wh-OsOeJCSb326VxWZ0OER7gV3irug0BJB4IXr_MNgkNtwpjeU58vVmQNByntX_hQDxD8bzFDC94txSITHBzXt22cTkRaq5B4VsrRmX';

final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
Future<bool> sendFcmMessage(
    {String title,
    String message,
    String category,
    String topicName,
    String userToken}) async {
  try {
    final String toParams = "/topics/" + topicName;
    if (userToken == null) {
      debugPrint("sending to topic $toParams");
    }
    const url = 'https://fcm.googleapis.com/fcm/send';
    final header = {
      "Content-Type": "application/json",
      "Authorization": "key=$serverToken",
    };
    var request;

    request = {
      "notification": {
        "title": title,
        "body": message,
        "content_available": true,
        "text": message,
        "android_channel_id": "ChilangoNotifications",
        "sound": "your_sweet_sound.wav",
      },
      "data": {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        "title": "$title",
        "body": "$message",
        "category": "$category",
      },
      "priority": "high",
      "to": topicName == ""
          ? userToken
          : toParams //if no topic assigned then send to specific phone .
    };

    final client = new http.Client();
    final response = await client.post(Uri.parse(url),
        headers: header, body: json.encode(request));

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
*/