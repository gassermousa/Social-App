import 'package:dio/dio.dart';
import 'package:social_app/components/constant.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    print('dioHelper Initialized');
    dio = Dio(BaseOptions(
      baseUrl: 'https://student.valuxapps.com/api/',
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response> postData({Map<String, dynamic>? data}) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key = $serverToken'
    };
    return await dio.post(
      'https://fcm.googleapis.com/fcm/send',
      data: data,
    );
  }
}
